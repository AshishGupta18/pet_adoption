import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/pet_cubit/pet_cubit.dart';
import '../../../presentation/pages/home/widgets/error_widget.dart' as custom;
import 'widgets/pet_list_tile.dart';
import 'widgets/search_bar.dart';
import '../../../domain/entities/pet_entity.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<PetEntity> allPets;
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pet Adoption")),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<PetCubit>().loadPets();
        },
        child: BlocBuilder<PetCubit, PetState>(
          builder: (context, state) {
            if (state is PetLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PetError) {
              return custom.ErrorWidget(message: state.message);
            } else if (state is PetLoaded) {
              allPets = state.pets;
              final filteredPets = searchQuery.isEmpty
                  ? allPets
                  : allPets
                      .where((pet) =>
                          pet.name.toLowerCase().contains(searchQuery.toLowerCase()))
                      .toList();

              return Column(
                children: [
                  SearchBarWidget(
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: filteredPets.length,
                      itemBuilder: (context, index) {
                        return PetListTile(pet: filteredPets[index]);
                      },
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}