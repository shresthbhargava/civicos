package com.civicos.platform.domain.news.domain;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

import java.time.LocalDate;
@Repository


public interface DailyEditionRepository extends JpaRepository<DailyEdition,Integer> {
    Optional<DailyEdition> findByEditionDate(LocalDate date);
    Optional<DailyEdition> findTopByOrderByEditionDateDesc();
}
