# Flutter State Management Methods yang Digunakan

Dokumen ini menjelaskan metode state management yang dipakai di FARASA.

## Pendekatan Utama

- **Riverpod** untuk dependency injection dan akses provider.
- **ChangeNotifier** untuk mengelola state layar (ViewModel).

Kombinasi ini cocok untuk:
- Struktur yang modular
- Mudah dipahami
- Mudah di-test

## Komponen Inti

### Provider
Didefinisikan di `core/providers/app_providers.dart`:
- Provider service
- Provider repository
- Provider ViewModel (ChangeNotifierProvider)

### ViewModel (ChangeNotifier)
Setiap fitur punya ViewModel sendiri.

Contoh tanggung jawab:
- Menyimpan data list/detail
- Status loading
- Error message
- Action async (fetch, refresh, submit, cancel, pay)

## Method yang Umum Dipakai

### `notifyListeners()`
Memicu rebuild widget yang mendengarkan ViewModel.

### `ref.watch(provider)`
Mendengarkan perubahan state untuk render UI.

### `ref.read(provider)`
Mengambil instance provider untuk memanggil method tanpa subscribe rebuild.

### Lifecycle init
Pada `initState`, screen memicu load data awal melalui view model.

## Pola Async State

Pola standar pada method async:

1. set loading true
2. reset error
3. panggil repository/service
4. set data atau set error
5. set loading false
6. `notifyListeners()`

## Penerapan Kasus Nyata

### Halaman Tiket
- Data tiket aktif: dari `MyTicketsViewModel`.
- Data pending order: dari `MyOrdersViewModel`.
- UI menggabungkan dua sumber state agar user bisa:
  - melihat tiket aktif
  - melihat transaksi pending dan lanjutkan pembayaran/batal

Ini menyelesaikan gap bisnis saat endpoint tiket belum memuat order pending.

## Praktik Baik yang Diterapkan

- Pisahkan state per fitur agar tidak saling mengganggu.
- Hindari logic API di widget.
- Konsisten memberi feedback loading/error ke user.
- Sediakan `refresh()` agar state bisa sinkron ulang dari server.
