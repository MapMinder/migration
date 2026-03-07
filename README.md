# MapMinder Migration

Database migration repository for MapMinder.

---

## Prerequisites

1. MySQL 8.0 installed locally
2. Docker and Docker Compose available

---

## Setup

**1. Clone this repository**
```bash
git clone https://github.com/MapMinder/migration.git
cd migration
```

**2. Start the database**
```bash
docker-compose up -d
```
> Remove `-d` if you want to run in the foreground instead of daemon mode.

**3. Confirm the MySQL container is running**
```bash
docker ps
```

**4. From the root of this repository, run the migrations**
```bash
migrate -path ./migration -database "mysql://<user>:<password>@tcp(localhost:3306)/<dbname>" up
```

---

## Rollback

To roll back the last migration:
```bash
migrate -path ./migration -database "mysql://<user>:<password>@tcp(localhost:3306)/<dbname>" down 1
```
