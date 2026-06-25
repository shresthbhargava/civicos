package com.civicos.platform;

import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.test.annotation.DirtiesContext;
import org.springframework.test.context.ActiveProfiles;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import com.civicos.platform.common.kafka.SearchEventProducer;

import org.springframework.test.context.bean.override.mockito.MockitoBean;

import org.springframework.kafka.core.KafkaTemplate;


@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
@Testcontainers
@DirtiesContext(classMode = DirtiesContext.ClassMode.AFTER_CLASS)
public abstract class AbstractIntegrationTest {

    @Container
    @ServiceConnection
    static final PostgreSQLContainer<?> postgres =
            new PostgreSQLContainer<>("pgvector/pgvector:pg16")
                    .withDatabaseName("civicos_test")
                    .withUsername("civicos")
                    .withPassword("civicos");

    // Without this, any @Cacheable method (e.g. IncidentSearchService.search)
    // throws RedisConnectionFailureException in tests, since there's no
    // Redis to connect to. That exception was being silently swallowed by
    // a broad catch block in DailyEditionService, making a real bug look
    // like "no accountability match found" instead of a missing test dependency.
    @Container
    @ServiceConnection(name = "redis")
    static final GenericContainer<?> redis =
            new GenericContainer<>("redis:7-alpine")
                    .withExposedPorts(6379);

    @MockitoBean
    private KafkaTemplate<String,Object> kafkaTemplate;

    @MockitoBean
    private SearchEventProducer searchEventProducer;
}