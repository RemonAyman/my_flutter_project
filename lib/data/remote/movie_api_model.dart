// lib/data/remote/movie_api_model.dart
class MovieApiModel {
  final int id;
  final String? title;
  final String? overview;
  final String? poster_path;
  final String? release_date;
  final double? vote_average;
  final List<int> genre_ids;
  final String original_language;

  MovieApiModel({
    required this.id,
    this.title,
    this.overview,
    this.poster_path,
    this.release_date,
    this.vote_average,
    required this.genre_ids,
    required this.original_language,
  });
}
