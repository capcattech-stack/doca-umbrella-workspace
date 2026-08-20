---
id: E-001-doca-coin-hub
title: Doca Coin Hub Platform
status: In_Progress
owner_skill: alan-tech-lead
created_at: 2026-08-21
---

# Epic E-001: Doca Coin Hub Platform

## 1. Executive Summary
Doca Coin Hub is a standalone, multi-tenant-ready Virtual Economy, Payment Inflow (ZaloPay & Mock Sandbox), and Immutable Ledger microservice (`apps/coin-hub`) built with NestJS v11, TypeORM (PostgreSQL), and BullMQ (Redis).

## 2. Acceptance Boundaries
*   [x] Universal user identity lookup/auto-creation via Email and Phone.
*   [x] PostgreSQL schema with TypeORM migrations (`synchronize: false`).
*   [x] ZaloPay v2 HMAC-SHA256 order creation & webhook verification.
*   [x] Mock Sandbox gateway for instant offline development and automated CI testing.
*   [x] BullMQ asynchronous webhook callback ingestion with `<50ms` HTTP ack.
*   [x] Concurrency safety with `SELECT wallet FOR UPDATE` row locking.
*   [x] Admin Billing & Reconciliation portal on `doca-admin-web`.

## 3. Relationship Map
*   `IMPLEMENTS` [Feature 015: Capcat Coin Hub](file:///E:/Projects/capcat-vibe-coding/docs/prd.md)
*   `ENABLES` [F-001-001-virtual-economy-ledger](file:///E:/Projects/capcat-vibe-coding/docs/development/E-001-doca-coin-hub/features/F-001-001-virtual-economy-ledger.md)
*   `USES` [M-001-001-coin-hub-backend](file:///E:/Projects/capcat-vibe-coding/docs/development/E-001-doca-coin-hub/modules/M-001-001-coin-hub-backend.md)
*   `CONTAINS` [P-001-001-admin-billing-portal](file:///E:/Projects/capcat-vibe-coding/docs/development/E-001-doca-coin-hub/pages/P-001-001-admin-billing-portal.md)
