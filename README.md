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

---

## Lesson Learnt (Refleksi Akhir)

### 1. 💡 Konsep Baru
Baru memahami bahwa tanda underscore (`_`) di Dart bukan sekadar penamaan, tapi benar-benar membuat variabel menjadi **private** (hanya bisa diakses di dalam file yang sama). Ini adalah cara Dart menerapkan **Enkapsulasi** — salah satu pilar OOP. Contohnya `_counter`, `_step`, dan `_history` di `CounterController` tidak bisa diakses langsung dari `CounterView`, harus lewat getter/setter.

### 2. 🏆 Kemenangan Kecil
Berhasil memisahkan kode menjadi **Controller** dan **View** sesuai prinsip SRP, lalu menambahkan fitur History Logger **tanpa merusak fitur yang sudah ada**. Juga berhasil membuat commit terpisah per task (`Task 1` → `Task 2` → `Homework`) sehingga riwayat perubahan di Git rapi dan mudah dilacak.

### 3. 🎯 Target Berikutnya
Ingin belajar lebih dalam tentang **state management** yang lebih canggih (seperti `Provider` atau `Riverpod`) agar tidak hanya mengandalkan `setState()`. Juga ingin mengeksplorasi cara membuat tampilan UI yang lebih menarik dengan animasi dan tema kustom di modul berikutnya.

---

## 🤖 Log LLM: The Fact Check & Twist

> *Menggunakan AI itu boleh, yang tidak boleh adalah menjadi "Zombi AI" (Copy-Paste tanpa mikir).*

---

### Log 1 — Menambahkan Riwayat ke List dengan Batas 5 Data

| Komponen | Isian |
|----------|-------|
| **Pertanyaan (Prompt)** | "Saya punya class `CounterController` di Dart dengan fungsi `increment`, `decrement`, dan `reset`. Saya ingin menambahkan `List` untuk menyimpan riwayat setiap aktivitas, tapi dibatasi hanya **5 data terbaru** saja. Berikan logika murni Dart-nya tanpa UI." |
| **Jawaban AI (Intisari)** | AI menyarankan menggunakan `List<String>` dengan method `.add()` untuk menambah data ke akhir list. Untuk membatasi 5 item terakhir, gunakan `.sublist(length - 5)` saat mengambil data lewat getter, bukan menghapus data aslinya. |
| **The Fact Check** | Saya coba di DartPad: jika list masih kurang dari 5 item dan langsung pakai `sublist(length - 5)`, maka index-nya jadi negatif dan **error RangeError**. Solusinya saya tambahkan pengecekan `_history.length > 5 ? _history.sublist(_history.length - 5) : List.from(_history)` agar aman ketika data masih sedikit. |
| **The Twist (Modifikasi)** | Saya tidak hanya menyimpan teks biasa seperti `"+5"`, tapi menambahkan **timestamp otomatis** pakai `DateTime.now()` agar formatnya seperti logbook asli: *"User menambah nilai sebesar 5 pada jam 14:30:05"*. Juga menambahkan field `type` di setiap entry untuk membedakan jenis aktivitas. |

---

### Log 2 — Memberi Warna Berbeda pada Riwayat

| Komponen | Isian |
|----------|-------|
| **Pertanyaan (Prompt)** | "Di Flutter, bagaimana cara memberi warna berbeda pada setiap item `ListView` berdasarkan tipe data? Misal hijau untuk 'increment' dan merah untuk 'decrement'." |
| **Jawaban AI (Intisari)** | AI menyarankan mengubah tipe data history dari `List<String>` menjadi `List<Map<String, String>>` supaya setiap entry punya key `type` dan `message`. Lalu di UI, buat fungsi helper yang return `Color` berdasarkan value `type`. |
| **The Fact Check** | Saya coba langsung dan ternyata memang butuh **dua perubahan sekaligus**: di Controller (struktur data) dan di View (tampilan). Kalau cuma ubah satu sisi, maka error karena tipe data tidak cocok. Ini membuktikan pentingnya **konsistensi antara Controller dan View**. |
| **The Twist (Modifikasi)** | Selain warna, saya juga menambahkan **ikon berbeda** per tipe: `↑` (arrow_upward) untuk increment, `↓` (arrow_downward) untuk decrement, dan `↻` (refresh) untuk reset — bukan hanya warna saja seperti yang disarankan AI. |

---

### Log 3 — Dialog Konfirmasi Sebelum Reset

| Komponen | Isian |
|----------|-------|
| **Pertanyaan (Prompt)** | "Bagaimana cara menampilkan dialog konfirmasi di Flutter sebelum menjalankan aksi reset? Saya ingin ada tombol 'Batal' dan 'Reset' di dialog-nya." |
| **Jawaban AI (Intisari)** | AI menyarankan pakai `showDialog()` dengan widget `AlertDialog` yang punya `actions` berisi dua tombol. Gunakan `Navigator.of(context).pop()` untuk menutup dialog. |
| **The Fact Check** | Saya coba dan dialog bisa tampil, tapi ada masalah: setelah `Navigator.pop()`, **`setState()` tidak otomatis terpanggil** sehingga tampilan counter tidak langsung update. Solusinya saya pastikan `setState(() => _controller.reset())` dipanggil **sebelum** `Navigator.pop()` agar UI ter-rebuild dulu, baru dialog ditutup. |
| **The Twist (Modifikasi)** | Saya tambahkan **SnackBar** setelah reset berhasil, sebagai feedback visual tambahan: *"Counter berhasil direset!"*. Ini tidak disarankan AI, tapi menurut saya penting dari sisi UX agar user tahu aksinya sudah berhasil dijalankan. |