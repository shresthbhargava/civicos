package com.civicos.platform.common.exception;

import org.springframework.http.HttpStatus;

public enum ErrorCode {

    // Generic
    INTERNAL_SERVER_ERROR("INTERNAL_SERVER_ERROR", "An unexpected error occurred", HttpStatus.INTERNAL_SERVER_ERROR),
    VALIDATION_FAILED("VALIDATION_FAILED", "Request validation failed", HttpStatus.BAD_REQUEST),
    RESOURCE_NOT_FOUND("RESOURCE_NOT_FOUND", "The requested resource was not found", HttpStatus.NOT_FOUND),
    BAD_REQUEST("BAD_REQUEST", "Invalid request", HttpStatus.BAD_REQUEST),

    // Domain - Incident
    INCIDENT_NOT_FOUND("INCIDENT_NOT_FOUND", "Incident not found", HttpStatus.NOT_FOUND),

    // Domain - Department
    DEPARTMENT_NOT_FOUND("DEPARTMENT_NOT_FOUND", "Department not found", HttpStatus.NOT_FOUND),
    DEPARTMENT_ALREADY_EXISTS("DEPARTMENT_ALREADY_EXISTS", "Department already exists", HttpStatus.CONFLICT);

    private final String code;
    private final String defaultMessage;
    private final HttpStatus httpStatus;

    ErrorCode(String code, String defaultMessage, HttpStatus httpStatus) {
        this.code = code;
        this.defaultMessage = defaultMessage;
        this.httpStatus = httpStatus;
    }

    public String getCode() { return code; }
    public String getDefaultMessage() { return defaultMessage; }
    public HttpStatus getHttpStatus() { return httpStatus; }
}