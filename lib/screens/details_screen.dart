import 'package:flutter/material.dart';
import 'package:endemicdb_new/models/bird_model.dart';
import 'package:endemicdb_new/providers/favorite_provider.dart';
import 'package:provider/provider.dart'; // ✅ Tambahkan ini

class DetailsScreen extends StatelessWidget {
  final Bird bird;

  const DetailsScreen({Key? key, required this.bird}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(bird.name)),
      body: Column(
        children: [
          Image.network(bird.imageUrl),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(bird.description),
          ),
        ],
      ),
    );
  }
}