package com.civicos.platform.domain.rti.application;

import com.civicos.platform.common.exception.CivicOSException;
import com.civicos.platform.common.exception.ErrorCode;
import com.civicos.platform.domain.department.domain.Department;
import com.civicos.platform.domain.department.domain.DepartmentRepository;
import com.civicos.platform.domain.incident.domain.IncidentCategory;
import com.civicos.platform.domain.incident.domain.IncidentCategoryRepository;
import com.civicos.platform.domain.official.application.OfficialResponse;
import com.civicos.platform.domain.official.application.OfficialService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
public class RtiService {

    private static final String GROQ_URL = "https://api.groq.com/openai/v1/chat/completions";
    private static final String MODEL = "llama-3.3-70b-versatile";

    private final DepartmentRepository departmentRepository;
    private final IncidentCategoryRepository categoryRepository;
    private final OfficialService officialService;
    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    @Value("${groq.api-key:}")
    private String groqApiKey;

    public RtiService(
            DepartmentRepository departmentRepository,
            IncidentCategoryRepository categoryRepository,
            OfficialService officialService) {
        this.departmentRepository = departmentRepository;
        this.categoryRepository = categoryRepository;
        this.officialService = officialService;
        this.objectMapper = new ObjectMapper();
        this.httpClient = HttpClient.newHttpClient();
    }

    public RtiResponse generateRti(RtiRequest request) {
        Department department = departmentRepository.findByCode(request.departmentCode())
                .orElseThrow(() -> new CivicOSException(ErrorCode.DEPARTMENT_NOT_FOUND,
                        "Department not found: " + request.departmentCode()));

        IncidentCategory category = categoryRepository.findByCode(request.categoryCode())
                .orElseThrow(() -> new CivicOSException(ErrorCode.INCIDENT_NOT_FOUND,
                        "Category not found: " + request.categoryCode()));

        List<OfficialResponse> officials = officialService.getCurrentOfficials(department.getId());
        String pioName = officials.isEmpty() ? "Public Information Officer" : officials.get(0).getFullName();
        String pioDesignation = officials.isEmpty() ? "Public Information Officer" : officials.get(0).getPostingTitle();
        String departmentEmail = department.getContactEmail() != null ? department.getContactEmail() : "Not available";

        List<String> questions = generateQuestions(category, department, request.stateCode());
        String draft = buildDraft(request, department, category, pioName, pioDesignation, departmentEmail, questions);

        log.info("RTI draft generated for {} against {} ({} questions)", request.citizenName(), department.getName(), questions.size());

        return new RtiResponse(draft, department.getName(), pioName, pioDesignation,
                category.getDescription(), LocalDate.now(), questions);
    }

    private List<String> generateQuestions(IncidentCategory category, Department department, String stateCode) {
        if (groqApiKey == null || groqApiKey.isBlank()) {
            log.info("Groq API key not set, using template questions");
            return generateFallbackQuestions(category, department);
        }

        try {
            String prompt = String.format("""
                    You are an RTI (Right to Information) expert in India. Generate exactly 4 specific, actionable questions for an RTI application.
                    
                    Department: %s
                    Issue: %s — %s
                    State: %s
                    
                    Rules:
                    - Questions must seek specific documents, records, data, or statistics
                    - Each question should be one clear sentence
                    - Number each question (1., 2., 3., 4.)
                    - Do NOT add any intro or outro text, only the numbered questions
                    - Questions should be legally sound under the RTI Act 2005
                    """, department.getName(), category.getName(),
                    category.getDescription() != null ? category.getDescription() : "",
                    stateCode != null ? stateCode : "India");

            Map<String, Object> body = Map.of(
                    "model", MODEL,
                    "messages", List.of(
                            Map.of("role", "system", "content", "You are an RTI expert. Output only numbered questions."),
                            Map.of("role", "user", "content", prompt)
                    ),
                    "temperature", 0.3,
                    "max_tokens", 500
            );

            HttpRequest httpRequest = HttpRequest.newBuilder()
                    .uri(URI.create(GROQ_URL))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + groqApiKey)
                    .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(body)))
                    .build();

            HttpResponse<String> response = httpClient.send(httpRequest, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() != 200) {
                log.warn("Groq API returned status {} for RTI questions", response.statusCode());
                return generateFallbackQuestions(category, department);
            }

            JsonNode root = objectMapper.readTree(response.body());
            String content = root.path("choices").path(0).path("message").path("content").asText("");

            return Arrays.stream(content.split("\n"))
                    .map(line -> line.replaceAll("^\\d+\\.\\s*", "").trim())
                    .filter(line -> line.length() > 10)
                    .limit(4)
                    .collect(Collectors.toList());

        } catch (Exception e) {
            log.warn("Groq RTI question generation failed, using templates: {}", e.getMessage());
            return generateFallbackQuestions(category, department);
        }
    }

    private List<String> generateFallbackQuestions(IncidentCategory category, Department department) {
        String issue = category.getName().toLowerCase();
        return List.of(
                String.format("What is the total number of complaints or reports received regarding %s by %s in the last 12 months?", issue, department.getName()),
                String.format("How many of the complaints regarding %s were resolved, and what was the average resolution time?", issue),
                String.format("What specific actions or measures has %s taken to address issues related to %s? Please provide relevant circulars or orders.", department.getName(), issue),
                String.format("What is the total budget allocated and spent by %s for addressing %s in the current and previous financial year?", department.getName(), issue)
        );
    }

    private String buildDraft(RtiRequest request, Department department, IncidentCategory category,
                              String pioName, String pioDesignation, String departmentEmail,
                              List<String> questions) {
        String date = LocalDate.now().format(DateTimeFormatter.ofPattern("dd MMMM, yyyy"));
        String jurisdiction = department.getJurisdictionLevel().name();
        String state = request.stateCode() != null ? request.stateCode().toUpperCase() : "";

        StringBuilder sb = new StringBuilder();

        sb.append("Date: ").append(date).append("\n\n");

        sb.append("To,\n");
        sb.append("The Public Information Officer (CPIO)\n");
        sb.append(department.getName()).append("\n");
        if (!state.isBlank()) {
            sb.append(state).append("\n");
        }
        if (departmentEmail != null && !departmentEmail.isBlank()) {
            sb.append("Email: ").append(departmentEmail).append("\n");
        }
        sb.append("\n");

        sb.append("From,\n");
        sb.append(request.citizenName()).append("\n");
        if (request.citizenAddress() != null && !request.citizenAddress().isBlank()) {
            sb.append(request.citizenAddress()).append("\n");
        }
        if (request.citizenEmail() != null && !request.citizenEmail().isBlank()) {
            sb.append("Email: ").append(request.citizenEmail()).append("\n");
        }
        sb.append("\n");

        sb.append("Subject: Application under the Right to Information Act, 2005\n\n");

        sb.append("Respected Sir/Madam,\n\n");
        sb.append("Under Section 6(1) of the Right to Information Act, 2005, I hereby request the following information pertaining to ");
        sb.append(category.getName());
        sb.append(" under the jurisdiction of ").append(department.getName()).append(":\n\n");

        for (int i = 0; i < questions.size(); i++) {
            sb.append(i + 1).append(". ").append(questions.get(i)).append("\n");
        }
        sb.append("\n");

        sb.append("I am a citizen of India and the information sought is not covered under any of the exemptions listed in Sections 8 or 9 of the RTI Act, 2005.\n\n");

        sb.append("A sum of Rs. 10/- (Rupees Ten Only) is enclosed as the application fee, payable via postal order or demand draft in favour of ");
        sb.append(department.getName()).append(".\n\n");

        sb.append("As per Section 7(1) of the RTI Act, 2005, I request that the information be provided within 30 days of receipt of this application. ");
        sb.append("In case the information pertains to a matter concerning a person's life or liberty, the same may be provided within 48 hours.\n\n");

        sb.append("If any part of this application falls under the jurisdiction of another public authority, please transfer the same under Section 6(3) of the RTI Act and inform me accordingly.\n\n");

        sb.append("Thank you.\n\n");
        sb.append("Yours faithfully,\n\n\n");
        sb.append(request.citizenName()).append("\n");
        sb.append(LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))).append("\n");

        return sb.toString();
    }
}