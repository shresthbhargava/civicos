package com.civicos.platform.domain.project.domain;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.civicos.platform.domain.project.domain.GovernmentProject.ProjectStatus;

import java.util.List;
import java.util.Optional;

@Repository
public interface GovernmentProjectRepository extends JpaRepository<GovernmentProject, Long> {

    Optional<GovernmentProject> findBySlug(String slug);

    List<GovernmentProject> findByStatusOrderByTotalBudgetCrDesc(ProjectStatus status);

    List<GovernmentProject> findByCategory(String category);

    @Query("SELECT p FROM GovernmentProject p WHERE p.status != 'COMPLETED' ORDER BY p.totalBudgetCr DESC")
    List<GovernmentProject> findActiveProjects();

    List<GovernmentProject> findAllByOrderByTotalBudgetCrDesc();
}