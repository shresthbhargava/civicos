package com.civicos.platform.domain.incident.api;

import com.civicos.platform.common.response.ApiResponse;
import com.civicos.platform.domain.incident.application.IncidentSearchResponse;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.reactive.server.WebTestClient;
import com.civicos.platform.AbstractIntegrationTest;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;


class IncidentSearchControllerTest extends AbstractIntegrationTest {

    @Autowired
    private WebTestClient webTestClient;
    @Test
    @DisplayName("Water supply search with Maharashtra state routes to state department")
    void search_waterSupply_stateRouting_returnsMaharashtraDepartment() {


        webTestClient
                .get()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/v1/incidents/search")
                        .queryParam("query", "water supply")
                        .queryParam("stateCode", "MH")
                        .build())
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.success").isEqualTo(true)
                .jsonPath("$.data.matches[0].responsibleDepartment.code")
                .isEqualTo("WATER_STATE_MH");


    }

    @Test
    @DisplayName("Water supply search with Pune district routes to district department")
    void search_waterSupply_districtRouting_returnsPuneDistrictDepartment() {


        webTestClient
                .get()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/v1/incidents/search")
                        .queryParam("query", "water supply")
                        .queryParam("stateCode", "MH")
                        .queryParam("districtCode", "MH-PUNE")
                        .build())
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.success").isEqualTo(true)
                .jsonPath("$.data.matches[0].responsibleDepartment.code")
                .isEqualTo("WATER_DISTRICT_MH_PUNE");


    }

    @Test
    @DisplayName("Search for exam leak returns NTA as responsible department")
    void search_examLeak_returnsNtaDepartment() {
        ApiResponse<IncidentSearchResponse> response = webTestClient
                .get()
                .uri("/api/v1/incidents/search?query=exam+leak")
                .exchange()
                .expectStatus().isOk()
                .expectBody(new ParameterizedTypeReference<
                        ApiResponse<IncidentSearchResponse>>() {})
                .returnResult()
                .getResponseBody();

        assertThat(response).isNotNull();
        assertThat(response.isSuccess()).isTrue();
        assertThat(response.getData().getMatches()).isNotEmpty();

        IncidentSearchResponse.IncidentMatch match =
                response.getData().getMatches().get(0);

        assertThat(match.getCategoryCode()).isEqualTo("EXAM_IRREGULARITY");
        assertThat(match.getResponsibleDepartment().getCode())
                .isEqualTo("NTA_CENTRAL");
        assertThat(match.getMatchedKeywords()).contains("exam", "leak");
        assertThat(match.getAccountabilityChain()).hasSize(2);
        assertThat(match.getAccountabilityChain().get(0).getCode())
                .isEqualTo("NTA_CENTRAL");
        assertThat(match.getAccountabilityChain().get(1).getCode())
                .isEqualTo("MIN_EDUCATION_CENTRAL");
        assertThat(match.getCitizenActions()).isNotEmpty();
    }

    @Test
    @DisplayName("Search with no matching keywords returns empty matches")
    void search_noMatch_returnsEmptyList() {
        ApiResponse<IncidentSearchResponse> response = webTestClient
                .get()
                .uri("/api/v1/incidents/search?query=quantum+physics")
                .exchange()
                .expectStatus().isOk()
                .expectBody(new ParameterizedTypeReference<
                        ApiResponse<IncidentSearchResponse>>() {})
                .returnResult()
                .getResponseBody();

        assertThat(response).isNotNull();
        assertThat(response.isSuccess()).isTrue();
        assertThat(response.getData().getMatches()).isEmpty();
    }

    @Test
    @DisplayName("Search with query shorter than 3 characters returns 400")
    void search_shortQuery_returnsBadRequest() {
        webTestClient
                .get()
                .uri("/api/v1/incidents/search?query=ab")
                .exchange()
                .expectStatus().isBadRequest()
                .expectBody()
                .jsonPath("$.success").isEqualTo(false)
                .jsonPath("$.error.code").isEqualTo("BAD_REQUEST");
    }

    @Test
    @DisplayName("Search with injection attempt returns empty matches safely")
    void search_injectionAttempt_returnsEmptySafely() {
        webTestClient
                .get()
                .uri(uriBuilder -> uriBuilder
                        .path("/api/v1/incidents/search")
                        .queryParam("query", "exam} OR 1=1 --")
                        .build())
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.success").isEqualTo(true)
                .jsonPath("$.data.matches").isEmpty();
    }

    @Test
    @DisplayName("Every response contains a traceId in meta")
    void search_anyRequest_containsTraceId() {
        webTestClient
                .get()
                .uri("/api/v1/incidents/search?query=exam")
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.meta.traceId").exists()
                .jsonPath("$.meta.timestamp").exists()
                .jsonPath("$.meta.path").isEqualTo("/api/v1/incidents/search");
    }
}