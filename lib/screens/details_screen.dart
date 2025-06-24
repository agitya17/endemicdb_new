// screens/details_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import paket provider
import 'package:endemicdb_new/model/endemik.dart';
import 'package:endemicdb_new/providers/favorite_provider.dart'; // Import FavoriteProvider

class DetailsScreen extends StatelessWidget {
  final Endemik endemik;

  const DetailsScreen({Key? key, required this.endemik}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Menggunakan Consumer untuk mendengarkan perubahan pada FavoriteProvider
    return Scaffold(
      appBar: AppBar(
        title: Text(endemik.nama),
        actions: [
          // Widget tombol favorit di AppBar
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              final bool isFavorite = favoriteProvider.isFavorite(endemik);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : null, // Warna merah jika favorit
                ),
                onPressed: () {
                  if (isFavorite) {
                    favoriteProvider.removeFavorite(endemik);
                    // Opsional: Tampilkan SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${endemik.nama} dihapus dari favorit!'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  } else {
                    favoriteProvider.addFavorite(endemik);
                    // Opsional: Tampilkan SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${endemik.nama} ditambahkan ke favorit!'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar dari properti 'foto'
            Image.network(
              endemik.foto,
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity, // Agar gambar mengisi lebar
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Nama Latin: ${endemik.nama_latin}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Asal: ${endemik.asal}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            // Menggunakan Expanded untuk deskripsi agar bisa scroll jika panjang
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi:',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      endemik.deskripsi,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status Konservasi: ${endemik.status}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}