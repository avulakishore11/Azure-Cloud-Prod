# Claude Code – Azure Production Environment

## Azure Tenant
- **Tenant ID:** `a1cd3436-6062-4169-a1bd-79efdcfd8a5e`
- **Subscription:** Ask the user at the start of each task — it may vary.

## Access Rules
- **Read operations:** Allowed freely.
- **Write / execute / delete operations:** Always ask the user explicitly for confirmation before performing. No exceptions.

## Azure Naming Conventions
- **Resource Groups:** `rg-<org>-<region>-<descriptor>`
  - Example: `rg-corit-eus-arcservers`
- **Virtual Machines** (max 15 characters to match NETBIOS):
  - Pattern: `vm<region>-<appname><env>-##`
  - Example: `vmeus-appdev-01`
- **Environments:** `dev`, `uat`, `prod`
- Environment and instance components are optional.

## Session Start Checklist
At the start of every session involving Azure work:
1. Ask the user: **"Which subscription should I use for this task?"**
2. Confirm read-only intent or get explicit approval for any changes.
3. Use the tenant ID above to authenticate.
