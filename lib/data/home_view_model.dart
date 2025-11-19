import 'package:flutter/material.dart';
import 'remote/movie_api_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MovieApiService _movieApiService = MovieApiService();
  
  List<dynamic> popularMovies = [];
  List<dynamic> topRatedMovies = [];
  List<dynamic> upcomingMovies = [];
  List<dynamic> nowPlayingMovies = [];
  
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadMovies() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // Load all movie categories in parallel
      final results = await Future.wait([
        _movieApiService.getPopularMovies(),
        _movieApiService.getTopRatedMovies(),
        _movieApiService.getUpcomingMovies(),
        _movieApiService.getNowPlayingMovies(),
      ]);

      popularMovies = results[0];
      topRatedMovies = results[1];
      upcomingMovies = results[2];
      nowPlayingMovies = results[3];
      
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = 'Failed to load movies: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshMovies() async {
    await loadMovies();
  }
}
