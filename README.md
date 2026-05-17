# 🕋 Jadwal Salat - Flutter

Aplikasi Jadwal Salat adalah aplikasi multiplatform yang dibangun menggunakan **Flutter** untuk menyediakan jadwal salat yang akurat di seluruh Indonesia. Data jadwal salat diambil secara dinamis (scraping) dari situs resmi **Bimas Islam Kementerian Agama Republik Indonesia (Kemenag RI)**.

Aplikasi ini didesain khusus untuk berjalan dengan mulus di platform mobile (**Android**) maupun desktop (**Linux**, **Windows**, dan **macOS**), dilengkapi dengan fitur integrasi desktop yang mendalam seperti *System Tray* dan *Desktop Notifications*.

---

## ✨ Fitur Utama

Aplikasi ini dirancang sederhana namun memiliki fitur yang sangat kaya untuk menunjang kenyamanan pengguna:

1. **Jadwal Akurat Kemenag RI (Scraping Otomatis)**
   * Memungkinkan pengguna memilih Provinsi dan Kabupaten/Kota di seluruh Indonesia.
   * Data diambil langsung secara dinamis dari database resmi Bimas Islam Kemenag RI.

2. **Dashboard Jadwal Salat Interaktif & Dinamis**
   * **Countdown Real-Time**: Menampilkan hitung mundur waktu yang tersisa menuju salat berikutnya secara *real-time* (berdetik setiap detik).
   * **Time Elapsed**: Menampilkan berapa lama waktu yang telah berlalu sejak salat sebelumnya jika waktu salat saat ini sedang berlangsung.
   * **Visual Highlight**: Menyorot waktu salat terdekat dan salat berikutnya dengan warna penanda khusus (Teal & Amber).
   * **Navigasi Tanggal Mudah**: Dilengkapi pemilih tanggal yang interaktif di bagian bawah (tombol Hari Sebelumnya, Hari Berikutnya, atau klik tanggal untuk kembali ke hari ini).

3. **Penyimpanan Lokal & Caching Offline (Drift Database)**
   * Menggunakan database SQLite lokal berkinerja tinggi melalui **Drift** (sebelumnya Moor) untuk menyimpan jadwal bulanan yang sudah diunduh.
   * Aplikasi tetap berfungsi penuh secara offline tanpa koneksi internet setelah jadwal bulanan berhasil disinkronkan sekali.

4. **Notifikasi Pengingat Salat Otomatis**
   * **Android**: Notifikasi terjadwal yang andal melalui saluran (*channel*) notifikasi presisi tinggi.
   * **Linux/Desktop**: Mengirimkan notifikasi desktop kritis menggunakan daemon notifikasi bawaan OS dengan pengaturan durasi yang pas.

5. **Integrasi System Tray (Desktop - Linux/Windows/macOS)**
   * **Minimize-to-Tray**: Menutup aplikasi (tombol X) tidak akan menghentikan proses, melainkan menyembunyikannya ke System Tray agar notifikasi tetap berjalan di latar belakang.
   * **Quick Actions**: Klik kiri pada ikon tray untuk langsung memulihkan/menampilkan jendela aplikasi. Klik kanan untuk membuka menu konteks (Tampilkan Aplikasi atau Keluar).

6. **Desain Modern Material 3**
   * Antarmuka bersih, responsif, dan menenangkan dengan palet warna Teal yang disesuaikan secara harmonis.

---

## 📦 Instalasi dari Halaman Rilis (Releases)

Bagi pengguna yang ingin langsung menggunakan aplikasi tanpa melakukan *build* dari *source code*, Anda dapat mengunduh paket siap pakai langsung dari **[Halaman Rilis / Release Page](https://github.com/akmalabiyoga/flutter_salat/releases)**:

### 🤖 Android (.apk)
Kami menyediakan beberapa opsi berkas `.apk` di Halaman Rilis untuk menyesuaikan dengan kebutuhan perangkat Anda:
* **`flutter_salat_android_universal.apk`**: Berisi seluruh arsitektur sistem. Pilih berkas ini jika Anda ragu mengenai jenis prosesor ponsel Anda. Ukuran berkas paling besar.
* **`flutter_salat_android_arm64-v8a.apk`**: **Sangat direkomendasikan** untuk sebagian besar ponsel Android modern saat ini (ARM 64-bit). Ukuran berkas jauh lebih kecil sehingga sangat menghemat kuota data unduhan Anda.
* **`flutter_salat_android_armeabi-v7a.apk`**: Khusus untuk ponsel Android tipe lama (ARM 32-bit).
* **`flutter_salat_android_x86_64.apk`**: Khusus untuk emulator Android atau perangkat tertentu dengan prosesor berbasis Intel/AMD x86_64.

**Langkah Instalasi**:
1. Unduh salah satu berkas `.apk` yang sesuai dengan ponsel Anda dari Halaman Rilis.
2. Buka berkas `.apk` hasil unduhan melalui aplikasi File Manager di ponsel Anda.
3. Berikan izin instalasi dari sumber tidak dikenal (*unknown sources*) jika diminta oleh sistem operasi Android Anda.
4. Aplikasi siap digunakan!

### 🐧 Linux (.tar.gz)
Untuk distribusi desktop Linux, kami menyediakan paket arsip `.tar.gz` portabel yang sudah dibundel dengan semua pustaka pendukung (*shared libraries*) yang diperlukan.
1. Unduh berkas `jadwal-salat-linux.tar.gz` dari Halaman Rilis.
2. Ekstrak arsip tersebut menggunakan perintah terminal berikut:
   ```bash
   tar -xvf jadwal-salat-linux.tar.gz
   cd jadwal-salat-linux
   ```
3. **Menjalankan Aplikasi**: Anda dapat langsung menjalankan aplikasi melalui skrip pembungkus (*wrapper script*):
   ```bash
   ./run_app.sh
   ```
4. **Memasang ke Menu Aplikasi Desktop**: Agar aplikasi terpasang di menu aplikasi desktop Anda (Application Launcher) sehingga mudah dicari, jalankan perintah instalasi berikut di dalam direktori hasil ekstrak:
   ```bash
   ./install.sh
   ```
   *Skrip ini akan secara otomatis membuat pintasan desktop `.desktop` dan mendaftarkan aset ikon ke dalam menu sistem.*
5. **Menghapus Aplikasi**: Jika Anda ingin menghapus instalasi aplikasi beserta seluruh pintasan desktop dari menu sistem secara bersih, jalankan:
   ```bash
   ./uninstall.sh
   ```

---

## 🛠️ Panduan Build & Kompilasi Mandiri

Jika Anda ingin melakukan modifikasi kode atau melakukan *build* mandiri dari *source code*, ikuti langkah-langkah di bawah ini.

### 📋 Prasyarat Umum
* **Flutter SDK**: Versi `^3.11.5` atau yang lebih baru.
* **Dart SDK**: Terintegrasi di dalam Flutter SDK.
* **Linux (Spesifik Desktop)**: Jika Anda melakukan build rilis Linux mandiri, pastikan pustaka berikut sudah terinstal di sistem Anda:
  ```bash
  sudo apt install libayatana-appindicator3-dev libgtk-3-dev ninja-build pkg-config
  ```

### ⚙️ Persiapan Awal (Untuk Semua Platform)
1. **Kloning Repositori**:
   ```bash
   git clone https://github.com/akmalabiyoga/flutter_salat.git
   cd flutter_salat
   ```
2. **Unduh Dependensi**:
   ```bash
   flutter pub get
   ```
3. **Generate Kode Database (Penting!)**:
   Aplikasi ini menggunakan **Drift** untuk kebutuhan database lokal. File penunjang database (`database.g.dart`) harus di-generate terlebih dahulu menggunakan `build_runner` agar aplikasi bisa dikompilasi tanpa error:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

---

## 🖥️ Kompilasi Khusus Platform Non-Rilis (Windows, iOS, macOS)

> [!WARNING]  
> **PENTING - Catatan AI**: Seluruh panduan kompilasi untuk platform Windows, iOS, dan macOS di bawah ini diformulasikan secara otomatis oleh AI. **Langkah-langkah build ini belum diverifikasi atau diuji secara langsung oleh pengembang aplikasi ini.** Kami menyantumkannya di sini sebagai panduan dasar umum Flutter. Jika Anda mencoba melakukan kompilasi pada platform tersebut dan menemukan kendala, silakan laporkan melalui *Issue* atau kirimkan *Pull Request* perbaikan Anda!

### 🪟 1. Windows Desktop
Sebelum melakukan build di Windows, pastikan Anda telah menginstal **Visual Studio** (bukan VS Code) yang dilengkapi dengan beban kerja **"Desktop development with C++"** beserta Windows SDK yang sesuai.

Langkah kompilasi:
```bash
# Jalankan dalam mode debug
flutter run -d windows

# Build rilis (.exe)
flutter build windows --release
```
*Hasil rilis berupa file `.exe` dan pustaka pendukung dapat ditemukan di direktori `build/windows/x64/release/runner/`.*

### 🍏 2. macOS Desktop
Sebelum melakukan build di macOS, pastikan Anda menggunakan komputer Mac dan sudah menginstal **Xcode** serta **CocoaPods**.

Langkah kompilasi:
```bash
# Sinkronisasi dependensi native cocoapods
cd macos && pod install && cd ..

# Jalankan dalam mode debug
flutter run -d macos

# Build rilis (.app)
flutter build macos --release
```
*Hasil rilis berupa aplikasi Mac siap pakai `.app` berada di direktori `build/macos/Build/Products/Release/`.*

### 📱 3. iOS Mobile
Untuk melakukan build ke perangkat iOS, Anda membutuhkan komputer Mac, **Xcode**, **CocoaPods**, serta keanggotaan Apple Developer Account (untuk *code signing* jika ingin dicoba langsung di perangkat fisik).

Langkah kompilasi:
```bash
# Sinkronisasi dependensi native cocoapods
cd ios && pod install && cd ..

# Build paket arsip (.ipa / Xcode build)
flutter build ipa --release
```
*Anda dapat melanjutkan proses instalasi lokal atau pengunggahan ke TestFlight menggunakan Xcode melalui berkas proyek `ios/Runner.xcworkspace`.*

---

## 🤝 Cara Berkontribusi

Kami sangat senang menerima kontribusi dari komunitas! Baik itu berupa pelaporan *bug*, perbaikan kode, penulisan dokumentasi, atau usulan fitur baru.

Berikut adalah langkah-langkah untuk berkontribusi:

1. **Fork** repositori ini ke akun GitHub Anda.
2. Buat branch baru untuk fitur atau perbaikan Anda:
   ```bash
   git checkout -b fitur/nama-fitur-anda
   # atau jika perbaikan bug
   git checkout -b perbaikan/deskripsi-bug
   ```
3. Lakukan perubahan kode Anda. **Pastikan Anda mematuhi standar berikut sebelum komit**:
   * Jalankan formatter kode Dart agar rapi dan seragam:
     ```bash
     dart format .
     ```
   * Pastikan tidak ada error analisis statis:
     ```bash
     flutter analyze
     ```
4. Lakukan komit perubahan dengan pesan yang jelas dan deskriptif:
   ```bash
   git commit -m "Fitur: Menambahkan dukungan format waktu 24 jam"
   ```
5. Push branch Anda ke repositori fork di GitHub:
   ```bash
   git push origin fitur/nama-fitur-anda
   ```
6. Buka halaman repositori asli ini dan buat **Pull Request (PR)** dengan menyertakan deskripsi lengkap tentang apa yang Anda tambahkan atau perbaiki.

---

## 📄 Lisensi

Proyek ini dilisensikan di bawah **GNU General Public License v3.0 (GPL-3.0)** - lihat file [LICENSE](file:///home/dedoy/kode/flutter_salat/LICENSE) untuk detail selengkapnya. Lisensi GPLv3 menjamin kebebasan Anda untuk menggunakan, mempelajari, membagikan, dan memodifikasi perangkat lunak ini secara bebas dengan tetap menjaga keterbukaan kode sumber untuk publik.

---
*Dibuat dengan 💚 untuk membantu kaum muslimin menjaga waktu salat tepat waktu.*
