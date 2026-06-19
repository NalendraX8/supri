# Supri Mock API

A simple mock REST API using json-server.

## Quick Start

```bash
cd api
npm install
npm start
```

API will run at `http://localhost:3000`

## Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /products | List all products |
| GET | /products/:id | Get product by ID |
| GET | /categories | List all categories |
| GET | /outlets | List all outlets |
| GET | /users | List users |
| POST | /users/login | Login user |
| GET | /transactions | List transactions |
| POST | /transactions | Create transaction |

## Example

```bash
# Get all products
curl http://localhost:3000/products

# Login
curl -X POST http://localhost:3000/users/login \
  -H "Content-Type: application/json" \
  -d '{"email":"demo@supri.id","password":"1234"}'
```
