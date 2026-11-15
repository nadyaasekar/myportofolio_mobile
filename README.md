# MyPortfolio Mobile

Aplikasi portofolio pribadi berbasis Flutter untuk mata kuliah Pemrograman Berbasis Platform.

## Identitas

- Nama: Nadya Sekar
- NPM: 2506607133
- Kelas: D

## Fitur

- Menampilkan kartu identitas berupa NPM, nama, dan kelas.
- Menampilkan menu Lihat Proyek, Tambah Proyek, dan Logout.
- Menggunakan warna berbeda untuk setiap tombol menu.
- Menampilkan SnackBar sesuai tombol yang ditekan.

Tombol saat ini hanya menampilkan SnackBar dan belum melakukan navigasi, pengelolaan data, atau logout sesungguhnya.

## Menjalankan Proyek

Pastikan Flutter SDK dan Google Chrome sudah terpasang. Setelah mengunduh atau melakukan clone repository, jalankan dari folder proyek:

```bash
flutter pub get
flutter run -d chrome
```

Untuk memeriksa kode dan menjalankan pengujian:

```bash
flutter analyze
flutter test
```

## Struktur Proyek

- `lib/main.dart`: titik awal aplikasi dan pengaturan tema melalui MaterialApp.
- `lib/menu.dart`: halaman utama, InfoCard, model ItemHomepage, dan ItemCard.
- `test/widget_test.dart`: pengujian tampilan identitas, menu, dan SnackBar.

## Progres Mingguan

### Tutorial 08

Membuat proyek Flutter, memisahkan halaman utama dari main.dart, menggunakan StatelessWidget, serta menambahkan kartu identitas dan menu dengan SnackBar.

### Tugas Individual 7

Melanjutkan proyek tutorial dengan menambahkan atribut warna pada ItemHomepage agar setiap tombol memiliki warna berbeda. Melengkapi dokumentasi, AI disclosure, dan jawaban reflektif.

## Refleksi

### Tugas 7

1. widget tree adalah susunan widget berbentuk pohon yang membentuk tampilan Flutter. widget induk membungkus dan mengatur widget anak melalui properti seperti `child` atau `children`. pada proyek saya, `Scaffold` menyediakan kerangka halaman, sedangkan `Column` menyusun kartu identitas, teks sambutan, dan menu secara vertikal.

2. widget yang saya gunakan adalah:
   - `MyApp`: widget utama yang mengembalikan MaterialApp.
   - `MaterialApp`: mengatur tema dan halaman awal aplikasi.
   - `MyHomePage`: menyusun halaman utama portofolio.
   - `Scaffold`: menyediakan kerangka halaman dengan AppBar dan body.
   - `AppBar`: menampilkan judul aplikasi di bagian atas.
   - `SingleChildScrollView`: memungkinkan konten halaman digulir.
   - `Padding`: memberi jarak di sekitar konten.
   - `Column` dan `Row`: menyusun widget secara vertikal dan horizontal.
   - `Expanded`: membagi ruang pada Row agar kartu identitas memiliki lebar yang seimbang.
   - `InfoCard` dan `Card`: membentuk kartu informasi identitas.
   - `Text`: menampilkan tulisan.
   - `SizedBox`: memberi jarak antar-widget.
   - `GridView.count`: menyusun tombol menu dalam tiga kolom.
   - `ItemCard`: membentuk tampilan setiap tombol menu.
   - `Material`: memberikan warna latar dan bentuk kartu menu.
   - `InkWell`: menangani ketukan dan memberikan efek sentuhan.
   - `Icon`: menampilkan ikon menu.
   - `SnackBar`: menampilkan pesan singkat setelah tombol ditekan.

   `ItemHomepage` merupakan model data, bukan widget. sementara itu, `ScaffoldMessenger.of(context)` digunakan untuk mengakses pengelola SnackBar.

3. `MaterialApp` berfungsi mengatur aplikasi berbasis Material Design, seperti tema, halaman awal, dan navigasi. widget ini biasanya ditempatkan di dekat akar widget tree agar pengaturan tersebut dapat digunakan oleh widget di bawahnya. pada proyek saya, MaterialApp mengatur warna tema dan menampilkan MyHomePage sebagai halaman awal.

4. `StatelessWidget` tidak memiliki objek State yang mengelola perubahan internal, sedangkan `StatefulWidget` memiliki State yang dapat berubah dan memicu pembaruan tampilan melalui `setState`. saya menggunakan StatelessWidget karena halaman ini menampilkan identitas dan menu yang tetap. StatefulWidget lebih sesuai untuk tampilan seperti penghitung atau pilihan yang berubah akibat interaksi pengguna. StatelessWidget tetap bisa dibangun ulang ketika konfigurasi dari induknya berubah.

5. `BuildContext` menunjukkan posisi sebuah widget dalam widget tree. context penting untuk mengakses informasi atau layanan dari widget di atasnya. pada metode `build`, saya menggunakan `Theme.of(context)` untuk mengambil tema dan `ScaffoldMessenger.of(context)` pada callback tombol untuk menampilkan SnackBar. context harus berada di bawah widget yang menyediakan layanan tersebut.

6. hot reload menerapkan perubahan kode dan membangun ulang tampilan sambil mempertahankan state aplikasi. hot restart memulai ulang aplikasi Dart sehingga state kembali ke kondisi awal. hot reload cocok untuk perubahan tampilan, sedangkan hot restart diperlukan untuk menjalankan ulang inisialisasi seperti `main` atau `initState`. perubahan kode native atau konfigurasi platform tertentu memerlukan full restart, yaitu menghentikan lalu menjalankan aplikasi kembali.

## Penggunaan AI

Saya menggunakan ChatGPT/Codex untuk membantu memahami widget Flutter, menyusun contoh kode, menangani kendala instalasi, dan membuat draf dokumentasi serta pengujian.

Strategi prompting yang saya gunakan adalah meminta penjelasan dan perubahan secara bertahap, lalu memberikan potongan kode, screenshot, atau output terminal agar saran sesuai dengan kondisi proyek.

Contoh log prompting:
- Meminta tahapan Tutorial 08 beserta kode yang bisa diterapkan secara bertahap.
- Mengirim error instalasi Android Studio dan hasil `flutter doctor`.
- Meminta langkah lanjutan Tugas Individual 7 berdasarkan PDF.
- Meminta penjelasan perbedaan kebutuhan tugas dengan tutorial.

Bagian yang dibantu AI mencakup penyusunan InfoCard dan ItemCard, penambahan atribut warna, pengujian SnackBar, serta draf jawaban reflektif.

AI memiliki keterbatasan dalam memastikan kondisi perangkat dan menafsirkan kebutuhan tugas. Contohnya, AI sempat mengarahkan pengujian emulator tanpa langsung menjelaskan bahwa menjalankan emulator bersifat opsional. Setelah memeriksa kembali tutorial, pengujian aplikasi dilanjutkan melalui Chrome.

Saya menerapkan perubahan secara manual, mengisi kelas D, menjalankan aplikasi, serta memeriksa hasil analyzer dan pengujian. Saran AI tetap perlu dicocokkan dengan instruksi tugas dan hasil aktual proyek.