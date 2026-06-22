# Flutter Widgets dan UI Methods yang Digunakan

Dokumen ini merangkum konsep widget dan method UI Flutter yang dipakai di proyek FARASA.

## Widget Layout Dasar

### Scaffold
Digunakan sebagai kerangka utama layar:
- `appBar`
- `body`
- `bottomNavigationBar`

### SafeArea
Menjaga konten tidak tertabrak area sistem (notch/status bar).

### Column / Row / Expanded
Menyusun komponen secara vertikal/horizontal dan mengatur distribusi ruang.

### ListView / ListView.builder
Menampilkan daftar data dinamis:
- event list
- order list
- ticket list

### Padding / SizedBox / Center
Pengaturan spacing dan alignment.

## Widget Input dan Form

### TextField / TextFormField
Input user (email, password, pencarian, nama profil).

### GlobalKey<FormState> + Validator
Validasi form login/register.

### DropdownButtonFormField
Digunakan untuk filter/sort.

### ElevatedButton / TextButton / IconButton
Aksi utama dan aksi sekunder.

## Widget Feedback UI

### CircularProgressIndicator
Status loading.

### RefreshIndicator
Pull-to-refresh data list.

### SnackBar
Menampilkan feedback sukses/gagal.

## Widget Visual Kustom

### NeoBrutalCard
Widget reusable untuk tampilan kartu Neo Brutalism:
- border tegas
- warna kontras
- radius sederhana
- visual playful tapi tetap terbaca

## Widget Media

### CachedNetworkImage
Load poster event dari URL API dengan fallback error.

### Image.asset
Aset lokal seperti logo dan placeholder.

## Widget Navigasi Tab

### NavigationBar + NavigationDestination
Bottom navbar utama 3 tab:
- Katalog
- Tiket
- Profil

## Method UI yang Sering Dipakai

- `setState()`  
  Update state lokal halaman (contoh: selected index tab).
- `showModalBottomSheet()`  
  Picker metode pembayaran.
- `Theme.of(context)`  
  Akses style tema global.
- `copyWith(...)` pada TextStyle  
  Menyesuaikan style tanpa mengulang semua properti.
