# Abeacon

An OSINT (Open Source Intelligence) and reconnaissance platform for information gathering and analysis.

## Project Structure

```
abeacon/
├── backend/           # FastAPI application
│   ├── app/
│   │   ├── api/      # API routes
│   │   ├── models/   # SQLAlchemy models
│   │   ├── schemas/  # Pydantic schemas
│   │   ├── config.py # Configuration
│   │   ├── database.py # Database setup
│   │   └── security.py # Auth utilities
│   ├── main.py       # Entry point
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/          # Next.js application (TBD)
├── docker-compose.yml # Service orchestration
├── .env.example       # Environment template
└── README.md          # This file
```

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

## Quick Start

### 1. Clone and Setup

```bash
cd abeacon
```

### 2. Create Environment File

```bash
cp .env.example .env
# Edit .env with your configuration
```

### 3. Start Services

```bash
# Start all Docker services
docker-compose up -d

# Wait for services to be healthy
docker-compose ps
```

### 4. Setup Backend

```bash
cd backend

# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run migrations (when ready)
alembic upgrade head

# Start development server
python main.py
```

API will be available at `http://localhost:8000`

Swagger docs: `http://localhost:8000/docs`
ReDoc: `http://localhost:8000/redoc`

### 5. API Endpoints

#### Health
- `GET /health` - Health check

#### Authentication
- `POST /api/v1/auth/register` - Create new user
- `POST /api/v1/auth/token` - Login

#### Users
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

## Next Steps

- [ ] Create database migrations with Alembic
- [ ] Implement OSINT modules
- [ ] Add search aggregation
- [ ] Setup Celery task queue
- [ ] Create frontend (Next.js)
- [ ] Implement user teams/workspaces
- [ ] Add audit logging
- [ ] Setup monitoring and logging

## License

MIT
