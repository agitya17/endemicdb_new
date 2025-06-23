// screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/endemik.dart';
import '../utils/database_helper.dart';
import 'details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Endemik> birds = [];
  bool isLoading = true;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await fetchDataFromApi(); // Ambil dari API
      final storedBirds = await dbHelper.getAll(); // Ambil dari DB
      setState(() {
        birds = storedBirds;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchDataFromApi() async {
    final url = Uri.parse("https://api.ebird.org/v2/data/obs/region/recent/PH");
    final response = await http.get(
      url,
      headers: {"X-eBirdApiToken": "YOUR_API_KEY_HERE"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      for (var item in jsonData) {
        final bird = Endemik.fromJson(item);
        final existing = await dbHelper.getById(bird.id);
        if (existing == null) {
          await dbHelper.insert(bird);
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void toggleFavorite(Endemik bird) async {
    String newFav = bird.isFavorit == "true" ? "false" : "true";
    await dbHelper.setFavorit(bird.id, newFav);

    setState(() {
      bird.isFavorit = newFav;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("EndemikDB")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : birds.isEmpty
          ? Center(child: Text("Tidak ada data burung"))
          : ListView.builder(
        itemCount: birds.length,
        itemBuilder: (context, index) {
          Endemik bird = birds[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Image.network(
                bird.foto,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
              title: Text(bird.nama),
              subtitle: Text(bird.namaLatin),
              trailing: IconButton(
                icon: Icon(
                  bird.isFavorit == "true"
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