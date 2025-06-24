import 'package:flutter/material.dart';
import 'package:endemicdb_new/model/endemik.dart';

class FavoriteProvider with ChangeNotifier {
  List<Endemik> _favorites = []; // Mengganti Bird menjadi Endemik

  List<Endemik> get favorites => _favorites; // Mengganti Bird menjadi Endemik

  void addFavorite(Endemik endemik) {
    if (!_favorites.any((favEndemik) => favEndemik.id == endemik.id)) {
      _favorites.add(endemik);
      notifyListeners();
    }
  }

  void removeFavorite(Endemik endemik) { // Mengganti Bird menjadi Endemik
    _favorites.removeWhere((favEndemik) => favEndemik.id == endemik.id);
    notifyListeners();
  }

  bool isFavorite(Endemik endemik) { // Mengganti Bird menjadi Endemik
    // Mengecek apakah endemik dengan ID yang sama sudah ada di daftar favorit
    return _favorites.any((favEndemik) => favEndemik.id == endemik.id);
  }
}