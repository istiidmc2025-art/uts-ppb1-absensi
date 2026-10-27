import 'data.dart';
import 'input.dart';
import 'dart:io';

// ============================================================
// Fungsi bantu
// ============================================================

/// Mencari mahasiswa berdasarkan NIM. Mengembalikan null jika tidak ada.
Map<String, dynamic>? cariByNim(String nim) {
  for (final mhs in daftarMahasiswa) {
    if (mhs['nim'] == nim) return mhs;
  }
  return null;
}

/// Mencetak satu baris data mahasiswa.
void cetakMahasiswa(Map<String, dynamic> mhs) {
  print('${mhs['nim']} | ${mhs['nama']}');
}

/// Meminta pengguna memilih status kehadiran.
StatusHadir bacaStatus(String label) {
  final pilihan = bacaInt(
    '$label (1=hadir, 2=izin, 3=sakit, 4=alpa)',
    min: 1,
    max: 4,
  );
  return switch (pilihan) {
    1 => StatusHadir.hadir,
    2 => StatusHadir.izin,
    3 => StatusHadir.sakit,
    _ => StatusHadir.alpa,
  };
}

// ============================================================
// Fitur yang sudah jadi
// ============================================================

/// Menu 1: menampilkan semua mahasiswa.
void tampilkanDaftar() {
  print('\n=== Daftar Mahasiswa ===');
  if (daftarMahasiswa.isEmpty) {
    print('Belum ada data mahasiswa.');
    return;
  }
  for (final mhs in daftarMahasiswa) {
    cetakMahasiswa(mhs);
  }
}

/// Menu 2: mencatat absensi untuk pertemuan berikutnya.
void catatAbsensi() {
  final nomor = absensi.length + 1;
  print('\n=== Catat Absensi Pertemuan $nomor ===');
  final Map<String, StatusHadir> data = {};
  for (final mhs in daftarMahasiswa) {
    data[mhs['nim'] as String] = bacaStatus('Status ${mhs['nama']}');
  }
  absensi[nomor] = data;
  print('Absensi pertemuan $nomor tersimpan.');
}

/// Menu 3: menampilkan absensi pada satu pertemuan.
void tampilkanAbsensiPertemuan() {
  print('\n=== Absensi per Pertemuan ===');
  if (absensi.isEmpty) {
    print('Belum ada absensi.');
    return;
  }
  final nomor = bacaInt('Nomor pertemuan', min: 1, max: absensi.length);
  final data = absensi[nomor]!;
  print('Pertemuan $nomor:');
  for (final mhs in daftarMahasiswa) {
    final status = data[mhs['nim']];
    print('${mhs['nim']} | ${mhs['nama']} | ${status?.name ?? '-'}');
  }
}

// ============================================================
// Fitur pilihan (pilih minimal 3, lihat README.md)
// ============================================================

/// Menu 4 [Mudah]: menambah mahasiswa baru.
void tambahMahasiswa() {
  print('=== Tambah Mahasiswa ===');
  String nim = bacaTeks('NIM: '); 

  var mhsEksis = cariByNim(nim);
  if (mhsEksis != null) {
    print('Tolak karena NIM sudah terdaftar.');
    return;
  }

  String nama = bacaTeks('Nama: ');

  daftarMahasiswa.add({
    'nim': nim,
    'nama': nama,
  });

  print('Mahasiswa $nama berhasil ditambahkan.');
}

  

/// Menu 5 [Mudah]: mencari mahasiswa berdasarkan sebagian nama.
void cariMahasiswa() {
  print("\n=== Cari Mahasiswa ===");
  stdout.write("Nama: ");
  String keyword = (stdin.readLineSync() ?? '').toLowerCase();

  bool ditemukan = false;
  
  for (final mhs in daftarMahasiswa) {
    String nama = mhs['nama'] ?? '';
    String nim = mhs['nim'] ?? '';
    
    if (nama.toLowerCase().contains(keyword)) {
      print("$nim | $nama");
      ditemukan = true;
    }
  }

  if (!ditemukan) {
    print("Mahasiswa tidak ditemukan.");
  }
}
  

/// Menu 6 [Sedang]: mengubah status absensi seorang mahasiswa.
void ubahStatus() {
 print('\n=== Ubah Status Absensi ===');
  final nomorPertemuan = bacaInt('Nomor pertemuan');

  if (!absensi.containsKey(nomorPertemuan)) {
    print('Error: Pertemuan $nomorPertemuan belum dicatat.');
    return;
  }

  stdout.write('NIM: ');
  final nim = stdin.readLineSync() ?? '';
  final mhs = cariByNim(nim);
  if (mhs == null) {
    print('Error: NIM mahasiswa tidak ditemukan.');
    return;
  }

  final statusBaru = bacaStatus('Status baru');
  absensi[nomorPertemuan]?[nim] = statusBaru;
  final namaMhs = mhs['nama'];
  final namaStatus = statusBaru.name.toLowerCase(); // Mengambil nama enum (hadir/izin/sakit/alpa)
  print('Status $namaMhs pada pertemuan $nomorPertemuan diubah menjadi $namaStatus.');
}
  
 

/// Menu 7 [Sedang]: menampilkan jumlah setiap status per mahasiswa.
void tampilkanRekap() {
  // TODO: untuk setiap mahasiswa, hitung berapa kali hadir, izin, sakit, dan alpa
  // dari semua pertemuan.
  print('Fitur belum tersedia.');
}

/// Menu 8 [Sulit]: menampilkan persentase kehadiran setiap mahasiswa.
void tampilkanPersentase() {
  // TODO: persentase = jumlah hadir / jumlah pertemuan x 100.
  // Tampilkan 1 angka di belakang koma.
  print('Fitur belum tersedia.');
}

/// Menu 9 [Sulit]: menampilkan mahasiswa dengan kehadiran di bawah batas.
void tampilkanDiBawahBatas() {
  // TODO: tampilkan mahasiswa yang persentase kehadirannya < batasKehadiran
  // (lihat data.dart) beserta persentasenya.
  print('Fitur belum tersedia.');
}
