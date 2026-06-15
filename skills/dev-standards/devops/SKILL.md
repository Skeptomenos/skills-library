---
name: devops-standards
description: >-
  DevOps and infrastructure standards — Terraform/IaC, least-privilege IAM,
  SHA-pinned GitHub Actions, OIDC auth, Docker hardening, vulnerability
  scanning. Use when working on infrastructure, CI/CD, Docker, or Terraform.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - Terraform
  - CI/CD pipeline
  - Dockerfile
  - GitHub Actions
when_to_use:
  - Writing or modifying infrastructure code
  - Setting up or changing CI/CD pipelines
  - Building or hardening Docker images
when_not_to_use:
  - Application-level secrets/input handling (load security-standards)
---

# DevOps & Infrastructure Standards

> **Mandate:** Immutable Infrastructure, Least Privilege, and Policy-as-Code.

## 1. Infrastructure as Code (IaC)
- **Tooling:** Use **Terraform** or **OpenTofu**.
- **No "ClickOps":** Manual changes in the Cloud Console are **FORBIDDEN**. If it's not in git, it doesn't exist.
- **State Management:**
  - **Remote State:** Must use S3/GCS backend. Local state (`terraform.tfstate`) is banned.
  - **Locking:** State locking is mandatory to prevent race conditions (S3 native locking or DynamoDB).

## 2. Security & IAM
- **Least Privilege:**
  - ❌ `Action: "*"` or `Resource: "*"` is forbidden.
  - ✅ Define specific permissions (`s3:GetObject`).
- **No Public Access:** S3 buckets and Databases must be private by default.
- **Secrets:** Use AWS Secrets Manager / Vault. Never commit `.tfvars` containing keys.

## 3. CI/CD Pipeline (GitHub Actions)
- **Pinning:** Action versions must be pinned to **SHA** hash, not tags.
  - ❌ `uses: actions/checkout@v3`
  - ✅ `uses: actions/checkout@f43a0e5... # v3.5.3`
- **OIDC:** Use "OpenID Connect" for AWS/GCP auth. Do not store long-lived `AWS_ACCESS_KEY_ID` in GitHub Secrets.
- **Gates:** Run lint, type check, tests, and build on every push. Block merge if CI fails.

## 4. Docker & Containers
- **User:** Run as non-root (`USER app`).
- **Base Image:** Use minimal, secure images (Alpine or Distroless).
- **Determinism:** Copy lock files first, install with `--frozen-lockfile`. Multi-stage builds: `builder` compiles, `runner` copies only dist/binary.
- **Scanning:** All images must pass `trivy` or `snyk` vulnerability scans.

## 5. Policy Checks (The "Gate")
Before applying any Terraform change, run:
1.  `terraform fmt -check` (Style)
2.  `terraform validate` (Syntax)
3.  `tflint` (Best practices)

Related skills: `security-standards`, `workflow-standards`, `logging-standards`.
