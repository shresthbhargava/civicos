package com.civicos.platform.common.kafka;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class SearchEventProducer {

    private static final String TOPIC = "civicos.search.events";
    private final KafkaTemplate<String, SearchEvent> kafkaTemplate;

    public void publishSearchEvent(SearchEvent event) {
        kafkaTemplate.send(TOPIC, event.getQuery(), event)
                .whenComplete((result, ex) -> {
                    if (ex != null) {
                        log.warn("Failed to publish search event: {}", ex.getMessage());
                    } else {
                        log.debug("Published search event for query: {}", event.getQuery());
                    }
                });
    }
}