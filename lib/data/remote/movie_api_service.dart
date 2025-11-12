import 'dart:convert';
import 'package:http/http.dart' as http;
import 'movie_api_model.dart';

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
}
