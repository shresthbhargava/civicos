package com.civicos.platform.common.response;

import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.MDC;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;

import java.time.Instant;

@Getter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

    private final boolean success;
    private final T data;
    private final ApiError error;
    private final ApiMeta meta;

    private ApiResponse(boolean success, T data, ApiError error, ApiMeta meta) {
        this.success = success;
        this.data = data;
        this.error = error;
        this.meta = meta;
    }

    // OLD VERSION (keep only one copy)
    public static <T> ApiResponse<T> success(T data, String traceId, String path) {
        return new ApiResponse<>(true, data, null, ApiMeta.of(traceId, path));
    }

    public static <T> ApiResponse<T> failure(ApiError error, String traceId, String path) {
        return new ApiResponse<>(false, null, error, ApiMeta.of(traceId, path));
    }

    // NEW VERSION
    public static <T> ApiResponse<T> success(T data, HttpServletRequest request) {
        return new ApiResponse<>(
                true,
                data,
                null,
                ApiMeta.of(MDC.get("traceId"), request.getRequestURI())
        );
    }

    public static <T> ApiResponse<T> failure(ApiError error, HttpServletRequest request) {
        return new ApiResponse<>(
                false,
                null,
                error,
                ApiMeta.of(MDC.get("traceId"), request.getRequestURI())
        );
    }

    @Getter
    @JsonInclude(JsonInclude.Include.NON_NULL)
    public static class ApiError {
        private final String code;
        private final String message;
        private final Object details;

        public ApiError(String code, String message, Object details) {
            this.code = code;
            this.message = message;
            this.details = details;
        }
    }

    @Getter
    public static class ApiMeta {
        private final String traceId;
        private final String timestamp;
        private final String path;

        private ApiMeta(String traceId, String path) {
            this.traceId = traceId;
            this.timestamp = Instant.now().toString();
            this.path = path;
        }

        public static ApiMeta of(String traceId, String path) {
            return new ApiMeta(traceId, path);
        }
    }
}