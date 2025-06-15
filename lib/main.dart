import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/themes/app_theme.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/blocs/pet_cubit/pet_cubit.dart';
import 'presentation/blocs/theme_cubit/theme_cubit.dart';
import 'data/datasources/mock_pet_data.dart';
import 'data/repositories/pet_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(PetAdoptionApp(prefs: prefs));
}

class PetAdoptionApp extends StatelessWidget {
  final SharedPreferences prefs;

  const PetAdoptionApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) =>
                  PetCubit(PetRepositoryImpl(dataSource: MockPetDataSource()))
                    ..loadPets(),
        ),
        BlocProvider(create: (_) => ThemeCubit(prefs)),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Pet Adoption',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRoutes.generate,
          );
        },
      ),
    );
  }
}
