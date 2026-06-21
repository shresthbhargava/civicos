package com.civicos.platform.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.info.License;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI civicOSOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("CivicOS API")
                        .description("""
                                AI-powered civic intelligence platform for India.
                                
                                Find accountable government departments, currently posted officials,
                                relevant laws, and citizen complaint actions for any civic issue.
                                
                                Built with Java 21, Spring Boot, PostgreSQL, Redis, Kafka, pgvector.
                                """)
                        .version("1.0.0")
                        .contact(new Contact()
                                .name("Shresth Bhargava")
                                .url("https://github.com/shresthbhargava/civicos"))
                        .license(new License()
                                .name("MIT")
                                .url("https://opensource.org/licenses/MIT")))
                .servers(List.of(
                        new Server()
                                .url("https://civicos-r2sf.onrender.com")
                                .description("Production"),
                        new Server()
                                .url("http://localhost:8080")
                                .description("Local Development")
                ));
    }
}