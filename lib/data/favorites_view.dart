import 'package:flutter/material.dart';
import 'favorites_view_model.dart';

class FavoritesScreen extends StatelessWidget {
  final FavoritesViewModel viewModel;

  const FavoritesScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final favorites = viewModel.favorites;

    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: Color(0xFF2A1B3D),
        title: const Text("Favorites"),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                "No Favorites Yet",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final movie = favorites[index];
                return FavoriteMovieCard(
                  movie: movie,
                  onDelete: () {
                    showDialog(
                      context: context,
                      builder: (context) => ConfirmDeleteDialog(
                        onConfirm: () {
                          viewModel.removeFromFavorites(movie);
                          Navigator.pop(context);
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailsScreen(movieId: movie.id, favoritesViewModel: viewModel),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class FavoriteMovieCard extends StatelessWidget {
  final dynamic movie;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const FavoriteMovieCard({
    super.key,
    required this.movie,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF2A1B3D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Image.network(
              "https://image.tmdb.org/t/p/w500${movie.poster_path}",
              width: 90,
              height: 130,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title ?? "Unknown Title",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "⭐ ${movie.vote_average ?? "N/A"} | ${movie.release_date ?? "Unknown"}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete, color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmDeleteDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmDeleteDialog({super.key, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text("Delete Movie?", style: TextStyle(color: Colors.white)),
      content: const Text("Are you sure you want to delete this movie?",
          style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF9B5DE5)),
          child: const Text("Yes", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
