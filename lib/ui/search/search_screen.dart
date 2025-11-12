import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../data/remote/movie_api_service.dart';
import '../../data/remote/movie_api_model.dart';
import '../../data/favorites_view_model.dart';
import '../details/movie_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final Function(int) onMovieTap;

  const SearchScreen({super.key, required this.onMovieTap});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> searchResults = [];
  List<String> recentSearches = ["Action", "Comedy", "Drama", "Sci-Fi"];
  bool isLoading = false;

  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  static const String _apiKey = '2f13b4fd29b3109c92837f91bdc86c24';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() => isLoading = true);

    try {
      final response = await Dio().get(
        'https://api.themoviedb.org/3/search/movie',
        queryParameters: {
          'api_key': _apiKey,
          'query': query,
        },
      );

      setState(() {
        searchResults = response.data['results'];
        if (!recentSearches.contains(query)) recentSearches.insert(0, query);
      });
    } catch (e) {
      print("Error fetching movies: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> startVoiceSearch() async {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == "done" || status == "notListening") {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        print("Speech error: $error");
        setState(() => _isListening = false);
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        if (val.hasConfidenceRating && val.confidence > 0) {
          _controller.text = val.recognizedWords;
          searchMovies(val.recognizedWords);
          _speech.stop();
          setState(() => _isListening = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        title: const Text("Search"),
        backgroundColor: const Color(0xFF2A1B3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search for movies, shows, and more",
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF2A1B3D),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic_off : Icons.mic,
                          color: Colors.white,
                        ),
                        onPressed: startVoiceSearch,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => searchMovies(_controller.text),
                  child: const Icon(Icons.search),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B5DE5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const Center(
                  child: CircularProgressIndicator(color: Color(0xFF9B5DE5)))
            else if (searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MovieDetailsScreen(
                              movieId: movie['id'],
                              favoritesViewModel: Provider.of<FavoritesViewModel>(context, listen: false),
                            ),
                          ),
                        );
                        widget.onMovieTap(movie['id']);
                      },
                      leading: movie['poster_path'] != null
                          ? Image.network(
                              "https://image.tmdb.org/t/p/w500${movie['poster_path']}",
                              width: 80,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 80,
                              color: Colors.grey,
                              child: const Center(
                                child: Icon(Icons.movie, color: Colors.white),
                              ),
                            ),
                      title: Text(
                        movie['title'] ?? 'Unknown',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        movie['release_date'] ?? '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
              )
            else if (_controller.text.isNotEmpty)
              const Center(
                child: Text(
                  "No results found",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: recentSearches
                    .map(
                      (item) => GestureDetector(
                        onTap: () => searchMovies(item),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A1B3D),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(item, style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                    .toList(),
              )
          ],
        ),
      ),
    );
  }
}
