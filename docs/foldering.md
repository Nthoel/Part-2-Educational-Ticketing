# Foldering Proyek

Dokumen ini menjelaskan struktur folder utama pada project `educational_ticketing/`.

## Struktur Utama

```text
educational_ticketing/
├── assets/
│   └── images/
├── lib/
│   ├── core/
│   ├── data/
│   ├── domain/
│   ├── features/
│   └── shared/
├── test/
├── android/ ios/ web/ windows/ linux/ macos/
└── docs/
```

## Penjelasan Per Folder

### 1) `assets/`
Menyimpan resource statis aplikasi:
- Logo FARASA (`logo-farasa.jpeg`, `logo-farasa.png`, dll)
- Placeholder image event

### 2) `lib/core/`
Berisi fondasi global aplikasi:

- `config/`  
  Konfigurasi environment (`env.dart`) seperti `base_url`.
- `network/`  
  Setup API client (`api_client.dart`) dan interceptor.
- `providers/`  
  Registrasi provider Riverpod (`app_providers.dart`).
- `theme/`  
  Definisi tema app (`app_theme.dart`) Neo Brutalism.

### 3) `lib/data/`
Lapisan data sumber mentah (API):

- `models/`  
  API model (DTO) hasil parsing JSON endpoint.
- `services/`  
  Komunikasi HTTP per domain endpoint (auth, catalog, orders, tickets, profile).
- `repositories/`  
  Jembatan service -> domain model, dipakai ViewModel.

### 4) `lib/domain/`
Lapisan model bisnis aplikasi:
- `models/` seperti `User`, `Event`, `Order`, `Ticket`, `PaginationMeta`.
- Model domain dipakai UI/ViewModel, bukan API DTO mentah.

### 5) `lib/features/`
Implementasi fitur per modul:
- `auth/`
- `splash/`
- `catalog/`
- `orders/`
- `tickets/`
- `profile/`

Masing-masing berisi `presentation/`:
- `views/` (halaman/widget)
- `view_models/` (state & action)

### 6) `lib/shared/`
Komponen UI reusable lintas fitur:
- `widgets/neo_brutal_card.dart`

### 7) `test/`
Unit/widget test Flutter.

### 8) Folder platform (`android/ios/web/...`)
Kode bootstrap/build per platform target Flutter.

### 9) `docs/`
Dokumentasi proyek yang dipisah per topik.

## Prinsip Foldering yang Dipakai

1. **Separation of Concerns**  
   UI, data source, domain model dipisah jelas.
2. **Scalable by Feature**  
   Penambahan fitur baru dilakukan di `features/` tanpa mengganggu modul lain.
3. **Reusability**  
   Komponen umum ditempatkan di `shared/`.
4. **Maintainability**  
   Konfigurasi global dipusatkan di `core/`.
