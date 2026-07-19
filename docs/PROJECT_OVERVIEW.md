# PROJECT_OVERVIEW.md - Supri POS Project Overview

## 1. Executive Summary
**Supri POS** is a lightweight, mobile-first, offline-ready Point-of-Sale (POS) application built using Flutter. Designed specifically for small-to-medium retail and F&B merchants in Indonesia, it focuses on extreme reliability under poor internet conditions. The application features multi-outlet support, cashier shift cash flow tracking, dynamic QRIS generation, and automatic cloud synchronization.

## 2. Problem Statement
Many micro, small, and medium enterprises (MSMEs) in Indonesia operate in areas with unstable internet connectivity. Existing cloud-only POS applications lag or stop working entirely when offline, leading to long queues, transaction records missing, and lost revenue. Furthermore, many available solutions are over-engineered, slow to navigate, and lack simple, localized cashier cash drawer reconciliation (kas).

## 3. Scope of MVP
* **In Scope:**
  * Multi-outlet login & session persistence.
  * Local offline product caching.
  * Cart management & manual checkout.
  * Payment processing (Cash, dynamic QRIS).
  * Cash drawer tracking (Opening cash, manual Cash In/Out, Closing cash).
  * Local transaction history log (Synced vs Pending indicators).
  * Shift summary (Rekap) screen.
  * Automatic background syncing.
* **Out of Scope (Post-MVP):**
  * Advanced purchase order (PO) stock replenishment.
  * Integration with food delivery service APIs (GoFood, GrabFood).
  * Detailed customer loyalty program tiers.

## 4. Success Metrics
* **Performance:** Native UI rendering at a consistent 60+ FPS on target devices.
* **Speed:** Time to complete a standard 3-item cash checkout is under **3 seconds**.
* **Reliability:** **99.9%** successful data synchronization rate from offline local store to cloud server.
* **Quality:** Zero critical crashes on Android 9.0+ and iOS 15+.

## 5. Risks & Mitigations
* **Risk 1: Concurrent Data Conflicts during Sync.** Two cashiers updating the same product stock or syncing identical transaction IDs offline.
  * *Mitigation:* Generate UUIDs locally for all transaction IDs and use Timestamp-based "Last-Write-Wins" resolution or incremental stock adjustment queueing.
* **Risk 2: Large Image Cache Overhead.** High-resolution product images slowing down catalog load times.
  * *Mitigation:* Implement aggressive caching (`cached_network_image`), resize images on upload to maximum 500x500 pixels, and use WebP compression.
* **Risk 3: Bluetooth Printer Disconnections.** Physical printer loses connection during a rush.
  * *Mitigation:* Implement auto-reconnect queues and show a clear "Printer Offline" warning with a "Retry Print" button.
