# Integrasi API

Dokumen ini menjelaskan integrasi aplikasi Flutter FARASA dengan backend Educational Ticketing API.

## Sumber Spesifikasi

- `API_DOCUMENTATION.md`
- `openapi.yaml`

## Base URL

Dikelola melalui environment config (`.env` + `core/config/env.dart`).

Contoh:
- `http://35.255.129.123:8080` (server dokumen)
- Endpoint versi API: `/api/v1/...`

## Komponen Integrasi

1. `core/network/api_client.dart`  
   Konfigurasi Dio, base URL, dan interceptor token.
2. `data/services/*_service.dart`  
   Request HTTP per modul.
3. `data/models/*_api_model.dart`  
   Parsing JSON response/request.
4. `data/repositories/*_repository.dart`  
   Mapping API model ke domain model.

## Daftar Endpoint Utama yang Dipakai

### Auth
- `POST /api/v1/auth/register`
- `POST /api/v1/auth/login`
- `POST /api/v1/auth/logout` (auth)

### Profile
- `GET /api/v1/me` (auth)
- `PATCH /api/v1/me` (auth)

### Catalogue
- `GET /api/v1/categories`
- `GET /api/v1/events`
- `GET /api/v1/events/{id}`

### Orders
- `POST /api/v1/orders`
- `GET /api/v1/orders`
- `GET /api/v1/orders/{id}`
- `POST /api/v1/orders/{id}/cancel`

### Payments
- `POST /api/v1/orders/{id}/pay`

### Tickets
- `GET /api/v1/tickets`
- `GET /api/v1/tickets/{id}`

## Pola Response

Umumnya menggunakan envelope:

- Sukses object: `{ data, message }`
- Sukses list: `{ data: [...], meta?, message }`
- Error umum: `{ message }`
- Validation error: `{ message, errors }`

## Error Handling

Status penting dari API:
- `400`, `401`, `404`, `409`, `422`

Prinsip implementasi:
- Service melempar exception dari Dio.
- Repository/ViewModel menangkap exception.
- UI menampilkan pesan error yang aman untuk user.

## Catatan Bisnis Penting

- Endpoint tiket hanya mengembalikan tiket yang sudah terbentuk (umumnya setelah paid).
- Order dengan status `pending` diambil dari endpoint orders dan ditampilkan di halaman Tiket sebagai bagian “Menunggu Pembayaran”.
