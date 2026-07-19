# REQUIREMENTS.md - Supri POS Requirements

## 1. Functional Requirements

### A. Authentication & Outlet Management
* **Multi-outlet Selection:** Users must be able to log in and select which outlet they are currently operating (e.g., Toko Utama, Cabang A).
* **Session Management:** Secure login and logout flows using token-based authentication.
* **Persistent Session:** Cashier remains logged into their specific outlet unless they explicitly log out or the session expires.

### B. Sales & Cart Management
* **Product Catalog:** A responsive grid/list layout displaying products categorized with search functionality.
* **Cart Operations:**
  * Add products to cart.
  * Adjust quantities (increment/decrement).
  * Apply discounts (percentage or nominal) to individual items or the total cart.
  * Clear cart.

### C. Checkout & Payment
* **Payment Method Selection:** Support multiple payment options (Cash, QRIS, Card).
* **Integrated QRIS:** Generate and display a dynamic QR code for payment.
* **Receipt Management:** Display a transaction success screen with options to print or share the receipt.

### D. Transaction History & Cash Flow (Kas)
* **Kas Session (Cash Flow Tracking):** 
  * Record initial cash (modal awal) when starting a shift.
  * Track manual cash-in (kas masuk) and cash-out (kas keluar) entries with reasons.
  * Show current cash balance in drawer.
* **Transaction History:** List daily transactions with detail view, payment status, and cloud synchronization indicator (Synced vs Pending).
* **Rekapitulasi (Sales Summary):** A summary dashboard showing total sales, payments by category, and cash flow reports for the shift/day.

### E. Data Syncing & Offline Capability
* **Offline-First Storage:** Read and write data (products, transactions, cash flows) locally first.
* **Background Sync:** Synchronize local offline transactions to the remote cloud server automatically when internet connectivity is detected.

---

## 2. Non-Functional Requirements

* **Performance & Responsiveness:** Instant UI responses during product selection and cart changes. Scroll lists must maintain 60/120 FPS.
* **Offline Capability:** 100% core checkout functionality must work without an internet connection.
* **Data Integrity:** Local database must prevent transaction loss or corruption. Uses transaction rollback mechanisms for local writes.
* **Platform Support:** Cross-platform mobile (Android & iOS).
* **Usability:** High-contrast buttons, legible fonts (Google Fonts), and large tap targets (minimum 48dp x 48dp) optimized for fast-paced retail environments.
* **Security:** Secure local storage for sensitive tokens (using keychain/keystore via Flutter Secure Storage) and encrypted data transmission (HTTPS/TLS).

---

## 3. Scope Boundaries
* **In Scope (MVP):**
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
