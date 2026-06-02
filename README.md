# CivicOS — AI-Powered Civic Intelligence Platform

A backend platform that helps Indian citizens identify accountable government 
departments, officials, and complaint channels for any civic issue.

## What it does
- Keyword-based incident search with jurisdiction-aware routing
- Recursive accountability chain (department → ministry → central body)
- Current official postings with temporal data modeling
- Point-in-time queries for historical accountability

## Tech Stack
Java 21 · Spring Boot · PostgreSQL · Flyway · Testcontainers · Docker

## Architecture
Vertical slice package structure with domain isolation.
Each domain owns its full layer: API → Application → Domain → Infrastructure.
