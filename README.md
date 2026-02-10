# logbook_app_001

A new Flutter project — Counter App dengan prinsip **Single Responsibility Principle (SRP)**.

## Struktur Proyek

| File | Tanggung Jawab |
|------|----------------|
| `lib/main.dart` | Entry point aplikasi, konfigurasi tema & routing |
| `lib/counter_controller.dart` | Logic: mengelola counter, step, dan riwayat aktivitas |
| `lib/counter_view.dart` | UI: menampilkan counter, slider, tombol, dan riwayat |

## Getting Started

This project is a starting point for a Flutter application.

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Self-Reflection: Bagaimana Prinsip SRP Membantu Saat Menambah Fitur History Logger?

Prinsip **Single Responsibility Principle (SRP)** menyatakan bahwa setiap class/module seharusnya hanya memiliki **satu alasan untuk berubah**. Dalam proyek ini, kami memisahkan:

- **`CounterController`** → Bertanggung jawab **hanya** atas logic dan data (nilai counter, step, riwayat).
- **`CounterView`** → Bertanggung jawab **hanya** atas tampilan UI.

Ketika diminta menambahkan fitur **History Logger**, SRP sangat membantu karena:

1. **Perubahan terfokus** — Kami cukup menambahkan `List _history` dan logic pencatatan di `CounterController` tanpa menyentuh kode UI sama sekali untuk bagian logic.
2. **Tidak ada efek samping** — Karena logic terpisah dari UI, menambahkan fitur riwayat tidak berisiko merusak tampilan yang sudah berjalan.
3. **Mudah di-test** — `CounterController` bisa diuji secara independen tanpa perlu menjalankan widget Flutter.
4. **Kolaborasi lebih mudah** — Satu orang bisa mengerjakan logic riwayat di controller, sementara orang lain mengerjakan tampilan riwayat di view, tanpa konflik.
5. **Kode lebih mudah dibaca** — Saat mencari bug di riwayat, kami tahu pasti harus melihat ke `CounterController` untuk masalah data, atau `CounterView` untuk masalah tampilan.

Tanpa SRP, semua kode akan tercampur di satu file, dan menambah fitur baru akan jauh lebih berisiko dan membingungkan.