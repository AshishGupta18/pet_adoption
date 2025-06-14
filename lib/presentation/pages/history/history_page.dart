import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/pet_cubit/pet_cubit.dart';
import '../home/widgets/pet_tile.dart';
import '../details/detail_page.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final adopted = context.watch<PetCubit>().getAdoptedPets();

    return Scaffold(
      appBar: AppBar(title: const Text('Adoption History')),
      body: adopted.isEmpty
          ? const Center(child: Text('No adoptions yet!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: adopted.length,
              itemBuilder: (_, index) {
                final pet = adopted[index];
                return PetTile(
                  pet: pet,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: pet,
                    );
                  },
                );
              },
            ),
    );
  }
}