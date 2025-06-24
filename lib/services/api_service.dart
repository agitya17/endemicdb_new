import 'package:dio/dio.dart';
import '../model/endemik.dart';
import '../helper/database_helper.dart';

/*
  service ini dibentuk karena prosesnya yang akan memblokir memory UI
  sehingga perlu dipisah untuk tiap proses "mengambil data"
  yang pastinya membutuhkan waktu lama
*/

class EndemikService {
  final Dio _dio = Dio();

  Future<bool> isDataAvailable() async {
    final dbHelper = DatabaseHelper();
    final int count = await dbHelper.count();
    return count > 0;
  }

  // Menambahkan metode untuk set favorit di database
  // Ini penting agar home_screen.dart bisa memanggilnya
  Future<int> setFavorit(String id, String isFavoritStatus) async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.setFavorit(id, isFavoritStatus);
  }

  Future<List<Endemik>> getData() async {
    final dbHelper = DatabaseHelper();

    try {
      // Cek apakah data sudah ada di database
      bool dataExists = await isDataAvailable();
      if (dataExists) {
        print("Data sudah ada di database, tidak perlu mengambil dari API.");
        final List<Endemik> oldData = await dbHelper.getAll();
        return oldData;
      }

      // jika belum, maka tarik dari API
      final response = await _dio.get('https://hendroprwk08.github.io/data_endemik/endemik.json');
      final List<dynamic> data = response.data;

      List<Endemik> loadedEndemik = []; // List untuk menyimpan objek Endemik yang sudah di-load

      for (var jsonItem in data) { // Ubah nama variabel 'json' menjadi 'jsonItem' untuk menghindari konflik nama
        // Gunakan Endemik.fromJson untuk membuat objek model
        // Ini akan secara otomatis mengatur is_favorit ke false seperti di definisi model
        Endemik model = Endemik.fromJson(jsonItem);

        // Sebelum insert, cek apakah sudah ada di database berdasarkan ID
        // (ini mungkin tidak diperlukan jika kita hanya insert jika DB kosong,
        // tapi baik untuk pencegahan duplikasi jika logic berubah)
        Endemik? existingEndemik = await dbHelper.getById(model.id!); // ID dijamin tidak null jika dari API
        if (existingEndemik == null) { // Hanya insert jika belum ada
          await dbHelper.insert(model);
        }
        loadedEndemik.add(model); // Tambahkan ke list yang akan dikembalikan
      }

      // Setelah semua data diproses dan disimpan, kembalikan data yang sudah dimuat.
      // Tidak perlu lagi data.map((json) => Endemik.fromJson(json)).toList();
      // karena kita sudah memprosesnya di loop.
      return loadedEndemik;

    } catch (e) {
      print("Error dalam getData di EndemikService: $e");
      return [];
    }
  }

  Future<List<Endemik>> getFavoritData() async {
    try {
      final db = await DatabaseHelper();
      final List<Endemik> data = await db.getFavoritAll();
      return data;
    } catch (e) {
      print("Error dalam getFavoritData di EndemikService: $e");
      return [];
    }
  }
}