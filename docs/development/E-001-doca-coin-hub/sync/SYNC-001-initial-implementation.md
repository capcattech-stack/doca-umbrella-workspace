---
id: SYNC-001-initial-implementation
epic_id: E-001-doca-coin-hub
date: 2026-08-21
status: Synchronized
---

# Doc Sync Note: Initial Doca Coin Hub Implementation

## 1. Changed Source Files
*   `apps/coin-hub/src/main.ts`
*   `apps/coin-hub/src/app.module.ts`
*   `apps/coin-hub/src/entities/*.ts`
*   `apps/coin-hub/src/database/migrations/1724200000000-CreateDocaCoinHubTables.ts`
*   `apps/coin-hub/src/modules/gateways/*`
*   `apps/coin-hub/src/modules/wallet/*`
*   `apps/coin-hub/src/modules/order/*`
*   `apps/coin-hub/src/modules/webhook/*`
*   `apps/coin-hub/src/modules/queue/*`
*   `apps/coin-hub/src/modules/admin/*`
*   `doca-admin-web/src/pages/billing.astro`
*   `doca-admin-web/src/components/AdminLayout.astro`

## 2. Traceability & Impact
*   **PRD Mapping:** Implements `FR-COIN-001` through `FR-COIN-007`.
*   **Decisions:** Validates `ADR-022` (Microservice), `ADR-023` (Identity), `ADR-024` (BullMQ Queue), `ADR-025` (Postgres DB), `ADR-026` (Gateway Strategy).
*   **Schema Safety:** Strict adherence to `.agents/rules/database_conventions.md` (`synchronize: false`).
