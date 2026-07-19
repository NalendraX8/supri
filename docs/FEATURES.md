# FEATURES.md - Supri POS Features Catalog

## 1. Authentication & Session Control
* Cashier Login with validation.
* Multi-outlet support: dynamic data fetching depending on chosen store context.
* Outlet switcher: allows switching operating store outlets on the fly if permissions allow.

## 2. Product Catalog
* Category tabs / chips sorting.
* Search by Product Name or SKU.
* Responsive Grid displaying Product Card containing name, price, stock count, and thumbnail image.

## 3. Cart & Sales Management
* Add items to cart.
* Adjust line item quantities.
* Apply Cart discounts (flat rupiah or percentage).
* Apply Line-item discounts.
* Clear cart action.

## 4. Checkout & Payments
* Cash payment with automatic change calculation.
* QRIS payment generating transaction-specific dynamic QR codes.
* Success screen displaying final invoice and printing actions.

## 5. Drawer shifts (Kas)
* Open Shift drawer input.
* Cash In (Modal, manual inflow adjustments).
* Cash Out (Expense logs, manual outflow adjustments).
* Real-time cash balance calculator.

## 6. History & Sync Management
* Transaction logs separated by daily filters.
* Visual indicators showing sync statuses:
  * Green cloud: successfully synced to server.
  * Grey cloud: stored locally, pending upload.
* Retry upload triggers for individual pending items.
