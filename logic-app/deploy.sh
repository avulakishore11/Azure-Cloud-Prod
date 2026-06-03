#!/bin/bash
# Deploy Logic App Standard content to Azure Storage file share
# Usage: bash deploy.sh

set -e

# ── Variables ────────────────────────────────────────────────────────────────
RESOURCE_GROUP="rg-winvm-dev-01"
LOGIC_APP_NAME="laeus2-winvm-dev-01"
STORAGE_ACCOUNT="stlaeus2dev01"
FILE_SHARE="logic-app-content"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Logging in check (expects az login already done)"
az account show --query name -o tsv

# ── Get storage account key ───────────────────────────────────────────────────
echo "==> Getting storage account key..."
STORAGE_KEY=$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query "[0].value" -o tsv)

# ── Ensure file share exists ──────────────────────────────────────────────────
echo "==> Ensuring file share '$FILE_SHARE' exists..."
az storage share create \
  --name "$FILE_SHARE" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --output none 2>/dev/null || true

# ── Upload host.json ──────────────────────────────────────────────────────────
echo "==> Uploading host.json..."
az storage file upload \
  --share-name "$FILE_SHARE" \
  --source "$SCRIPT_DIR/host.json" \
  --path "site/wwwroot/host.json" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --output none

# ── Upload connections.json ───────────────────────────────────────────────────
echo "==> Uploading connections.json..."
az storage file upload \
  --share-name "$FILE_SHARE" \
  --source "$SCRIPT_DIR/connections.json" \
  --path "site/wwwroot/connections.json" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --output none

# ── Create workflow directory and upload workflow.json ────────────────────────
echo "==> Creating workflow directory..."
az storage directory create \
  --share-name "$FILE_SHARE" \
  --name "site/wwwroot/vm-start-stop" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --output none 2>/dev/null || true

echo "==> Uploading vm-start-stop/workflow.json..."
az storage file upload \
  --share-name "$FILE_SHARE" \
  --source "$SCRIPT_DIR/vm-start-stop/workflow.json" \
  --path "site/wwwroot/vm-start-stop/workflow.json" \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --output none

# ── Restart the Logic App to pick up new content ──────────────────────────────
echo "==> Restarting Logic App '$LOGIC_APP_NAME'..."
az webapp restart \
  --name "$LOGIC_APP_NAME" \
  --resource-group "$RESOURCE_GROUP"

echo ""
echo "✅ Deployment complete!"
echo "   Logic App : $LOGIC_APP_NAME"
echo "   Workflow  : vm-start-stop"
echo "   Trigger   : HTTP POST with body: {\"action\": \"start\"} or {\"action\": \"stop\"}"
echo ""
echo "Wait ~60 seconds then open the Logic App designer in the Azure portal."
