# DATABASE.md - Supri POS Database Design

## 1. Table Schemas & Collections

### A. Collection: `outlets`
Stores outlet configurations cache.
* `id` (String, PK, UUID)
* `name` (String, Index, Not Null)
* `address` (String)
* `phone` (String)
* `updated_at` (DateTime, Not Null)

### B. Collection: `users`
Stores user profile information.
* `id` (String, PK, UUID)
* `email` (String, Unique, Not Null)
* `name` (String, Not Null)
* `role` (String, e.g., "cashier", "admin")
* `active_outlet_id` (String, FK, Nullable)
* `updated_at` (DateTime)

### C. Collection: `categories`
Stores product category mappings.
* `id` (String, PK, UUID)
* `name` (String, Not Null)
* `code` (String, Unique, Not Null)

### E. Collection: `products`
Stores cache of master products catalog.
* `id` (String, PK, UUID)
* `sku` (String, Unique, Index, Not Null)
* `name` (String, Index, Not Null)
* `price` (Double, Not Null)
* `stock` (Integer, Default 0)
* `category_id` (String, FK, Index, Not Null)
* `image_url` (String, Nullable)
* `is_active` (Boolean, Default True)
* `updated_at` (DateTime)

### F. Collection: `kas_sessions`
Tracks cashier register drawer sessions.
* `id` (String, PK, UUID)
* `outlet_id` (String, FK, Not Null)
* `cashier_id` (String, FK, Not Null)
* `opening_balance` (Double, Default 0)
* `total_cash_in` (Double, Default 0)
* `total_cash_out` (Double, Default 0)
* `expected_closing_balance` (Double, Default 0)
* `actual_closing_balance` (Double, Default 0)
* `is_closed` (Boolean, Default False)
* `opened_at` (DateTime, Not Null)
* `closed_at` (DateTime, Nullable)
* `is_synced` (Boolean, Default False, Index)

### G. Collection: `kas_movements`
Tracks manual cash injections or extractions during a session.
* `id` (String, PK, UUID)
* `session_id` (String, FK, Index, Not Null)
* `type` (String, Constraint: "IN" or "OUT")
* `amount` (Double, Not Null)
* `description` (String)
* `created_at` (DateTime, Not Null)
* `is_synced` (Boolean, Default False, Index)

### H. Collection: `transactions`
Core sales receipt records.
* `id` (String, PK, UUID)
* `transaction_number` (String, Unique, Index, Not Null) - *e.g., TR-OUT01-20260719-0001*
* `outlet_id` (String, FK, Not Null)
* `cashier_id` (String, FK, Not Null)
* `session_id` (String, FK, Not Null)
* `total_amount` (Double, Not Null)
* `discount_amount` (Double, Default 0)
* `tax_amount` (Double, Default 0)
* `net_amount` (Double, Not Null)
* `paid_amount` (Double, Not Null)
* `change_amount` (Double, Default 0)
* `payment_method` (String, Constraint: "CASH" or "QRIS")
* `is_synced` (Boolean, Default False, Index)
* `created_at` (DateTime, Index, Not Null)
* `synced_at` (DateTime, Nullable)

### I. Collection: `transaction_items`
Individual line items inside transactions.
* `id` (String, PK, UUID)
* `transaction_id` (String, FK, Index, Not Null)
* `product_id` (String, FK, Not Null)
* `product_name` (String, Not Null)
* `price` (Double, Not Null)
* `quantity` (Integer, Not Null)
* `discount_amount` (Double, Default 0)
* `total_price` (Double, Not Null)

---

## 2. Performance Indexes
* **Sync uploads optimization:** Compound index on `(is_synced, created_at)`.
* **Search / Scan optimization:** Index on `sku` and `name` (case-insensitive) on the products table.
* **Open shift check:** Index on `(cashier_id, is_closed)` on the cashier drawer sessions.
