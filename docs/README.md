# Dokumentasi Proyek FARASA (Educational Ticketing)

Folder `docs/` berisi dokumentasi proyek yang dipisah per topik agar mudah dibaca, dirawat, dan dikembangkan.

## Daftar Dokumen

1. **overview.md**  
   Ringkasan proyek, tujuan, teknologi, dan status fase pengembangan.

2. **foldering.md**  
   Penjelasan struktur folder proyek dan tanggung jawab tiap layer.

3. **arsitektur.md**  
   Penjelasan arsitektur aplikasi (Presentation, Data, Domain) dan alur dependensi.

4. **api-integration.md**  
   Integrasi API berdasarkan `API_DOCUMENTATION.md` dan `openapi.yaml`, termasuk daftar endpoint utama.

5. **state-management.md**  
   Pola state management menggunakan Riverpod + ChangeNotifier (ViewModel).

6. **navigasi-dan-flow.md**  
   Alur navigasi aplikasi: Splash → Auth → Katalog → Pesanan/Payment → Tiket → Profil.

7. **flutter-widgets-dan-ui-methods.md**  
   Penjelasan widget, komposisi UI, dan method Flutter yang dipakai untuk membangun tampilan aplikasi.

8. **flutter-navigation-methods.md**  
   Penjelasan konsep dan method navigasi Flutter yang digunakan (route, replace, reset stack, alur tab).

9. **flutter-state-management-methods.md**  
   Penjelasan konsep Riverpod + ChangeNotifier, lifecycle state, serta pola update data di layar.

10. **flutter-networking-dan-async-methods.md**  
   Penjelasan method integrasi API, async/await, error handling, dan refresh data dari endpoint.

## Cara Pakai

- Mulai dari `overview.md` untuk memahami konteks proyek.
- Lanjutkan ke `foldering.md` dan `arsitektur.md` untuk orientasi kode.
- Gunakan dokumen topikal saat mengerjakan area spesifik (API/UI/navigation/state/networking).

## Catatan

Dokumentasi ini mengacu pada kondisi kode terbaru di folder `educational_ticketing/` pada saat file ini dibuat.
