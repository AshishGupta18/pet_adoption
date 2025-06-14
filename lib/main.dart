import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/themes/app_theme.dart';
import 'presentation/routes/app_routes.dart';
import 'presentation/blocs/pet_cubit/pet_cubit.dart';
import 'data/datasources/mock_pet_data.dart';
import 'data/repositories/pet_repository_impl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for Flutter
  await Hive.initFlutter();

  // Open a box named 'pet_state' for storing adoption/favorites data
  await Hive.openBox('pet_state');

  runApp(const PetAdoptionApp());
}

class PetAdoptionApp extends StatelessWidget {
  const PetAdoptionApp({super.key});

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
      ],
      child: MaterialApp(
        title: 'Pet Adoption',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.generate,
      ),
    );
  }
}
