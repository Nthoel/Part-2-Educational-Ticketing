# Arsitektur Aplikasi

## Pendekatan Arsitektur

Project FARASA menggunakan arsitektur berlapis dengan pemisahan tanggung jawab:

1. **Presentation Layer**  
   Halaman (View) + ViewModel (state, action UI).
2. **Data Layer**  
   Service (HTTP) + Repository (mapping & orkestrasi data).
3. **Domain Layer**  
   Entitas/model domain yang bersih untuk dipakai UI.

## Alur Data

```text
View (UI)
  -> ViewModel (ChangeNotifier)
    -> Repository
      -> Service (Dio)
        -> REST API
      <- API DTO
    <- Domain Model
  <- State update (notifyListeners)
```

## Komponen Kunci

### View
- Menampilkan state.
- Memanggil method ViewModel saat user berinteraksi.
- Tidak berisi logika bisnis berat.

### ViewModel
- Menangani loading/error/success state.
- Menjalankan use case sederhana per aksi layar.
- Berkomunikasi ke repository.

### Repository
- Menjadi titik akses data utama dari ViewModel.
- Konversi API model ke domain model.
- Menjaga agar ViewModel tidak tergantung format API mentah.

### Service
- Melakukan request HTTP ke endpoint.
- Parsing response JSON menjadi API model.

## Dependency Injection

DI menggunakan Riverpod provider pada `core/providers/app_providers.dart`:

- Service provider
- Repository provider
- ViewModel provider

Manfaat:
- Modular
- Testable
- Mudah diganti implementasi (mock/fake saat test)

## Keuntungan Arsitektur Ini

1. **Mudah dirawat**: perubahan API tidak langsung memengaruhi UI.
2. **Mudah diskalakan**: tambah fitur tinggal tambah modul feature + provider.
3. **Lebih testable**: ViewModel/Repository dapat diuji terpisah.
4. **Konsisten**: pola sama di semua fitur (Auth, Catalog, Orders, Tickets, Profile).
