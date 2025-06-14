import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Find Your Pet 🐾'),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border),
          tooltip: 'Favorites',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.favorites);
          },
        ),
        IconButton(
          icon: const Icon(Icons.history),
          tooltip: 'History',
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.history);
          },
        ),
      ],
    );
  }
}