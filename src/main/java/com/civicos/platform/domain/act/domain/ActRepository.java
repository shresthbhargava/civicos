package com.civicos.platform.domain.act.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ActRepository extends JpaRepository<Act, Long> {

    @Query(value = """
        SELECT a.* FROM acts a
        INNER JOIN incident_category_acts ica ON ica.act_id = a.id
        WHERE ica.incident_category_id = :categoryId
        AND a.active = true
    """, nativeQuery = true)
    List<Act> findByCategoryId(@Param("categoryId") Long categoryId);
}