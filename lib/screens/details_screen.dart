// screens/details_screen.dart
import 'package:flutter/material.dart';
import 'package:endemicdb_new/models/bird_model.dart';

class DetailsScreen extends StatelessWidget {
  final Bird bird;

  const DetailsScreen({Key? key, required this.bird}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(bird.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(bird.imageUrl, fit: BoxFit.cover, height: 200),
            SizedBox(height: 16),
            Text('Scientific Name: ${bird.scientificName}'),
            SizedBox(height: 8),
            Text('Description: ${bird.description}'),
            SizedBox(height: 8),
            Text('Habitat: ${bird.habitat}'),
            SizedBox(height: 8),
            Text('Conservation Status: ${bird.conservationStatus}'),
          ],
        ),
      ),
    );
  }
}