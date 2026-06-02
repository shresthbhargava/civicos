package com.civicos.platform.common.exception;

import lombok.Getter;

@Getter
public class CivicOSException extends RuntimeException {

    private final ErrorCode errorCode;
    private final String message;

    public CivicOSException(ErrorCode errorCode) {
        super(errorCode.getDefaultMessage());
        this.errorCode = errorCode;
        this.message = errorCode.getDefaultMessage();
    }

    public CivicOSException(ErrorCode errorCode, String message) {
        super(message);
        this.errorCode = errorCode;
        this.message = message;
    }

    public CivicOSException(ErrorCode errorCode, String message, Throwable cause) {
        super(message, cause);
        this.errorCode = errorCode;
        this.message = message;
    }
}