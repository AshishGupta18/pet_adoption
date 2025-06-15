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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption/presentation/blocs/pet_cubit/pet_cubit.dart';
import 'package:pet_adoption/presentation/blocs/theme_cubit/theme_cubit.dart';
import 'package:pet_adoption/data/repositories/petfinder_repository_impl.dart';
import 'package:pet_adoption/data/services/petfinder_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([PetfinderService])
import 'widget_test.mocks.dart';

void main() {
  late MockPetfinderService mockService;

  setUp(() {
    mockService = MockPetfinderService();
  });

  testWidgets('Pet list displays correctly', (WidgetTester tester) async {
    // Create a mock SharedPreferences instance
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create:
                (_) =>
                    PetCubit(PetfinderRepositoryImpl(mockService))..loadPets(),
          ),
          BlocProvider(create: (_) => ThemeCubit(prefs)),
        ],
        child: PetAdoptionApp(prefs: prefs),
      ),
    );

    // Wait for the initial frame to complete
    await tester.pumpAndSettle();

    // Verify that the app bar is present
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Pet Adoption'), findsOneWidget);

    // Verify that the search bar is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the grid view is present
    expect(find.byType(GridView), findsOneWidget);
  });
}
