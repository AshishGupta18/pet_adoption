import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/pet_cubit/pet_cubit.dart';
import '../../../presentation/pages/home/widgets/pet_tile.dart';
import '../../../presentation/pages/details/detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final petCubit = context.watch<PetCubit>();
    final favorites = petCubit.getFavoritedPets();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Pets')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (_, index) {
                final pet = favorites[index];
                return PetTile(
                  pet: pet,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsPage(pet: pet),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}