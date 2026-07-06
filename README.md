# Abeacon

Abeacon is a self-hosted OSINT (Open Source Intelligence) and reconnaissance platform for collecting, organizing, searching, and analyzing publicly available information.

The platform is designed around a modular architecture that separates data collection, enrichment, storage, indexing, and analysis, making it suitable for security research, investigations, threat intelligence, and reconnaissance workflows.

## Status

Abeacon is currently under active development.

### Implemented

- Authentication and authorization
- User management
- FastAPI backend foundation
- PostgreSQL persistence layer
- Redis integration
- Meilisearch integration
- MinIO object storage integration

### Planned Capabilities

- Domain intelligence
- WHOIS and DNS enrichment
- IP intelligence
- Username investigations
- Email intelligence
- Search aggregation
- Investigation workspaces
- Evidence management
- Audit logging
- Reporting and exports

## Design Goals

- Self-hosted and extensible
- API-first architecture
- Modular OSINT collectors
- Scalable search and storage
- Team-friendly investigation workflows
- Transparent and auditable data handling

## Example Workflow

1. Create an investigation
2. Submit a domain, email, username, or IP address
3. Run collection modules
4. Store collected evidence
5. Search and correlate results
6. Export findings

## Architecture

Abeacon is designed as a modular service-oriented platform.

```
┌─────────────┐
│  Frontend   │
│   Next.js   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   FastAPI   │
│  API Layer  │
└──────┬──────┘
       │
 ┌─────┼─────┐
 ▼     ▼     ▼

PostgreSQL Redis Meilisearch

       │
       ▼

    MinIO
```

Future OSINT collectors and enrichment modules operate through Celery workers.

## Project Structure

```
abeacon/
├── backend/               # FastAPI application
│   ├── app/
│   │   ├── api/          # API routes
│   │   ├── models/       # SQLAlchemy models
│   │   ├── schemas/      # Pydantic schemas
│   │   ├── config.py     # Configuration
│   │   ├── database.py   # Database setup
│   │   └── security.py   # Auth utilities
│   ├── main.py           # Entry point
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/              # Next.js frontend application
├── docker-compose.yml     # Service orchestration
├── .env.example           # Environment template
└── README.md              # This file
```

## Quick Start

### Prerequisites

- Docker
- Docker Compose
- Python 3.11+

### Clone Repository

```bash
git clone https://github.com/abbieymatthews030-star/abeacon.git
cd abeacon
```

### Configure Environment

```bash
cp .env.example .env
# Edit .env with your configuration
```

### Start Infrastructure

```bash
docker compose up -d
```

Verify services:

```bash
docker compose ps
```

### Start Backend

```bash
cd backend

python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

pip install -r requirements.txt

alembic upgrade head

python main.py
```

API will be available at `http://localhost:8000`

Swagger docs: `http://localhost:8000/docs`
ReDoc: `http://localhost:8000/redoc`

## API Endpoints

### Health

- `GET /health` - Health check

### Authentication

- `POST /api/v1/auth/register` - Create new user
- `POST /api/v1/auth/token` - Login

### Users

- `GET /api/v1/users/me` - Get current user
- `GET /api/v1/users/{user_id}` - Get user by ID
- `PUT /api/v1/users/me` - Update current user

## Development

### Database Migrations

```bash
cd backend

# Create migration
alembic revision --autogenerate -m "Description"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```

### Testing

```bash
# Run tests
pytest

# With coverage
pytest --cov=app
```

## Docker Compose Services

| Service | Port | Access |
|---------|------|--------|
| PostgreSQL | 5432 | localhost:5432 |
| Redis | 6379 | localhost:6379 |
| Meilisearch | 7700 | http://localhost:7700 |
| MinIO API | 9000 | http://localhost:9000 |
| MinIO Console | 9001 | http://localhost:9001 |

## Environment Variables

See `.env.example` for all available options:

- Database configuration
- Redis settings
- Meilisearch API keys
- MinIO credentials
- Security settings (JWT, passwords)
- API configuration

## Tech Stack

### Backend

- **FastAPI** - Modern async Python web framework
- **SQLAlchemy** - ORM for database operations
- **PostgreSQL** - Primary database
- **Redis** - Caching and job queues
- **Celery** - Async task processing
- **Pydantic** - Data validation

### Services

- **Meilisearch** - Full-text search
- **MinIO** - Object storage (S3-compatible)
- **PostgreSQL** - Relational database
- **Redis** - In-memory cache

## Roadmap

### Phase 1 - Core Platform

- Authentication ✓
- User management ✓
- Search infrastructure ✓
- Object storage ✓

### Phase 2 - Collection

- Domain intelligence
- DNS collection
- Email intelligence
- Username collection

### Phase 3 - Analysis

- Correlation engine
- Entity graphing
- Investigation workspaces

### Phase 4 - Reporting

- Exportable reports
- Team collaboration
- Audit logging

## Security

Abeacon is intended for lawful collection and analysis of publicly available information.

Users are responsible for complying with local laws, platform terms of service, and privacy regulations when conducting investigations.

## License

MIT
