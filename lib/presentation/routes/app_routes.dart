import 'package:flutter/material.dart';
import 'package:pet_adoption/domain/entities/pet_entity.dart';
import 'package:pet_adoption/presentation/pages/details/detail_page.dart';
import '../pages/home/home_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String history = '/history';
  static const String favorites = '/favorites';

 static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case details:
        final pet = settings.arguments as PetEntity;
        return MaterialPageRoute(
            builder: (_) => DetailsPage(pet: pet));
      default:
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                  body: Center(child: Text("Route not found")),
                ));
    }
  }
}