import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/home_view_model.dart';
import '../../data/favorites_view_model.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<HomeViewModel>().loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A1B3D),
        title: const Text('Movies', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(),
              );
            },
          ),
        ],
      ),
      body: Consumer<HomeViewModel>(
        builder: (context, homeVM, _) {
          if (homeVM.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            );
          }

          if (homeVM.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    homeVM.errorMessage!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => homeVM.refreshMovies(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => homeVM.refreshMovies(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Consumer<FavoritesViewModel>(
                builder: (context, favoritesVM, _) {
                  // Convert MovieApiModel to dynamic format
                  final favoritesAsMap = favoritesVM.favorites.map((movie) {
                    return {
                      'id': movie.id,
                      'title': movie.title,
                      'poster_path': movie.posterPath,
                      'vote_average': movie.voteAverage,
                    };
                  }).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Favorites Section
                      if (favoritesAsMap.isNotEmpty)
                        _buildMovieSection('My Favorites', favoritesAsMap, context),
                      
                      // Now Playing Section
                      if (homeVM.nowPlayingMovies.isNotEmpty)
                        _buildMovieSection('Now Playing', homeVM.nowPlayingMovies, context),
                      
                      // Popular Section
                      if (homeVM.popularMovies.isNotEmpty)
                        _buildMovieSection('Popular', homeVM.popularMovies, context),
                      
                      // Top Rated Section
                      if (homeVM.topRatedMovies.isNotEmpty)
                        _buildMovieSection('Top Rated', homeVM.topRatedMovies, context),
                      
                      // Upcoming Section
                      if (homeVM.upcomingMovies.isNotEmpty)
                        _buildMovieSection('Upcoming', homeVM.upcomingMovies, context),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.of(context).pushNamed('/profile');
        },
        child: const Icon(Icons.person, color: Colors.white),
      ),
    );
  }

  Widget _buildMovieSection(String title, List<dynamic> movies, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: movies.length > 10 ? 10 : movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              final movieId = movie['id'] ?? 0;
              final posterPath = movie['poster_path'] ?? '';
              final title = movie['title'] ?? 'Unknown';
              final rating = movie['vote_average'] ?? 0.0;

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/details/$movieId');
                },
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 140,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF2A1B3D),
                        ),
                        child: posterPath.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500$posterPath',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.movie,
                                      color: Colors.white54,
                                      size: 50,
                                    );
                                  },
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.movie,
                                  color: Colors.white54,
                                  size: 50,
                                ),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
