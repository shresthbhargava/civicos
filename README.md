# CivicOS
AI-Powered Civic Intelligence Platform

Know who's accountable. Every civic issue. Every Indian citizen.

**Java 21 · Spring Boot 3.5 · PostgreSQL · React 19 · CI/CD · MIT License**

**Live Demo · API Docs · GitLab**

---

## Overview

CivicOS empowers **1.4 billion Indian citizens** to identify exactly who is responsible for any civic issue. A single plain-language search resolves to the accountable government department, the currently posted official with contact details, governing legislation, and actionable steps to file complaints — all in under **200ms**.

The platform features **The Civic Record**, a newspaper-style frontend that aggregates real-time civic news with AI-matched accountability data, and an integrated complaint filing system with real-time status tracking.

## What a Search Returns

**Input:** `exam leak`

| Field | Result |
|-------|--------|
| Responsible Department | National Testing Agency |
| Current Official | Pradeep Singh Kharola, Director General — dg@nta.ac.in |
| Accountability Chain | NTA → Ministry of Education |
| Governing Law | Right to Information Act, 2005 |
| Complaint Portal | RTI Online |
| Citizen Actions | File RTI → Contact NTA grievance cell → Escalate to MoE |

## Architecture

```text
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                              The Civic Record (Frontend)                                    │
│                         React 19 • Vite • Vercel • TypeScript                               │
│                                                                                             │
│   ┌──────────────────────┐                 ┌──────────────────────────────┐                 │
│   │  India Map Search    │                 │   Complaint System           │                 │
│   │  • Location Search   │                 │  • File Complaint            │                 │
│   │  • Incident Search   │                 │  • Track Complaint           │                 │
│   │  • Filters           │                 │  • Status Timeline           │                 │
│   └──────────┬───────────┘                 └──────────────┬───────────────┘                 │
└──────────────┼────────────────────────────────────────────┼──────────────────────────────────┘
               │                                            │
               ▼                                            ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                            CivicOS Backend API (Spring Boot 3.5)                            │
│                              Java 21 • Render • GitLab CI/CD                                │
│                                                                                             │
│  ┌────────────────────────────┐      ┌───────────────────────────────────────────────────┐  │
│  │      Incident Search       │      │              Complaint Service                    │  │
│  │────────────────────────────│      │───────────────────────────────────────────────────│  │
│  │ 1. Keyword Search (GIN)    │      │ • File Complaint                                 │  │
│  │ 2. Semantic Search         │      │ • Generate Tracking ID                           │  │
│  │    (pgvector)              │      │ • Track Complaint                                │  │
│  │ 3. LLM Classification      │      │ • Status Timeline                                │  │
│  │    (Groq Llama 3.3 70B)    │      │ • Government Portal Linking                      │  │
│  └────────────────────────────┘      └───────────────────────────────────────────────────┘  │
│                                                                                             │
│  ┌────────────────────────────┐      ┌───────────────────────────────────────────────────┐  │
│  │ Accountability Engine      │      │              News & Daily Edition                 │  │
│  │────────────────────────────│      │───────────────────────────────────────────────────│  │
│  │ • Recursive CTE            │      │ • NewsData.io Aggregation                        │  │
│  │ • Department Hierarchy     │      │ • AI Department Mapping                          │  │
│  │ • Governing Acts           │      │ • Daily Newspaper Generation                     │  │
│  │ • Jurisdiction Lookup      │      │ • Front Page Rendering                           │  │
│  └────────────────────────────┘      └───────────────────────────────────────────────────┘  │
│                                                                                             │
│  ┌────────────────────────────┐                                                          │
│  │ Official Posting Service   │                                                          │
│  │────────────────────────────│                                                          │
│  │ • Temporal Queries         │                                                          │
│  │ • Current Officials        │                                                          │
│  │ • Historical Records       │                                                          │
│  └────────────────────────────┘                                                          │
│                                                                                             │
│                           Apache Kafka → Search Analytics                                   │
└───────────────────────────────────────────────┬─────────────────────────────────────────────┘
                                                │
                                                ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────┐
│                           Supabase PostgreSQL 16 + pgvector                                 │
│─────────────────────────────────────────────────────────────────────────────────────────────│
│                                                                                             │
│  • departments                 • officials                 • official_postings             │
│  • incident_categories          • complaints               • complaint_status_history      │
│  • news_articles                • daily_editions           • acts                          │
│  • embeddings                   • search_analytics         • jurisdictions                │
│                                                                                             │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
```

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| **Frontend** | React 19, Vite | Newspaper-style SPA |
| **Backend** | Java 21, Spring Boot 3.5 | REST API |
| **Database** | PostgreSQL 16 (Supabase) | Primary data store |
| **Migrations** | Flyway | Schema versioning |
| **ORM** | Spring Data JPA, Hibernate | Data access |
| **Search** | GIN indexes, pgvector | Keyword + semantic search |
| **LLM** | Groq (Llama 3.3 70B) | Classification fallback |
| **Embeddings** | Ollama (nomic-embed-text) | Vector search |
| **News** | NewsData.io API | Real-time civic news |
| **Events** | Apache Kafka | Search analytics |
| **CI/CD** | GitLab | Build, test, SAST, secret detection |
| **Frontend Hosting** | Vercel | Auto-deploy on push |
| **Backend Hosting** | Render | Auto-deploy on push |
| **Testing** | JUnit 5, Testcontainers | Integration tests |

---

## Features

### Three-Tier Search

Every query passes through three layers before returning "no match":

| Tier | Method | Latency | Coverage |
|------|--------|---------|----------|
| 1 | GIN-indexed keyword match | ~5ms | Exact keyword hits |
| 2 | pgvector embedding similarity | ~50ms | Semantic matches |
| 3 | Groq Llama 3.3 70B classification | ~800ms | Fuzzy / out-of-vocabulary |

## Complaint Lifecycle

```text
┌────────────────────────────────────────────────────────────────────────────┐
│                         Complaint Processing Pipeline                      │
└────────────────────────────────────────────────────────────────────────────┘

        ┌──────────────┐
        │  SUBMITTED   │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │ACKNOWLEDGED  │
        └───┬──────┬───┘
            │      │
            │      └─────────────────────────────┐
            ▼                                    ▼
    ┌──────────────┐                     ┌──────────────┐
    │ IN_PROGRESS  │                     │   REJECTED   │
    └───┬──────┬───┘                     └──────────────┘
        │      │
        │      └─────────────────────────────┐
        ▼                                    ▼
┌──────────────┐                     ┌──────────────┐
│  RESOLVED    │                     │   REJECTED   │
└──────────────┘                     └──────────────┘

Status Flow:
SUBMITTED → ACKNOWLEDGED → IN_PROGRESS → RESOLVED
                │                 │
                └──────► REJECTED ◄──────┘
```


- Auto-generated tracking IDs (`CIV-YYYY-NNNNN`)
- Transaction-safe filing with duplicate-key retry (`REQUIRES_NEW` propagation)
- Real-time tracking with visual status timeline
- Direct links to official government complaint portals

### Daily News Edition

- Aggregates civic news from 1000+ Indian sources via NewsData.io
- AI-matches each article to accountable departments
- Generates a newspaper-style front page with accountability overlay
- Manual refresh capability from the frontend

---

## API Reference

### Incident Search

```bash
# Search with jurisdiction context
curl "https://civicos-r2sf.onrender.com/api/v1/incidents/search?query=exam+leak&stateCode=DL&districtCode=ND"

# Track a complaint
curl "https://civicos-r2sf.onrender.com/api/v1/complaints/track/CIV-2026-00001"
````
## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/v1/incidents/search` | Three-tier incident search |
| `GET` | `/api/v1/departments/{code}/officials` | Current officials |
| `GET` | `/api/v1/departments/{code}/officials?asOf={date}` | Point-in-time officials |
| `POST` | `/api/v1/complaints?categoryCode=X&departmentCode=Y` | File a complaint |
| `GET` | `/api/v1/complaints/track/{id}` | Track complaint status |
| `PATCH` | `/api/v1/complaints/{id}/status?newStatus=X` | Update complaint status |
| `GET` | `/api/v1/news/latest` | Latest civic news |
| `GET` | `/api/v1/news/edition/today` | Today's front page |
| `POST` | `/api/v1/news/edition/generate?force=true` | Regenerate edition |
| `POST` | `/api/v1/news/fetch` | Trigger news fetch |



## Project Structure

```text
src/main/java/com/civicos/platform/
├── common/
│   ├── ai/                    # EmbeddingService, LlmClassificationService
│   ├── exception/             # Global exception handling, ErrorCode enum
│   ├── kafka/                 # SearchEventProducer, SearchEvent
│   ├── logging/               # Request tracing filter
│   └── response/              # ApiResponse envelope
├── config/                    # CORS, security, web configuration
└── domain/
    ├── act/                   # Acts & Legislation
    │   ├── api/               # REST controller
    │   ├── application/       # ActService, ActResponse
    │   └── domain/            # Act entity, ActRepository
    ├── complaint/             # Complaint System
    │   ├── api/               # ComplaintController
    │   ├── application/       # ComplaintService, ComplaintResponse
    │   └── domain/            # Complaint entity, ComplaintRepository
    ├── department/            # Department Hierarchy
    │   ├── api/               # DepartmentController
    │   ├── application/       # AccountabilityService, AccountabilityNode
    │   └── domain/            # Department entity, recursive CTE queries
    ├── incident/              # Incident Search
    │   ├── api/               # IncidentController
    │   ├── application/       # IncidentSearchService (3-tier)
    │   └── domain/            # IncidentCategory, GIN/vector queries
    ├── news/                  # News & Edition
    │   ├── api/               # NewsController
    │   ├── application/       # NewsFetchService, DailyEditionService
    │   └── domain/            # NewsArticle, DailyEdition entities
    └── official/              # Officials & Postings
        ├── api/               # OfficialController
        ├── application/       # OfficialService
        └── domain/            # Official entity, temporal queries
```

## Database Highlights

Temporal Postings with Physical Guarantees
PostgreSQL exclusion constraints prevent two active officials for the same department — enforced at the database level, not just application logic:

```sql
EXCLUDE USING gist (
  department_id WITH =,
  daterange(start_date, COALESCE(end_date,'9999-12-31'),'[]') WITH &&
)
```

### Recursive Accountability

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

## Getting Started

### Prerequisites

- Java 21
- Docker Desktop
- Git
- Groq API Key
- NewsData.io API Key
- Supabase

### Run

```bash
# Clone
git clone https://gitlab.com/shresthbhargava/civic-record.git
cd civic-record

# Environment variables
export GROQ_API_KEY=gsk_xxx
export NEWSDATA_API_KEY=xxx
export SPRING_DATASOURCE_URL=jdbc:postgresql://...
export SPRING_DATASOURCE_USERNAME=postgres
export SPRING_DATASOURCE_PASSWORD=xxx

# Start local PostgreSQL
docker-compose up -d

# Run
./gradlew bootRun
```

### Tests

```bash
./gradlew test
```
Tests use Testcontainers — Docker must be running.

## CI/CD

GitLab pipelines run automatically on every push:

| Stage | Jobs | What it does |
|-------|------|-------------|
| `build` | compileJava | Compilation check |
| `test` | test | JUnit 5 + Testcontainers |
| `security` | sast, secret_detection | Vulnerability & secret scanning |

## Deployment

| Component | Platform |
|-----------|----------|
| Frontend | Vercel |
| Backend | Render |
| Database | Supabase |
| CI/CD | GitLab |

## License

MIT License.

---

<div align="center">

**Built with determination for 1.4 billion citizens.**

**Built by Shresth Bhargava**

</div>
