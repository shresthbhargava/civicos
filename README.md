# CivicOS — AI-Powered Civic Intelligence Platform

> Know who's accountable. Every civic issue. Every Indian citizen.

[![Java](https://img.shields.io/badge/Java-21-orange)](https://openjdk.org/projects/jdk/21/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.x-green)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow)](LICENSE)

## What is CivicOS?

CivicOS is a civic intelligence platform that helps Indian citizens identify accountable government departments, currently posted officials, relevant laws, and exact complaint actions for any civic issue — all from a single plain-language search.

**You type:** `"exam leak"`

**CivicOS returns:**
- ✅ Responsible department — National Testing Agency
- ✅ Current official — Pradeep Singh Kharola, Director General (dg@nta.ac.in)
- ✅ Accountability chain — NTA → Ministry of Education
- ✅ Relevant law — Right to Information Act, 2005
- ✅ Citizen actions — exactly where to file complaints

## Live Demo

🌐 **Frontend:** [civicos-frontend.vercel.app](https://civicos-frontend.vercel.app)

📦 **Frontend repo:** [github.com/shresthbhargava/civicos-frontend](https://github.com/shresthbhargava/civicos-frontend)

## Features

- **Jurisdiction-aware routing** — automatically resolves district → state → central department fallback
- **Recursive accountability chain** — PostgreSQL CTEs traverse the full hierarchy from department to ministry
- **Temporal official postings** — database-enforced exclusion constraints prevent overlapping active postings; point-in-time queries supported
- **Acts & Laws mapper** — every incident category linked to governing legislation
- **Citizen action guides** — exact complaint portals, RTI links, grievance channels
- **Request tracing** — every API response carries a traceId for debugging
- **Integration tested** — 10 tests running against real PostgreSQL via Testcontainers

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 |
| Framework | Spring Boot 3.x |
| Database | PostgreSQL 16 |
| Migrations | Flyway |
| ORM | Spring Data JPA / Hibernate |
| Testing | JUnit 5, Testcontainers |
| Containerization | Docker |
| Build | Gradle |

## Architecture

```
React Frontend
      │
      ▼
Spring Boot REST API
      │
      ├── Incident Search Service
      │       ├── Keyword tokenizer
      │       ├── GIN-indexed search
      │       └── Jurisdiction resolver
      │
      ├── Accountability Service
      │       └── Recursive CTE chain builder
      │
      ├── Official Service
      │       └── Temporal posting queries
      │
      └── Acts Service
              └── Legislation mapper
      │
      ▼
PostgreSQL 16
      ├── departments (self-referential hierarchy)
      ├── incident_categories (GIN-indexed keywords)
      ├── incident_category_departments (jurisdiction mapping)
      ├── officials (officer registry)
      ├── official_postings (temporal with exclusion constraints)
      ├── acts (legislation registry)
      └── incident_category_acts (incident-law mapping)
```
## API Endpoints

### Search Incidents
GET /api/v1/incidents/search?query={query}&stateCode={state}&districtCode={district}

**Example:**
```bash
curl "http://localhost:8080/api/v1/incidents/search?query=exam+leak"
```

**Response:**
```json
{
  "success": true,
  "data": {
    "query": "exam leak",
    "matches": [{
      "categoryName": "Examination Irregularity",
      "responsibleDepartment": {
        "name": "National Testing Agency",
        "currentOfficials": [{
          "fullName": "Pradeep Singh Kharola",
          "postingTitle": "Director General",
          "contactEmail": "dg@nta.ac.in"
        }]
      },
      "accountabilityChain": [...],
      "citizenActions": [...],
      "relevantActs": [{
        "name": "Right to Information Act",
        "year": 2005,
        "officialUrl": "https://rtionline.gov.in"
      }]
    }]
  }
}
```

### Get Department Officials
GET /api/v1/departments/{code}/officials
GET /api/v1/departments/{code}/officials?asOf=2024-01-15

## Getting Started

### Prerequisites
- Java 21
- Docker Desktop
- Git

### Run locally

**1. Clone the repo:**
```bash
git clone https://github.com/shresthbhargava/civicos.git
cd civicos
```

**2. Start PostgreSQL:**
```bash
docker-compose up -d
```

**3. Run the application:**
```bash
./gradlew bootRun
```

**4. Test the API:**
```bash
curl "http://localhost:8080/api/v1/incidents/search?query=exam+leak"
```

### Run Tests
```bash
./gradlew test
```

Tests use Testcontainers — Docker must be running.

## Database Design Highlights

**Temporal official postings** — the database physically prevents two active officials for the same department using PostgreSQL exclusion constraints:

```sql
EXCLUDE USING gist (
  department_id WITH =,
  daterange(start_date, COALESCE(end_date, '9999-12-31'), '[]') WITH &&
)
```

**Recursive accountability chain** — single CTE query traverses the full hierarchy:

```sql
WITH RECURSIVE accountability_chain AS (
  SELECT id, name, code, parent_department_id, 0 AS depth
  FROM departments WHERE id = :departmentId
  UNION ALL
  SELECT d.id, d.name, d.code, d.parent_department_id, ac.depth + 1
  FROM departments d
  INNER JOIN accountability_chain ac ON d.id = ac.parent_department_id
)
SELECT * FROM accountability_chain ORDER BY depth ASC
```

## Project Structure

```
src/main/java/com/civicos/platform/
├── common/
│   ├── exception/        # Global exception handling
│   ├── logging/          # Request tracing
│   └── response/         # API response envelope
├── config/               # CORS, Security config
── domain/
├── act/              # Acts & Laws
├── department/       # Department hierarchy
├── incident/         # Incident search
└── official/         # Officials & postings
```
## Built With ❤️ for India

CivicOS was built to solve a real problem — 1.4 billion Indians deserve to know who is accountable for their civic issues.

Built by [Shresth Bhargava](https://github.com/shresthbhargava) 
