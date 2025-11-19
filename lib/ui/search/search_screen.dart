import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SearchScreen extends SearchDelegate {
  static const String _apiKey = '2f13b4fd29b3109c92837f91bdc86c24';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              'Search for movies',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return FutureBuilder<List<dynamic>>(
      future: _searchMovies(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final results = snapshot.data ?? [];

        if (results.isEmpty) {
          return Center(
            child: Text(
              'No results found for "$query"',
              style: const TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final movie = results[index];
            final movieId = movie['id'] ?? 0;
            final title = movie['title'] ?? 'Unknown';
            final posterPath = movie['poster_path'] ?? '';
            final overview = movie['overview'] ?? '';

            return ListTile(
              leading: posterPath.isNotEmpty
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w500$posterPath',
                      width: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.movie),
              title: Text(title),
              subtitle: Text(
                overview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                close(context, movieId);
                Navigator.of(context).pushNamed('/details/$movieId');
              },
            );
          },
        );
      },
    );
  }

  Future<List<dynamic>> _searchMovies(String query) async {
    try {
      final response = await Dio().get(
        'https://api.themoviedb.org/3/search/movie',
        queryParameters: {
          'api_key': _apiKey,
          'query': query,
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return data['results'] ?? [];
      }
      return [];
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }
}
