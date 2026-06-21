package com.civicos.platform.common.kafka;

import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class SearchEventConsumer {

    @KafkaListener(topics = "civicos.search.events", groupId = "civicos-analytics")
    public void consume(SearchEvent event) {
        log.info("ANALYTICS | query='{}' state='{}' matches={} topCategory='{}' timestamp={}",
                event.getQuery(),
                event.getStateCode(),
                event.getMatchCount(),
                event.getTopCategory(),
                event.getTimestamp()
        );
    }
}