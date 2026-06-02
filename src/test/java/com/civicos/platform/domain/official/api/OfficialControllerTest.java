package com.civicos.platform.domain.official.api;

import com.civicos.platform.AbstractIntegrationTest;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.reactive.server.WebTestClient;


class OfficialControllerTest extends AbstractIntegrationTest {

    @Autowired
    private WebTestClient webTestClient;

    @Test
    @DisplayName("NTA department returns current Director General")
    void getOfficials_ntaDepartment_returnsCurrentOfficial() {
        webTestClient
                .get()
                .uri("/api/v1/departments/NTA_CENTRAL/officials")
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.success").isEqualTo(true)
                .jsonPath("$.data[0].fullName").isEqualTo("Pradeep Singh Kharola")
                .jsonPath("$.data[0].postingTitle").isEqualTo("Director General");
    }

    @Test
    @DisplayName("Point-in-time query before posting start returns empty list")
    void getOfficials_asOfBeforePostingStart_returnsEmpty() {
        webTestClient
                .get()
                .uri("/api/v1/departments/NTA_CENTRAL/officials?asOf=2023-01-01")
                .exchange()
                .expectStatus().isOk()
                .expectBody()
                .jsonPath("$.success").isEqualTo(true)
                .jsonPath("$.data").isEmpty();
    }

    @Test
    @DisplayName("Unknown department code returns 404")
    void getOfficials_unknownDepartment_returnsNotFound() {
        webTestClient
                .get()
                .uri("/api/v1/departments/FAKE_DEPT/officials")
                .exchange()
                .expectStatus().isNotFound();
    }
}