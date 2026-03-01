# Jenkins Setup Instructions

This document outlines how to set up the Jenkins pipeline for this repository.

## Prerequisites
1. Jenkins running on AWS EC2 with an attached IAM Instance Profile. The profile inherently has access to ECR, so no AWS keys are hardcoded.
2. The following Jenkins Plugins must be installed:
   - Git
   - Docker Pipeline
   - Kubernetes CLI
   - Pipeline

## Credentials configuration
You need to map the following credentials in Jenkins (`Manage Jenkins -> Credentials`):
- `GITHUB_TOKEN`: Secret text format. Value: your GitHub personal access token with push permissions to the deployment repos.
- `AWS_ACCOUNT_ID`: Secret text format. Value: `<MY_AWS_ACCOUNT_ID>`
- `AWS_REGION`: Secret text format. Value: `<MY_AWS_REGION>` (Default: `us-east-1`)

## Creating the Pipeline Job
1. Go to Jenkins Dashboard -> New Item.
2. Select "Pipeline" (or "Multibranch Pipeline" for multi-environment handling).
3. Name it `app-repo-pipeline` and click OK.
4. Under Pipeline, choose "Pipeline script from SCM" -> Git -> Repository URL.
5. Set branches to build (e.g. `*/dev`, `*/preprod`).
6. Specify Script Path as `Jenkinsfile`.
7. Setup GitHub Webhooks to trigger the pipeline on push events.
