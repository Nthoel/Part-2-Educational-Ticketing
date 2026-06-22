# Overview Proyek FARASA

## Ringkasan

**FARASA** adalah aplikasi Flutter untuk skenario Educational Ticketing.  
Aplikasi ini mengimplementasikan alur utama:

1. Splash
2. Auth (Login/Register)
3. Katalog Event
4. Order (buat pesanan)
5. Payment (simulasi pembayaran)
6. Tickets (lihat tiket aktif)
7. Profile (lihat/update profil + logout)

Backend menggunakan REST API dengan autentikasi JWT Bearer Token.

## Tujuan Proyek

- Menjadi media belajar implementasi arsitektur aplikasi mobile yang rapi.
- Menerapkan integrasi API real dengan pola Repository.
- Menyediakan alur transaksi tiket dari browsing sampai tiket terbit.
- Menjaga konsistensi UI bertema **Neo Brutalism** dengan keterbacaan baik.

## Teknologi Utama

- Flutter (Material 3)
- Riverpod (provider + injection)
- ChangeNotifier (ViewModel)
- Dio (HTTP client)
- flutter_secure_storage (token)
- intl (format tanggal/jam)
- cached_network_image (gambar event)
- qr_flutter (detail tiket, sesuai fase berikutnya)
- flutter_dotenv (.env config)

## Status Implementasi (Ringkas)

Sudah tersedia fondasi penting:

- Struktur project berlapis (core/data/domain/features/shared)
- Integrasi endpoint utama auth, profile, katalog, orders, tickets
- Navigation flow utama aplikasi
- Bottom navigation 3 tab (Katalog, Tiket, Profil)
- Pending order ditampilkan di halaman tiket sebagai “Menunggu Pembayaran” untuk lanjut bayar/batal

## Sumber Acuan

- `API_DOCUMENTATION.md`
- `openapi.yaml`
