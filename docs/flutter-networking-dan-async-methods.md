# Flutter Networking dan Async Methods yang Digunakan

Dokumen ini menjelaskan method integrasi API dan pola async pada proyek FARASA.

## Library Utama

- **Dio**: HTTP client
- **flutter_secure_storage**: simpan token JWT
- **flutter_dotenv / env config**: base URL dari environment

## Arsitektur Networking

1. `api_client.dart`  
   Menyiapkan Dio:
   - base URL
   - timeout
   - header default
   - interceptor auth

2. `*_service.dart`  
   Menangani request endpoint per domain:
   - auth
   - profile
   - catalog
   - orders
   - tickets

3. `*_repository.dart`  
   Mengubah API model menjadi domain model dan expose data ke ViewModel.

## Method Async yang Digunakan

### `async` / `await`
Dipakai untuk semua operasi I/O:
- login/register/logout
- load event list
- create order
- pay/cancel order
- load tickets/profile

### `try-catch-finally`
Pola standar:
- `try`: panggil API
- `catch`: tangani error
- `finally`: reset loading state

### Future-based methods
ViewModel expose method seperti:
- `initialize()`
- `load...()`
- `refresh()`
- `submit...()`
- `payOrder()`
- `cancelOrder()`

## Error Handling

Sumber error utama:
- HTTP error status (`400/401/404/409/422`)
- timeout
- format data
- koneksi internet

Pendekatan:
1. Tangkap DioException
2. Ambil pesan dari response envelope jika ada
3. Simpan ke state `errorMessage`
4. Tampilkan di UI (SnackBar / message text)

## Auth Token Flow

1. Login/Register berhasil -> dapat `access_token`
2. Token disimpan aman di storage
3. Interceptor menambahkan header:
   - `Authorization: Bearer <token>`
4. Logout -> revoke sesi + hapus token lokal

## Refresh Data Pattern

Untuk menjaga data terbaru:
- Pull-to-refresh pada list screen
- Method `refresh()` di ViewModel
- Pada beberapa layar, refresh lebih dari satu sumber data (contoh tiket + pending orders)

## Catatan Praktik Baik

- Jangan panggil Dio langsung dari widget.
- Simpan semua logic API di layer service/repository.
- Pastikan loading/error state selalu sinkron.
- Gunakan model typed untuk menghindari bug dari map dinamis.
