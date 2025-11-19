import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieApiService {
  final String _baseUrl = "https://api.themoviedb.org/3";
  final String _apiKey = "2f13b4fd29b3109c92837f91bdc86c24"; // حط هنا الـ API key بتاعك

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final url = Uri.parse("$_baseUrl/movie/$movieId?api_key=$_apiKey&language=en-US");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load movie details");
    }
  }

  Future<Map<String, dynamic>> getMovieVideos(int movieId) async {
    final url = Uri.parse("$_baseUrl/movie/$movieId/videos?api_key=$_apiKey&language=en-US");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load movie videos");
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    final url = Uri.parse("$_baseUrl/movie/$movieId/credits?api_key=$_apiKey&language=en-US");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load movie credits");
    }
  }

  // Get Popular Movies
  Future<List<dynamic>> getPopularMovies({int page = 1}) async {
    final url = Uri.parse("$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception("Failed to load popular movies");
    }
  }

  // Get Top Rated Movies
  Future<List<dynamic>> getTopRatedMovies({int page = 1}) async {
    final url = Uri.parse("$_baseUrl/movie/top_rated?api_key=$_apiKey&language=en-US&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception("Failed to load top rated movies");
    }
  }

  // Get Upcoming Movies
  Future<List<dynamic>> getUpcomingMovies({int page = 1}) async {
    final url = Uri.parse("$_baseUrl/movie/upcoming?api_key=$_apiKey&language=en-US&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception("Failed to load upcoming movies");
    }
  }

  // Get Now Playing Movies
  Future<List<dynamic>> getNowPlayingMovies({int page = 1}) async {
    final url = Uri.parse("$_baseUrl/movie/now_playing?api_key=$_apiKey&language=en-US&page=$page");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception("Failed to load now playing movies");
    }
  }
}
