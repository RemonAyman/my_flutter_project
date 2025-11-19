// ===== Movie Details Model =====
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

  // 🔹 CamelCase getters
  String? get posterPath => poster_path;
  double? get voteAverage => vote_average;
  String? get releaseDate => release_date;
  String get originalLanguage => original_language;
}

// ===== Movie Videos Model =====
class MovieVideosResponse {
  final List<MovieVideo> results;

  MovieVideosResponse({required this.results});

  factory MovieVideosResponse.fromJson(Map<String, dynamic> json) {
    return MovieVideosResponse(
      results: (json['results'] as List<dynamic>)
          .map((e) => MovieVideo.fromJson(e))
          .toList(),
    );
  }
}

class MovieVideo {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;

  MovieVideo({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
  });

  factory MovieVideo.fromJson(Map<String, dynamic> json) {
    return MovieVideo(
      id: json['id'],
      key: json['key'],
      name: json['name'],
      site: json['site'],
      type: json['type'],
    );
  }
}

// ===== Movie Credits Model =====
class MovieCreditsResponse {
  final List<CastMember> cast;

  MovieCreditsResponse({required this.cast});

  factory MovieCreditsResponse.fromJson(Map<String, dynamic> json) {
    return MovieCreditsResponse(
      cast: (json['cast'] as List<dynamic>)
          .map((e) => CastMember.fromJson(e))
          .toList(),
    );
  }
}

class CastMember {
  final int id;
  final String name;
  final String? profile_path;
  final String? character;

  CastMember({
    required this.id,
    required this.name,
    this.profile_path,
    this.character,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'],
      name: json['name'] ?? "Unknown",
      profile_path: json['profile_path'],
      character: json['character'],
    );
  }
}
