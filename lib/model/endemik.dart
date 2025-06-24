// lib/model/endemik.dart

class Endemik {
  final String? id; // Mengubah tipe data ID menjadi String agar sesuai dengan TEXT PRIMARY KEY di DB
  final String nama;
  final String nama_latin;
  final String deskripsi;
  final String asal;
  final String foto;
  final String status;
  bool is_favorit; // Tetap menggunakan bool di model

  Endemik({
    this.id,
    required this.nama,
    required this.nama_latin,
    required this.deskripsi,
    required this.asal,
    required this.foto,
    required this.status,
    this.is_favorit = false, // Default ke false
  });

  // Constructor dari JSON (saat mengambil dari API)
  factory Endemik.fromJson(Map<String, dynamic> json) {
    return Endemik(
      id: json['id']?.toString(), // Pastikan ID diubah menjadi String jika dari JSON bukan String
      nama: json['nama'] ?? '',
      nama_latin: json['nama_latin'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      asal: json['asal'] ?? '',
      foto: json['foto'] ?? '',
      status: json['status'] ?? '',
      // Dari API, kita asumsikan is_favorit tidak ada atau default false.
      // Jika JSON punya 'is_favorit' dalam bentuk string "true"/"false", bisa di-parse:
      // is_favorit: json['is_favorit'] == 'true',
      is_favorit: false, // Default ke false saat pertama kali di-load dari API
    );
  }

  // Konversi dari Map (dari database)
  factory Endemik.fromMap(Map<String, dynamic> map) {
    return Endemik(
      id: map['id']?.toString(), // Pastikan ID dari DB diubah menjadi String
      nama: map['nama'] ?? '',
      nama_latin: map['nama_latin'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      asal: map['asal'] ?? '',
      foto: map['foto'] ?? '',
      status: map['status'] ?? '',
      // Konversi dari String ("true"/"false") di DB menjadi bool
      is_favorit: map['is_favorit'] == 'true',
    );
  }

  // Konversi ke Map (untuk database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nama_latin': nama_latin,
      'deskripsi': deskripsi,
      'asal': asal,
      'foto': foto,
      'status': status,
      // Konversi bool ke String ("true"/"false") untuk disimpan di DB
      'is_favorit': is_favorit ? 'true' : 'false',
    };
  }
}