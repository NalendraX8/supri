# Code Audit Report - Pre-REST API Integration

This report provides a detailed code audit of the **Supri POS** application, assessing its readiness for integration with the **Zales REST API** (Ekasa Teknologi). It outlines structural anomalies, model gaps, state management adjustments, and offline-sync requirements.

---

## 1. Directory Structure & Architecture Integrity

The project follows a standard Clean Architecture structure:
* `core/`: Constants, styling, themes, widgets, and shared storage services.
* `features/`: Module-based features (`auth`, `sales`, `settings`, `transaction`).

### Gaps Identified:
1. **Missing Data/Domain Layers:**
   * `settings/` and `transaction/` features only contain a `presentation/` layer. They lack BLoCs, entities, data models, repositories, and network datasources.
   * *Required Action:* Create data and domain folders for `transaction` (to handle cash management inflows/outflows log entries) and `settings` (to handle shift opening, closing, and sync logs).
2. **Mock Data Clutter:**
   * [mock_product_datasource.dart](file:///home/lele/zProject/projects/main_projects/supri/lib/core/network/mock_product_datasource.dart) is located directly inside `core/network/` but is tightly coupled with `features/sales`.

---

## 2. Authentication & Session Setup (`auth/`)

### Current State
* `AuthRemoteDataSource` simulates a delayed login, always returning a dummy `AuthEntity` with `userId: '1'` and `name: 'Demo User'`.
* Outlets are hardcoded inside the `OutletSelectionPage` view.

### Zales API Requirements
1. **Two-Step Login:**
   * **Step 1:** Fetch site details by sending email to `https://login.fintoapp.com/api/method/login`.
   * **Step 2:** Use the returned `site_name` base URL to POST `usr` and `pwd` to `{site_name}/api/method/login`.
2. **Session Persistence:**
   * Zales uses cookie-based authentication (`sid` session ID). The network client must persist these cookies/headers across requests.
3. **Dynamic POS Profiles (Outlets):**
   * The list of authorized outlets must be retrieved from `{site_name}/api/resource/POS Profile` or the user's login response instead of hardcoding.

---

## 3. Product Catalog & Category Mapping (`sales/`)

### Current State
* `ProductEntity` uses a simple string `id` (e.g. `1` to `30`) and categories mapped in Indonesian.
* Product image loading is mock-only (category gradient colors and generic icons).

### Zales API Requirements
1. **Item Code Mapping:**
   * Products are mapped to the **Item** Doctype in Zales ERP. They are identified by `item_code` (e.g., `EJ1`, `EsT-01`) instead of sequential integer IDs.
2. **Category Mapping:**
   * Categories correspond to the **Item Group** Doctype in Zales. These must be fetched dynamically via GET to `{site_name}/api/resource/Item Group`.

---

## 4. Checkout & Invoice Submission (`sales/`)

### Current State
* Cart details are stored inside `SalesBloc` as `CartEntity`.
* Checkout resets the cart state and shows a simulated thermal receipt. No network requests are made.

### Zales API Requirements
1. **POS Invoice Submission:**
   * Transactions must be sent via POST to `{site_name}/api/resource/POS Invoice`.
   * The JSON payload requires specific fields: `customer`, `pos_profile`, `update_stock: true`, `items` (rate, qty, item_code), `payments` (mode_of_payment, amount), and `taxes`.
2. **Taxes Alignment:**
   * Currently, tax is calculated as a flat 10% inside `CartEntity`. The Zales ERP uses a dynamic `taxes` array (e.g. PPN, Service Charge accounts). Tax logic must align to prevent rounding or validation errors (`417 Expectation Failed`).

---

## 5. Cash Management & Shift Closing (`transaction/` & `settings/`)

### Current State
* `KasPage` and `RekapPage` maintain state locally or show mock details.
* Close shift is simulated via auth logout.

### Zales API Requirements
1. **POS Opening Entry:**
   * Sesi kasir must be validated on login. If no open session exists, the app must create one via POST to `{site_name}/api/resource/POS Opening Entry`.
2. **Cash Transactions (Inflow/Outflow):**
   * Cash logs must be sent to the server to reconcile closing accounts.
3. **POS Closing Entry:**
   * Shift closing requires posting the cash aggregates (Expected vs Actual closing amount per payment method) via POST to `{site_name}/api/method/zales_pos.api.pos.makeClosingEntry`.

---

## 6. Offline Support & Sync Mechanism

### Current State
* A dummy `isSynced` flag exists in `HistoryPage` transaction logs, but there is no actual database caching or queueing.

### Zales API Requirements
* **Local SQLite/File Queue:**
  * Since POS systems must function offline, transactions must be written to a local database (or JSON files in `path_provider`) first.
  * An background sync worker or manual sync button must iterate through unsynced files and upload them to the Zales API when a connection is restored.
