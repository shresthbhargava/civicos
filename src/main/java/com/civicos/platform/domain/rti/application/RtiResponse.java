package com.civicos.platform.domain.rti.application;

import java.time.LocalDate;
import java.util.List;

public record RtiResponse(
        String draftText,
        String departmentName,
        String pioName,
        String pioDesignation,
        String categoryDescription,
        LocalDate generatedDate,
        List<String> questions
) {}