import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ui/home/home_screen.dart';
import 'ui/details/movie_details_screen.dart';
import 'ui/profile/profile_screen.dart';
import 'data/favorites_view_model.dart';
import 'data/profile_view_model.dart';
import 'data/home_view_model.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
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
        '/': (context) => const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        // Movie Details page
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
        // Profile page
        if (settings.name == '/profile') {
          return MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          );
        }
        return null;
      },
    );
  }
}

