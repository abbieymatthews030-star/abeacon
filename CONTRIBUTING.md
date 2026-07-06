# Contributing

## Setup

```bash
bash scripts/setup
```

## Make Changes

1. Create branch: `git checkout -b feature/name`
2. Make changes
3. Test: `pytest`
4. Format: `black app/`
5. Commit: `git commit -m "feat: description"`
6. Push: `git push origin feature/name`
7. Create PR

## Code Style

### Python (PEP 8)
```python
from typing import Optional
from fastapi import APIRouter

router = APIRouter()

@router.get("/items/{item_id}")
async def get_item(item_id: int) -> dict:
    """Get item by ID."""
    return {"item_id": item_id}
```

### Format Code
```bash
black app/
flake8 app/
```

## Testing

```bash
# All tests
pytest

# Specific test
pytest tests/test_auth.py

# With coverage
pytest --cov=app
```

## Commit Messages

```
feat: add new feature
fix: fix bug
docs: update documentation
refactor: restructure code
test: add tests
```

## Pull Request

Include:
- What changed and why
- How to test
- Related issues

## File Structure

```
feature/
├── models.py      # Database models
├── schemas.py     # Request/response
├── services.py    # Business logic
├── router.py      # API routes
└── tests/
    └── test_*.py  # Tests
```

## Questions?

Check existing issues or create a new one.
