# Navigasi dan Flow Aplikasi

Dokumen ini menjelaskan alur layar dan metode navigasi yang digunakan di FARASA.

## Alur Utama

1. **SplashScreen**
2. **Login/Register**
3. **Katalog Event**
4. **Detail Event**
5. **Create Order**
6. **Detail Pesanan (pending: bayar/batal)**
7. **Tiket Saya**
8. **Detail Tiket**
9. **Profil Saya**

## Bottom Navigation

Terdapat 3 tab utama:

- Katalog
- Tiket
- Profil

Bottom navbar tampil di ketiga halaman tersebut agar user bisa berpindah cepat.

## Pola Navigasi yang Dipakai

### 1) Push
Digunakan untuk membuka detail dari list:

- Event list -> event detail
- Ticket list -> ticket detail
- Pending order card -> order detail

Method:
- `Navigator.of(context).push(...)`

### 2) Push Replacement
Digunakan saat pindah antar tab utama agar tidak menumpuk stack berulang:

- Katalog <-> Tiket <-> Profil

Method:
- `Navigator.of(context).pushReplacement(...)`

### 3) Push And Remove Until
Digunakan saat logout agar user tidak bisa kembali ke halaman sebelumnya lewat tombol back.

Method:
- `Navigator.of(context).pushAndRemoveUntil(..., (route) => false)`

## Flow Pending Order di Halaman Tiket

Masalah bisnis yang sudah ditangani:
- Order `pending` belum menghasilkan tiket aktif di endpoint tiket.
- Solusi: halaman Tiket menampilkan section **Menunggu Pembayaran** dari data endpoint orders (`status == pending`).
- Tiap item pending bisa ditekan untuk masuk ke detail pesanan dan melakukan:
  - Bayar sekarang
  - Batalkan pesanan

## Catatan UX

- Logout hanya dari halaman Profil.
- Katalog tidak menampilkan tombol logout.
- Tab aktif disesuaikan dengan halaman yang sedang terbuka.
