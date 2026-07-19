# API.md - Supri POS API Specification

## 1. Authentication & Authorization
* **Protocol:** HTTPS
* **Authentication Method:** JSON Web Tokens (JWT) in Request Header:
  ```http
  Authorization: Bearer <jwt_token>
  ```
* **Roles:**
  * `cashier`: Core POS workflows.
  * `admin` / `owner`: Access to metrics, reports, configuration.

---

## 2. API Endpoints

### A. Login & Handshake
* **Endpoint:** `POST /api/v1/auth/login`
* **Request Payload:**
  ```json
  {
    "email": "cashier@supri.id",
    "password": "securepassword123"
  }
  ```
* **Success Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsIn...",
      "user": {
        "id": "u-789a-4bc2-89de",
        "email": "cashier@supri.id",
        "name": "Lele Cashier",
        "role": "cashier"
      },
      "outlets": [
        {
          "id": "o-123a-4bc2-89de",
          "name": "Toko Utama Supri",
          "address": "Jl. Merdeka No. 45, Jakarta",
          "phone": "08123456789"
        }
      ]
    }
  }
  ```

---

### B. Catalog Sync (Incremental Fetch)
* **Endpoint:** `GET /api/v1/outlets/{outlet_id}/products/sync`
* **Query Params:**
  * `last_synced_at` (String, Optional) - ISO 8601 timestamp.
* **Success Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "sync_timestamp": "2026-07-19T05:58:00Z",
      "products": [
        {
          "id": "p-0123-4567-89ab",
          "sku": "SP-001",
          "name": "Es Kopi Susu Aren",
          "price": 18000.0,
          "stock": 45,
          "category": {
            "id": "cat-001",
            "name": "Beverages",
            "code": "BEV"
          },
          "image_url": "https://cdn.supri.id/products/kopi_aren.webp",
          "is_active": true,
          "updated_at": "2026-07-19T02:30:00Z"
        }
      ]
    }
  }
  ```

---

### C. Bulk Sync Transactions (Offline Uploads)
* **Endpoint:** `POST /api/v1/transactions/sync`
* **Request Payload:**
  ```json
  {
    "transactions": [
      {
        "id": "tx-999a-4bc2-89de",
        "transaction_number": "TR-OUT01-20260719-0001",
        "outlet_id": "o-123a-4bc2-89de",
        "cashier_id": "u-789a-4bc2-89de",
        "session_id": "sess-555x-666y",
        "total_amount": 36000.0,
        "discount_amount": 2000.0,
        "tax_amount": 3740.0,
        "net_amount": 37740.0,
        "paid_amount": 50000.0,
        "change_amount": 12260.0,
        "payment_method": "CASH",
        "created_at": "2026-07-19T12:05:00Z",
        "items": [
          {
            "id": "txi-111a-222b",
            "product_id": "p-0123-4567-89ab",
            "product_name": "Es Kopi Susu Aren",
            "price": 18000.0,
            "quantity": 2,
            "discount_amount": 1000.0,
            "total_price": 34000.0
          }
        ]
      }
    ]
  }
  ```
* **Success Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "synced_ids": [
        "tx-999a-4bc2-89de"
      ],
      "failed_ids": []
    }
  }
  ```

---

### D. Bulk Sync Kas Shifts & Movements
* **Endpoint:** `POST /api/v1/kas/sync`
* **Request Payload:**
  ```json
  {
    "sessions": [
      {
        "id": "sess-555x-666y",
        "outlet_id": "o-123a-4bc2-89de",
        "cashier_id": "u-789a-4bc2-89de",
        "opening_balance": 200000.0,
        "total_cash_in": 50000.0,
        "total_cash_out": 20000.0,
        "expected_closing_balance": 230000.0,
        "actual_closing_balance": 230000.0,
        "is_closed": true,
        "opened_at": "2026-07-19T07:00:00Z",
        "closed_at": "2026-07-19T15:00:00Z",
        "movements": [
          {
            "id": "mov-001a-002b",
            "type": "OUT",
            "amount": 20000.0,
            "description": "Beli plastik kresek & tissue tambahan",
            "created_at": "2026-07-19T09:30:00Z"
          }
        ]
      }
    ]
  }
  ```
* **Success Response (200 OK):**
  ```json
  {
    "status": "success",
    "data": {
      "synced_session_ids": [
        "sess-555x-666y"
      ]
    }
  }
  ```

---

## 3. Global Error Response Format
```json
{
  "status": "error",
  "error": {
    "code": "ERR_INVALID_CREDENTIALS",
    "message": "Username atau password yang Anda masukkan salah.",
    "details": []
  }
}
```
