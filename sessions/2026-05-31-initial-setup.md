# Session: Initial Setup
**Date:** 2026-05-31
**Subscription:** 7a6d2623-b7d9-467b-ab2f-d71d7bf6d45d
**Tenant:** 8d82b64e-424f-494e-90eb-0e5123b89423

## What Was Done
- Created `CLAUDE.md` with Azure tenant ID, access rules, and naming conventions
- Created service principal with Contributor role (Client ID: `39fb7019-964c-484a-9f6b-06283e83af32`)
- Created `.github/workflows/azure-query.yml` for on-demand Azure CLI queries via GitHub Actions
- Created `sessions/` folder for ongoing session tracking

## Access Rules Established
- Read operations: allowed freely
- Write/execute/delete: always ask user for explicit confirmation first
- Subscription: user will specify at the start of each task

## Pending
- Add 4 GitHub secrets (`AZURE_CLIENT_ID`, `AZURE_CLIENT_SECRET`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`) to repo
- Verify Azure Actions workflow runs successfully
- Test `az account show` via workflow dispatch
