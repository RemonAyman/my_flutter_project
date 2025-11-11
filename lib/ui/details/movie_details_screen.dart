import 'package:flutter/material.dart';
import 'package:my_project/data/favorites_view_model.dart';
import 'package:my_project/data/remote/movie_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  final FavoritesViewModel favoritesViewModel;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
    required this.favoritesViewModel,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  bool isLoading = true;
  bool isFavorite = false;
  Map<String, dynamic>? movie;
  String? trailerKey;
  List<dynamic> castList = [];

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  Future<void> fetchMovieDetails() async {
    try {
      final api = MovieApiService();
      final details = await api.getMovieDetails(widget.movieId);
      final videos = await api.getMovieVideos(widget.movieId);
      final credits = await api.getMovieCredits(widget.movieId);

      setState(() {
        movie = details;
        trailerKey = (videos['results'] as List)
            .firstWhere(
              (v) => v['site'] == "YouTube" && v['type'] == "Trailer",
              orElse: () => null,
            )?['key'];
        castList = credits['cast'];
        isFavorite = widget.favoritesViewModel.isFavorite(movie!);
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B1B2F),
        body: const Center(
            child: CircularProgressIndicator(color: Color(0xFF9B5DE5))),
      );
    }

    if (movie == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF1B1B2F),
        body: const Center(
            child: Text("Error loading movie",
                style: TextStyle(color: Colors.white))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24)),
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://image.tmdb.org/t/p/w500${movie!['poster_path']}"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 380,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24)),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF2A1B3D)]),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(Icons.bookmark_border, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie!['title'],
                      style: const TextStyle(
                          color: Colors.white, fontSize: 26)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text("⭐ ${movie!['vote_average']}",
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      Text(movie!['release_date'] ?? "",
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                      Text((movie!['original_language'] ?? "N/A").toUpperCase(),
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(movie!['overview'] ?? "No description available.",
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15, height: 1.4)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            if (trailerKey != null) {
                              final url = Uri.parse(
                                  "https://www.youtube.com/watch?v=$trailerKey");
                              if (await canLaunchUrl(url)) {
                                await launchUrl(
                                  url,
                                  mode: LaunchMode.externalApplication,
                                );
                              }
                            }
                          },
                          icon: const Icon(Icons.play_arrow, color: Colors.white),
                          label: const Text("Play Trailer",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9B5DE5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                              if (isFavorite) {
                                widget.favoritesViewModel.addToFavorites(movie!);
                              } else {
                                widget.favoritesViewModel
                                    .removeFromFavorites(movie!);
                              }
                            });
                          },
                          icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? const Color(0xFFFF5C8D)
                                  : Colors.white),
                          label: Text(isFavorite ? "Added" : "Favorite",
                              style: const TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: isFavorite
                                  ? const Color(0xFF9B5DE5)
                                  : const Color(0xFF2A1B3D),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Cast",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: castList.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final actor = castList[index];
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: actor['profile_path'] != null
                                  ? NetworkImage(
                                      "https://image.tmdb.org/t/p/w200${actor['profile_path']}")
                                  : null,
                              backgroundColor: actor['profile_path'] == null
                                  ? const Color(0xFF4A3A64)
                                  : null,
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 70,
                              child: Text(actor['name'] ?? "",
                                  style: const TextStyle(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            )
                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
