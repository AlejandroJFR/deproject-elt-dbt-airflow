# Pharmacovigilance ELT Pipeline  
**Human & Veterinary Adverse Events (openFDA)**

## Overview

This project builds a production-style ELT pipeline that ingests adverse event data from the openFDA API, models it in a warehouse using dbt, and prepares analytics-ready datasets for BI consumption.

The project integrates:

- **Human Drug Adverse Events**
- **Animal & Veterinary Adverse Events**

The goal is to simulate a real-world data engineering environment with:

- Containerized infrastructure  
- Incremental ingestion  
- Idempotent loading  
- Structured data modeling (dbt)  
- Data testing  
- Documentation  
- BI visualization  
- Workflow orchestration (Airflow – planned)

---

## Architecture

openFDA API (Human + Veterinary)
↓
Python Ingestion Layer
↓
Postgres (raw schema)
↓
dbt (staging + marts)
↓
Postgres (analytics-ready)
↓
Power BI Dashboard
↓
Airflow (orchestration – future phase)

---

## Tech Stack

- **Python 3.11**
- **PostgreSQL 16 (Docker)**
- **dbt Core 1.11**
- **Docker Compose**
- **Power BI**
- **Airflow (planned)**

---

## Data Sources

### 1. Human Drug Adverse Events

Endpoint: https://api.fda.gov/drug/event.json

### 2. Animal & Veterinary Adverse Events

Endpoint: https://api.fda.gov/animalandveterinary/event.json


