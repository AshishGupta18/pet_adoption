// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pet_adoption/main.dart';

void main() {
  testWidgets('Pet list displays correctly', (WidgetTester tester) async {
    // Create a mock SharedPreferences instance
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(PetAdoptionApp(prefs: prefs));

    // Wait for the initial frame to complete
    await tester.pumpAndSettle();

    // Verify that the pet list is displayed
    expect(find.byType(ListView), findsOneWidget);

    // Verify that pet items are displayed
    expect(find.byType(Card), findsWidgets);

    // Verify that pet details are shown
    expect(find.byType(Text), findsWidgets);

    // Verify that the app bar is present
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Pet Adoption'), findsOneWidget);
  });
}
