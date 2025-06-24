// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:endemicdb_new/model/endemik.dart';
import 'package:endemicdb_new/services/api_service.dart'; // Menggunakan EndemikService
import 'package:endemicdb_new/providers/favorite_provider.dart'; // Menggunakan FavoriteProvider
// utils/database_helper.dart sudah diimport oleh api_service.dart
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mengganti nama variabel untuk konsistensi
  List<Endemik> endemikList = [];
  bool isLoading = true;
  final EndemikService _endemikService = EndemikService(); // Inisialisasi EndemikService

  @override
  void initState() {
    super.initState();
    _loadEndemikData(); // Memuat data saat inisialisasi
  }

  // Metode untuk memuat data endemik
  Future<void> _loadEndemikData() async {
    setState(() {
      isLoading = true; // Set loading true saat memulai pemuatan
    });
    try {
      // Mengambil data dari EndemikService, yang sudah menangani API dan DB
      final List<Endemik> data = await _endemikService.getData();
      setState(() {
        endemikList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error memuat data endemik: $e");
      // Opsional: Tampilkan pesan error kepada pengguna
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendapatkan instance FavoriteProvider
    // dan bereaksi terhadap perubahannya tanpa perlu setState di dalam item list.
    return Scaffold(
      appBar: AppBar(
        title: const Text("EndemikDB"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEndemikData, // Tambahkan tombol refresh
          ),
          // Opsional: Tombol untuk melihat daftar favorit saja
          // IconButton(
          //   icon: const Icon(Icons.favorite),
          //   onPressed: () {
          //     // Navigasi ke halaman favorit atau filter daftar
          //   },
          // ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : endemikList.isEmpty
          ? const Center(child: Text("Tidak ada data endemik ditemukan."))
          : ListView.builder(
        itemCount: endemikList.length,
        itemBuilder: (context, index) {
          Endemik endemik = endemikList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(8),
              leading: ClipRRect( // Untuk membuat gambar memiliki border radius
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  endemik.foto,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              title: Text(
                endemik.nama,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(endemik.nama_latin),
              trailing: Consumer<FavoriteProvider>( // Consumer di sini agar hanya tombol favorit yang rebuild
                builder: (context, favoriteProvider, child) {
                  final bool isCurrentlyFavorite = favoriteProvider.isFavorite(endemik);
                  return IconButton(
                    icon: Icon(
                      isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isCurrentlyFavorite ? Colors.red : Colors.grey, // Warna disesuaikan
                    ),
                    onPressed: () async {
                      // Toggle status favorit di FavoriteProvider
                      if (isCurrentlyFavorite) {
                        favoriteProvider.removeFavorite(endemik);
                        // Update status di database juga
                        await _endemikService.setFavorit(endemik.id!, "false");
                      } else {
                        favoriteProvider.addFavorite(endemik);
                        // Update status di database juga
                        await _endemikService.setFavorit(endemik.id!, "true");
                      }

                      setState(() {
                        endemik.is_favorit = !endemik.is_favorit;
                      });
                    },
                  );
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(endemik: endemik), // Mengganti bird menjadi endemik
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}