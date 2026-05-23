# Datasets API

API that allows importing datasets and searching through them.

## Tech Stack

- Ruby 3.3.11
- Rails 8.1
- PostgreSQL 16
- Docker Compose

## Local Setup

**Requirements:** Docker, Ruby 3.3.11

```bash
git clone <repo-url>
cd datasets_api
cp .env.example .env
bundle install
docker compose up -d
bin/rails db:create db:migrate
bin/rails server
```

## API

### Import datasets

```
POST /datasets/import
Content-Type: application/json
```

Accepts an array of dataset objects and handles incorrect data.

**Example request:**
```json
[
  {
    "external_id": "dataset-1",
    "title": "Climate Change Data",
    "authors": ["John Doe", "Jane Smith"],
    "keywords": ["climate", "temperature"]
  }
]
```

**Example response:**
```json
{
  "imported": 1,
  "failed": 0,
  "duplicates": 0
}
```

### Search datasets

```
GET /datasets?q=climate
```

Searches by title and keywords (case-insensitive).

## Tests

```bash
bundle exec rspec
```
