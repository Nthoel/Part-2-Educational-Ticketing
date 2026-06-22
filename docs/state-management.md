# State Management

Project FARASA menggunakan kombinasi:

- **Riverpod** untuk dependency injection dan akses state lintas widget.
- **ChangeNotifier** sebagai ViewModel pattern per fitur.

## Pola yang Dipakai

### 1) Provider Registry

Semua provider diregistrasikan di:

- `lib/core/providers/app_providers.dart`

Isi utamanya:
- Provider service
- Provider repository
- `ChangeNotifierProvider` untuk ViewModel

### 2) ViewModel per Fitur

Contoh:
- `AuthViewModel`
- `EventListViewModel`
- `OrderDetailViewModel`
- `MyTicketsViewModel`
- `ProfileViewModel`

Tugas ViewModel:
- Menyimpan state (`isLoading`, `errorMessage`, data)
- Menjalankan aksi async
- Memanggil `notifyListeners()` saat state berubah

### 3) Konsumsi di View

Screen biasanya:
- `ref.watch(viewModelProvider)` untuk render state
- `ref.read(viewModelProvider)` untuk trigger action

## Pola State Umum

Hampir semua view model mengikuti pola:

1. set loading = true
2. clear error
3. panggil repository async
4. set data / set error
5. set loading = false
6. notifyListeners

## Kelebihan Pendekatan Ini

- Mudah dipahami untuk tim belajar.
- Konsisten di setiap fitur.
- Mudah dihubungkan dengan widget Flutter standar.
- Tetap modular karena DI dikelola Riverpod.

## Hal yang Perlu Dijaga

- Hindari logika bisnis berat langsung di View.
- Hindari parsing JSON di ViewModel (letakkan di service/model).
- Pastikan update state konsisten agar UI tidak stale.
