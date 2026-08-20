---
id: T-001-001-001-backend-scaffold-and-ledger
parent_epic: E-001-doca-coin-hub
owner_skill: alan-tech-lead
status: Completed
---

# Task: Backend Scaffold, Ledger Engine & Admin UI

## 1. Work Log
*   Initialized NestJS microservice `apps/coin-hub`.
*   Constructed TypeORM entities and versioned migrations (`1724200000000-CreateDocaCoinHubTables.ts`).
*   Implemented Gateway Strategy pattern (`ZaloPayGatewayAdapter`, `MockGatewayAdapter`).
*   Implemented BullMQ asynchronous ledger worker with `SELECT FOR UPDATE` locking.
*   Constructed Admin Billing & Reconciliation dashboard on `doca-admin-web`.
*   Verified clean TypeScript compilation with `npm run build`.
