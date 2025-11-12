import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/search/search_screen.dart';
import 'ui/details/movie_details_screen.dart';
import 'data/favorites_view.dart';
import 'data/favorites_view_model.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SearchScreenWrapper(),
      },
      onGenerateRoute: (settings) {
        // صفحة التفاصيل
        if (settings.name != null && settings.name!.startsWith('/details/')) {
          final idStr = settings.name!.replaceFirst('/details/', '');
          final movieId = int.tryParse(idStr) ?? 0;
          return MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(
              movieId: movieId,
              favoritesViewModel: Provider.of<FavoritesViewModel>(context, listen: false),
            ),
          );
        }
        return null;
      },
    );
  }
}

// Wrapper for the SearchScreen
class SearchScreenWrapper extends StatelessWidget {
  const SearchScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchScreen(
        onMovieTap: (movieId) {
          // Navigate to Movie Details
          Navigator.of(context).pushNamed('/details/$movieId');
        },
      ),
    );
  }
}
