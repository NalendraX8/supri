# Dokumentasi Integrasi REST API: Point of Sale (POS)

**Penyedia Layanan:** Zales POS / Ekasa Teknologi  
**Versi Dokumen:** 1.0  
**Tanggal:** 7 April 2026  
**Web:** <https://login.fintoapp.com>  
**Akun:** adminpos@demo.com  
**Password:** `Zales123@`

## 1. Pendahuluan

Dokumen ini ditujukan bagi pengembang pihak ketiga untuk mengintegrasikan aplikasi mandiri dengan ekosistem Zales POS melalui REST API. Integrasi ini mencakup sinkronisasi produk, pengelolaan stok, dan pencatatan transaksi penjualan secara real-time.

## 2. Alur Kerja Integrasi (Workflow)

Untuk menjaga integritas data akuntansi, klien wajib mengikuti urutan proses berikut:

1. **Sync Master Data:** Mengambil daftar produk (Item), harga (Price), dan gudang (Warehouse).
2. **Check POS Opening:** Memastikan kasir sudah melakukan "Buka Kasir" (Opening Shift) di sistem pusat.
3. **Submit Invoice:** Mengirimkan data transaksi setiap kali penjualan terjadi.
4. **Sync Payment:** Memastikan status pembayaran (Tunai, QRIS, Debet) tercatat dengan benar.

## 3. Referensi Endpoint API

### 3.1 Mendapatkan Katalog Produk (Item)

Mengambil daftar produk yang aktif dan tersedia untuk dijual.

- **Method:** `GET`
- **URL:** `/api/resource/Item`
- **Parameter:**

```text
?fields=["item_code","item_name","standard_rate","description"]&filters=[["disabled","=",0],["is_sales_item","=",1]]
```

### 3.2 Validasi Pembukaan Kasir (POS Opening Entry)

Transaksi hanya diizinkan jika sesi kasir telah dibuka.

- **Method:** `GET`
- **URL:** `/api/resource/POS Opening Entry`
- **Filters:**

```json
[["user", "=", "email@client.com"], ["status", "=", "Open"]]
```

### 3.3 Mengirim Transaksi Penjualan (POS Invoice)

Endpoint utama untuk mencatat penjualan dan memotong stok secara otomatis.

- **Method:** `POST`
- **URL:** `/api/resource/POS Invoice`
- **Payload (JSON):**

```json
{
  "customer": "Pelanggan Umum",
  "pos_profile": "Main Store POS",
  "update_stock": 1,
  "is_pos": 1,
  "items": [
    {
      "item_code": "BRG-001",
      "qty": 2,
      "rate": 15000
    }
  ],
  "payments": [
    {
      "mode_of_payment": "Cash",
      "amount": 30000,
      "account": "Cash - B"
    }
  ]
}
```

## 4. Kode Status dan Penanganan Error

Sistem menggunakan kode status HTTP standar untuk merespons permintaan:

| Kode | Deskripsi | Tindakan Klien |
|---|---|---|
| `200 OK` | Sukses | Simpan ID transaksi (`name`) yang dikembalikan. |
| `401 Unauthorized` | Token Salah | Periksa API Key & Secret di Header. |
| `403 Forbidden` | Hak Akses Dibatasi | Hubungi Admin untuk izin akses DocType. |
| `417 Expectation Failed` | Validasi Bisnis Gagal | Cek ketersediaan stok atau saldo pembayaran. |
| `500 Server Error` | Kesalahan Sistem | Hubungi dukungan teknis Zales POS. |

## 5. Nama-Nama Table (Doctype)

| Nama Table / Doctype | Keterangan |
|---|---|
| Item | Produk |
| Item Group | Kategori |
| UOM | Satuan |
| Price List | Daftar harga |
| POS Invoice | Tabel transaksi POS Invoice |
| POS Opening Entry | Tabel buka buku |
| POS Closing Entry | Tabel tutup buku |
| Company | Tabel Perusahaan. Umumnya data yang diambil adalah nama Company dan Abbr (Singkatan). |
| ... | ... |

### 5.1 Struktur Filter

Format dasar:

```json
["field_name", "operator", "value"]
```

Contoh:

```json
["item_name", "like", "%Es%"]
```

#### Daftar Operator

Operator yang umum dipakai:

##### 1. Perbandingan Dasar

- `=`: sama dengan
- `!=`: tidak sama dengan
- `>`: lebih besar
- `<`: lebih kecil
- `>=`: lebih besar sama dengan
- `<=`: lebih kecil sama dengan

##### 2. Pencarian Teks

`like`: mirip, menggunakan wildcard `%`.

```json
["item_name", "like", "%Es%"]
```

`not like`: tidak mirip.

##### 3. Set / List

`in`: ada dalam list.

```json
["item_group", "in", ["Minuman", "Makanan"]]
```

`not in`: tidak ada dalam list.

##### 4. Null / Kosong

`is`: biasanya untuk nilai null atau kondisi kosong.

```json
["description", "is", "set"]
["description", "is", "not set"]
```

##### 5. Range

`between`: di antara 2 nilai.

```json
["posting_date", "between", ["2024-01-01", "2024-12-31"]]
```

## 6. Contoh Implementasi (JavaScript / Axios)

```javascript
const axios = require('axios');

async function sendTransaction() {
  try {
    const response = await axios.post('https://demo.fintoapp.com/api/resource/POS Invoice', {
      customer: "Guest",
      items: [{ item_code: "COFFEE-01", qty: 1, rate: 25000 }],
      payments: [{ mode_of_payment: "Cash", amount: 25000 }]
    }, {
      headers: {
        'Authorization': 'token 12345abcde:67890fghij',
        'Content-Type': 'application/json'
      }
    });

    console.log("Transaksi Berhasil ID:", response.data.data.name);
  } catch (error) {
    console.error("Gagal Mengirim Data:", error.response.data);
  }
}
```

Dokumentasi teknis mengenai URL endpoint, payload, dan alur integrasi API yang digunakan dalam aktivitas Zales POS.

# Referensi Endpoint API

## Get Site Name

Dapatkan `site_name` untuk login dengan site yang dituju.

- **Method:** `POST`
- **URL:** `https://login.fintoapp.com/api/method/login`
- **Payload (JSON):**

```json
{
  "email": "adminpos@demo.com"
}
```

**Response:**

```json
{
  "message": {
    "site_name": "https://demo.fintoapp.com",
    "email": "adminpos@demo.com",
    "company_name": "Demo"
  }
}
```

## Login

- **Method:** `POST`
- **URL:** `{site_name}/api/method/login`
- **Payload (JSON):**

```json
{
  "usr": "adminpos@demo.com",
  "pwd": "Zales123@"
}
```

**Response:**

```json
{
  "message": "Logged In",
  "home_page": "/manage",
  "full_name": "Admin Pos"
}
```

## Get Resource

Get Resource digunakan untuk mendapatkan data dari table POS Invoice, Item, dan Order Online.

Fitur yang tersedia:

- Paging
- Filters
- Search

- **Method:** `GET`
- **URL:**

```text
https://demo.fintoapp.com/api/method/zales_pos.api.pos.getResource?start=0&page_length=100&doctype=Item&filters=[["docstatus","=",0]]&or_filters=[]
```

**Response:**

```json
{
  "data": [
    { "...": "..." },
    { "...": "..." }
  ]
}
```

## Mendapatkan Data dari Table

### Contoh Pemanggilan Banyak Data

**Endpoint:** `GET /api/resource/Item`

```text
{url}/api/resource/{Nama table}
```

**Params:**

```json
{
  "fields": ["*"],
  "filters": [["disabled", "=", 0]],
  "limit_start": 0,
  "limit_page_length": 200,
  "order_by": "item_name asc"
}
```

**Dalam bentuk URL:**

```text
https://demo.fintoapp.com/api/resource/Item?fields=["*"]&filters=[["disabled","=",0]]&limit_start=0&limit_page_length=20&order_by=item_name asc
```

### Pengambilan Satu Table

Data yang di-return akan lebih detail dan menampilkan relation table yang digunakan.

**Endpoint:** `GET /api/resource/Item/{Name}`

```text
{url}/api/resource/{Nama Table}/{Name atau field: name}
```

### Pengambilan Data Company

Get data Company digunakan untuk mendapatkan detail Company, terutama field `Abbr` yang sering dipakai apabila melakukan transaksi.

- **Method:** `GET`
- **Endpoint:** `{url}/api/resource/Company`

### Get Detail Company

Bertujuan untuk mendapatkan detail data Company, terutama `Abbr`.

- **Method:** `GET`
- **Endpoint:** `{url}/api/resource/Company/{Company Name atau field name}`

**Dalam bentuk URL:**

```text
https://demo.fintoapp.com/api/resource/Item/EJ1
```

## POS Opening

- **Method:** `POST`
- **Endpoint:** `{url}/api/resource/POS Opening Entry`
- **Payload:**

```json
{
  "doctype": "POS Opening Entry",
  "__islocal": 1,
  "__unsaved": 1,
  "owner": "adminpos@demo.com",
  "status": "Open",
  "posting_date": "2026-04-10",
  "set_posting_date": 1,
  "company": "Ekasa",
  "period_start_date": "2026-04-10 12:20:00",
  "pos_profile": "Zales Demo - E",
  "user": "adminpos@demo.com",
  "balance_details": [
    {
      "docstatus": "0",
      "doctype": "POS Opening Entry Detail",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": "adminpos@demo.com",
      "opening_amount": 0,
      "parent": "",
      "parentfield": "balance_details",
      "parenttype": "POS Opening Entry",
      "idx": 0,
      "mode_of_payment": "Debit"
    },
    {
      "docstatus": "0",
      "doctype": "POS Opening Entry Detail",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": "adminpos@demo.com",
      "opening_amount": 0,
      "parent": "",
      "parentfield": "balance_details",
      "parenttype": "POS Opening Entry",
      "idx": 1,
      "mode_of_payment": "Kredit"
    },
    {
      "docstatus": "0",
      "doctype": "POS Opening Entry Detail",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": "adminpos@demo.com",
      "opening_amount": 0,
      "parent": "",
      "parentfield": "balance_details",
      "parenttype": "POS Opening Entry",
      "idx": 2,
      "mode_of_payment": "Qris"
    },
    {
      "docstatus": "0",
      "doctype": "POS Opening Entry Detail",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": "adminpos@demo.com",
      "opening_amount": 0,
      "parent": "",
      "parentfield": "balance_details",
      "parenttype": "POS Opening Entry",
      "idx": 3,
      "mode_of_payment": "Cash"
    },
    {
      "docstatus": "0",
      "doctype": "POS Opening Entry Detail",
      "__islocal": 1,
      "__unsaved": 1,
      "owner": "adminpos@demo.com",
      "opening_amount": 0,
      "parent": "",
      "parentfield": "balance_details",
      "parenttype": "POS Opening Entry",
      "idx": 4,
      "mode_of_payment": "Transfer"
    }
  ]
}
```

## POS Invoice

- **Method:** `POST`
- **Endpoint:** `{url}/api/resource/POS Invoice`

```jsonc
{
  "custom_no_invoice": "090426090976a403a9d49378",
  "custom_no_transaction": "E00-090426-0003",
  "custom_channel": "Offline",
  "custom_number": 3,
  "title": "NN",
  "creation": "2026-04-09 11:09:09.851000",
  "modified": "2026-04-09 11:09:09.851000",
  "posting_date": "2026-04-09",
  "posting_time": "11:09:09",
  "customer": "NN",
  "currency": "IDR",
  "selling_price_list": "Normal",
  "set_warehouse": "Zales Demo - E",
  "pos_profile": "Zales Demo - E",
  "update_stock": true,
  "items": [
    {
      "custom_id": "09042608200624de7686e406",
      "item_code": "EJ1",
      "item_name": "Es Jeruk",
      "qty": 1,
      "rate": 5000,
      "amount": 5000,
      "description": "Es Jeruk",
      "custom_description": "",
      "price_list_rate": 5000,
      "custom_pricelist": "Normal",
      "custom_discount_per_item": 0,
      "custom_parent_modifier": "",
      "custom_index": 1
    },
    {
      "custom_id": "090426082146cd24bf7764db",
      "item_code": "EsT-01",
      "item_name": "Es Teh",
      "qty": 1,
      "rate": 0,
      "amount": 0,
      "description": "Es Teh",
      "custom_description": "",
      "price_list_rate": 3000,
      "custom_pricelist": "Dine In",
      "custom_discount_per_item": 0,
      "custom_parent_modifier": "",
      "custom_index": 1
    }
  ],
  "payments": [
    {
      "mode_of_payment": "Qris",
      "mode_2": "Qris",
      "type": "Qris",
      "amount": 5000,
      "base_amount": 5000
    }
  ],
  "taxes_and_charges": "Indonesia Tax - E", // - E Abbr Company
  "taxes": [
    {
      "charge_type": "Actual",
      "account_head": "4480.000 - Pendapatan Lain lain - E",
      "description": "Custom",
      "cost_center": "Main - E",
      "rate": 0,
      "tax_amount": 0,
      "custom_note": ""
    },
    {
      "charge_type": "On Previous Row Total",
      "account_head": "4411.000 - Pendapatan Service Charge - E",
      "description": "Service",
      "cost_center": "Main - E",
      "rate": 0,
      "tax_amount": 0,
      "row_id": 1,
      "custom_note": ""
    },
    {
      "charge_type": "On Previous Row Total",
      "account_head": "PPN - E",
      "description": "Pajak",
      "cost_center": "Main - E",
      "rate": 0,
      "tax_amount": 0,
      "row_id": 2,
      "custom_note": ""
    }
  ],
  "base_total": 5000,
  "total": 5000,
  "base_net_total": 5000,
  "net_total": 5000,
  "total_net_weight": 0,
  "base_total_taxes_and_charges": 0,
  "total_taxes_and_charges": 0,
  "loyalty_points": 0,
  "loyalty_amount": 0,
  "apply_discount_on": "Net Total",
  "base_discount_amount": 0,
  "additional_discount_percentage": 0,
  "discount_amount": 0,
  "base_grand_total": 5000,
  "grand_total": 5000,
  "base_rounding_adjustment": 0,
  "base_rounded_total": 5000,
  "rounding_adjustment": 0,
  "rounded_total": 5000,
  "total_advance": 0,
  "outstanding_amount": 0,
  "base_paid_amount": 5000,
  "paid_amount": 5000,
  "base_change_amount": 0,
  "change_amount": 0,
  "ignore_pricing_rule": true,
  "custom_split": false,
  "custom_table": "",
  "custom_discount_amount": 0,
  "custom_discount_type": ""
}
```

## Make Closing

- **Method:** `POST`
- **Endpoint:** `{url}/api/method/zales_pos.api.pos.makeClosingEntry`

```json
{
  "obj": {
    "pos_opening_name": "POS-OPE-2026-00005",
    "mode_of_payment": [
      {
        "mode_of_payment": "Debit",
        "opening_amount": "0.0",
        "expected_amount": "0.0",
        "closing_amount": "0.0"
      },
      {
        "mode_of_payment": "Kredit",
        "opening_amount": "0.0",
        "expected_amount": "0.0",
        "closing_amount": "0.0"
      },
      {
        "mode_of_payment": "Qris",
        "opening_amount": "0.0",
        "expected_amount": "0.0",
        "closing_amount": "0.0"
      },
      {
        "mode_of_payment": "Cash",
        "opening_amount": "0.0",
        "expected_amount": "8000.0",
        "closing_amount": 10000
      },
      {
        "mode_of_payment": "Transfer",
        "opening_amount": "0.0",
        "expected_amount": "0.0",
        "closing_amount": "0.0"
      }
    ],
    "custom_pos_cashes": []
  }
}
```

**Dokumentasion Version:** 1.0.0
