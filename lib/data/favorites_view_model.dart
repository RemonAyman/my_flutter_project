// lib/data/favorites_view_model.dart
import 'package:flutter/material.dart';
import 'movie_api_model.dart';

class FavoritesViewModel extends ChangeNotifier {
  final List<MovieApiModel> _favorites = [];

  List<MovieApiModel> get favorites => List.unmodifiable(_favorites);

  // Stream-like behavior using ValueNotifier
  final ValueNotifier<List<MovieApiModel>> favoritesFlow = ValueNotifier([]);

  void addToFavorites(MovieApiModel movie) {
    if (!_favorites.any((m) => m.id == movie.id)) {
      _favorites.add(movie);
      favoritesFlow.value = List.unmodifiable(_favorites);
      notifyListeners();
    }
  }

  void removeFromFavorites(MovieApiModel movie) {
    _favorites.removeWhere((m) => m.id == movie.id);
    favoritesFlow.value = List.unmodifiable(_favorites);
    notifyListeners();
  }

  bool isFavorite(MovieApiModel movie) {
    return _favorites.any((m) => m.id == movie.id);
  }
}
