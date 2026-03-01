# App Repo (Person Search Application)

This repository contains the source code for a simple full-stack Person Search application. Users can search for a person by name and view their details (name, age, email, phone, address). It is built with Python (Flask) and a PostgreSQL database.

## Prerequisites
- Python 3.11+
- PostgreSQL
- Docker (optional, for containerized run)
- Git

## Setup Instructions
1. Clone the repository.
2. Initialize database using the `db/init.sql` script.
3. Run locally using python:
   ```bash
   pip install -r requirements.txt
   export DB_HOST=localhost
   export DB_NAME=personsearch
   export DB_USER=postgres
   export DB_PASSWORD=postgres
   export DB_PORT=5432
   python app/app.py
   ```

## CI/CD Pipeline
This repository uses Jenkins for continuous integration. The pipeline is defined in the `Jenkinsfile` and handles the following:
1. Triggered on push to `dev` or `preprod` branches.
2. Builds a new Docker image from the source code.
3. Pushes the Docker image to AWS ECR (`person-search-dev` or `person-search-preprod`).
4. Updates the image tag inside the `k8s-manifests-repo`.

## Local Cluster Deployment Test
You can access the application through `/etc/hosts` if it is running on your local Kubernetes infrastructure. Wait for the `k8s-manifests-repo` deployment to finish, and map its IP to `dev.personsearch.local` or `preprod.personsearch.local` in your hosts file.
