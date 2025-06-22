// lib/services/api_service.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/bird_model.dart';

class ApiService {
  static const String apiKey = "dpjkq9mjfreh"; // Ganti dengan API Key eBird
  static const String baseUrl = "https://api.ebird.org/v2/ref/taxonomy/ebird?fmt=json";

  Future<List<Bird>> fetchBirds(String regionCode) async {
    final url = "$baseUrl/data/obs/region/recent/$regionCode";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-eBirdApiToken': apiKey,
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Bird.fromJson(json)).toList();
    } else {
      throw Exception("Gagal memuat data");
    }
  }

  Future<Bird> getBirdDetails(String speciesCode) async {
    final url = "$baseUrl/species/info/$speciesCode";
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'X-eBirdApiToken': apiKey,
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      return Bird.fromJson(jsonData);
    } else {
      throw Exception("Gagal memuat data");
    }
  }
}