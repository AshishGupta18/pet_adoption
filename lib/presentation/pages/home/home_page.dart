import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/pet_cubit/pet_cubit.dart';
import '../../../presentation/blocs/theme_cubit/theme_cubit.dart';
import '../../../presentation/pages/home/widgets/error_widget.dart' as custom;
import 'widgets/pet_grid_tile.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMorePets();
    }
  }

  Future<void> _loadMorePets() async {
    if (!_isLoadingMore) {
      setState(() => _isLoadingMore = true);
      await context.read<PetCubit>().loadMorePets();
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Adoption"),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state.isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, '/history');
            },
          ),
        ],
      ),
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
              final filteredPets =
                  searchQuery.isEmpty
                      ? allPets
                      : allPets
                          .where(
                            (pet) => pet.name.toLowerCase().contains(
                              searchQuery.toLowerCase(),
                            ),
                          )
                          .toList();

              return Column(
                children: [
                  SearchBarWidget(
                    onChanged: (value) => setState(() => searchQuery = value),
                  ),
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                      itemCount: filteredPets.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filteredPets.length) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return PetGridTile(pet: filteredPets[index]);
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
