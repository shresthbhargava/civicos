package com.civicos.platform.domain.project.application;

import com.civicos.platform.domain.project.domain.GovernmentProject;
import com.civicos.platform.domain.project.domain.GovernmentProjectRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProjectService {

    private final GovernmentProjectRepository repository;

    @Transactional(readOnly = true)
    public List<ProjectResponse> getAllProjects() {
        return repository.findAllByOrderByTotalBudgetCrDesc().stream()
                .map(ProjectResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public List<ProjectResponse> getActiveProjects() {
        return repository.findActiveProjects().stream()
                .map(ProjectResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public List<ProjectResponse> getByStatus(String status) {
        return repository.findByStatusOrderByTotalBudgetCrDesc(
                GovernmentProject.ProjectStatus.valueOf(status.toUpperCase())
        ).stream().map(ProjectResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public ProjectResponse getBySlug(String slug) {
        return repository.findBySlug(slug)
                .map(ProjectResponse::from).orElse(null);
    }
}