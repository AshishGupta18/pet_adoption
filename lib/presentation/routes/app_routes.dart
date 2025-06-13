import 'package:flutter/material.dart';
import '../pages/home/home_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String details = '/details';
  static const String history = '/history';
  static const String favorites = '/favorites';

  static final routes = <String, WidgetBuilder>{
    home: (_) => const HomePage(),
    // Details, History, Favorites will be added later
  };
}