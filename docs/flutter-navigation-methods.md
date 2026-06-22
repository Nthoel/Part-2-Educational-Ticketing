# Flutter Navigation Methods yang Digunakan

Dokumen ini menjelaskan konsep dan method navigasi Flutter pada aplikasi FARASA.

## Konsep Navigasi

Aplikasi menggunakan **Navigator 1.0 (imperative routing)** berbasis MaterialPageRoute.

Alasan:
- Sederhana
- Cocok untuk scope proyek saat ini
- Mudah dipahami untuk pembelajaran

## Method Navigasi Utama

### 1) `Navigator.push`
Menambahkan halaman baru ke atas stack.

Contoh penggunaan:
- Buka detail event dari daftar event
- Buka detail tiket dari daftar tiket
- Buka detail order dari kartu pending order

Efek:
- User bisa kembali ke halaman sebelumnya dengan back.

### 2) `Navigator.pushReplacement`
Mengganti halaman saat ini dengan halaman baru.

Contoh penggunaan:
- Pindah tab Katalog <-> Tiket <-> Profil
- Menghindari stack menumpuk saat tab switching

Efek:
- Halaman sebelumnya diganti, bukan ditumpuk.

### 3) `Navigator.pushAndRemoveUntil`
Push halaman baru lalu hapus route sebelumnya sesuai predicate.

Contoh penggunaan:
- Logout dari profil -> kembali ke login dan reset stack

Umumnya memakai:
- `(route) => false` untuk membersihkan seluruh stack.

## Alur Tab Navigation

Bottom navbar berada di 3 layar utama:
- EventListScreen (Katalog)
- MyTicketsScreen (Tiket)
- ProfileScreen (Profil)

Teknis:
- Item navbar dipilih berdasarkan index aktif.
- Saat klik tab lain, gunakan `pushReplacement`.

## Praktik yang Diterapkan

1. Logout hanya tersedia di Profil.
2. Tab aktif selalu sinkron dengan halaman.
3. Aksi detail (event/order/ticket) menggunakan `push`.
4. Pergantian area utama (tab) menggunakan `pushReplacement`.
5. Keluar sesi menggunakan `pushAndRemoveUntil` agar aman.

## Saran Pengembangan Lanjutan

Jika flow semakin kompleks, pertimbangkan:
- `go_router` untuk declarative routing + deep link.
- Route guard auth terpusat.
- Shell route untuk mempertahankan bottom nav state lebih efisien.
