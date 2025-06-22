// home_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:endemicdb_new/models/bird_model.dart';
import 'package:endemicdb_new/utils/database_helper.dart';
import 'package:endemicdb_new/screens/details_screen.dart';
import 'package:photo_view/photo_view.dart'; // Untuk fullscreen image

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Bird> birds = [];
  bool isLoading = true;

  Future<void> fetchDataFromApi() async {
    final url = Uri.parse("https://api.ebird.org/v2/data/obs/region/recent/PH");
    final response = await http.get(
      url,
      headers: {
        "X-eBirdApiToken": "dpjkq9mjfreh" // Ganti dengan API Key kamu
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<Bird> fetchedBirds =
      jsonData.map((json) => Bird.fromJson(json)).toList();

      setState(() {
        birds = fetchedBirds;
        isLoading = false;
      });
    } else {
      debugPrint("Gagal mengambil data dari API");
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleFavorite(Bird bird) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.toggleFavorite(bird.id!);
    setState(() {
      bird.isFavorite = !bird.isFavorite;
    });
  }

  void showFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromApi(); // Ambil data dari API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EndemicDB')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : birds.isEmpty
          ? Center(
        child: Text("Tidak ada data burung"),
      )
          : ListView.builder(
        itemCount: birds.length,
        itemBuilder: (context, index) {
          Bird bird = birds[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: GestureDetector(
                onTap: () => showFullScreenImage(context, bird.imageUrl),
                child: Image.network(
                  bird.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(bird.name),
              subtitle: Text(bird.scientificName),
              trailing: IconButton(
                icon: Icon(
                  bird.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  toggleFavorite(bird);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(bird: bird),
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