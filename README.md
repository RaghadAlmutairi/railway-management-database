
# Railway Management Database

This repository contains a complete, runnable SQL schema and sample data for a **Railway Management Database**.  

**Created as part of the _CCCS-215 Introduction to Databases_ course (2023).**

## Project overview

The Railway Management Database models key entities used by a railway operator:
- **Passengers** — customers who make bookings.
- **Bookings** — records of a passenger's booking (one booking may have multiple tickets).
- **Tickets** — tickets issued per booking (origin, destination, seat, price, expiration).
- **Trains** — train metadata (number, type, capacity).
- **Trips** — schedule entries linking trains to stations with arrival/departure times.
- **Stations** — station metadata and location.
- **Employees** — employees assigned to stations.
- **Payments** — payments applied to bookings.

The schema enforces referential integrity with foreign keys and includes example `INSERT` statements so you can spin up a working dataset quickly.

## How to run

### Prerequisites
- MySQL 5.7+ or MariaDB 10.2+ (the provided SQL is MySQL-compatible).
- A MySQL client (mysql CLI, MySQL Workbench, or Adminer).

### Import steps (command-line)
1. Open your MySQL shell or run from terminal:
```bash
mysql -u your_user -p
CREATE DATABASE railway;
USE railway;
SOURCE /path/to/railway_management.sql;
```
or from terminal:
```bash
mysql -u your_user -p railway < railway_management.sql
```

### Quick checks
- List tables: `SHOW TABLES;`
- Count passengers: `SELECT COUNT(*) FROM passengers;`
- View sample schedule: see sample queries at end of the SQL file.

## Notes & recommendations
- The SQL uses `AUTO_INCREMENT` primary keys (MySQL). If you prefer PostgreSQL, replace `AUTO_INCREMENT` with `SERIAL` or `GENERATED` syntax and adjust `DATETIME` to `TIMESTAMP`.
- Business logic like seat assignment constraints, overbooking prevention, and fare calculation engines are intentionally left for application layer implementation (or for later stored procedures).
- The ER diagram provided in the repo (CCCS-215-ER-Diagram.pdf) shows relationships visually.


