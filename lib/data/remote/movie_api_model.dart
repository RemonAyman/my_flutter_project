class MovieApiModel {
  final int id;
  final String title;
  final String overview;
  final String? poster_path;
  final String? release_date;
  final double? vote_average;
  final List<int> genre_ids;
  final String original_language;

  MovieApiModel({
    required this.id,
    required this.title,
    required this.overview,
    this.poster_path,
    this.release_date,
    this.vote_average,
    required this.genre_ids,
    required this.original_language,
  });

  factory MovieApiModel.fromJson(Map<String, dynamic> json) {
    return MovieApiModel(
      id: json['id'],
      title: json['title'] ?? "Unknown",
      overview: json['overview'] ?? "",
      poster_path: json['poster_path'],
      release_date: json['release_date'],
      vote_average: (json['vote_average'] != null)
          ? (json['vote_average'] as num).toDouble()
          : null,
      genre_ids: (json['genre_ids'] != null)
          ? List<int>.from(json['genre_ids'])
          : [],
      original_language: json['original_language'] ?? "en",
    );
  }

  // 🔹 Add camelCase getters
  String? get posterPath => poster_path;
  double? get voteAverage => vote_average;
  String? get releaseDate => release_date;
  String get originalLanguage => original_language;
}
