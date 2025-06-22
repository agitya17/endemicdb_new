import 'package:flutter/material.dart';
import 'package:endemicdb_new/models/bird_model.dart';

class FavoriteProvider with ChangeNotifier {
  List<Bird> _favorites = [];

  List<Bird> get favorites => _favorites;

  void addFavorite(Bird bird) {
    _favorites.add(bird);
    notifyListeners();
  }

  void removeFavorite(Bird bird) {
    _favorites.remove(bird);
    notifyListeners();
  }

  bool isFavorite(Bird bird) {
    return _favorites.contains(bird);
  }
}