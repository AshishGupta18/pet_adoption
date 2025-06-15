import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/blocs/pet_cubit/pet_cubit.dart';
import '../../../presentation/blocs/theme_cubit/theme_cubit.dart';
import '../../../presentation/pages/home/widgets/error_widget.dart' as custom;
import 'widgets/pet_grid_tile.dart';
import 'widgets/search_bar.dart';
import '../../../domain/entities/pet_entity.dart';
import 'widgets/pet_grid.dart';

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
  int _currentPage = 0;
  static const int _petsPerPage = 10;

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

  List<PetEntity> _getCurrentPagePets(List<PetEntity> pets) {
    final startIndex = _currentPage * _petsPerPage;
    final endIndex = startIndex + _petsPerPage;
    return pets.length > startIndex
        ? pets.sublist(
          startIndex,
          endIndex > pets.length ? pets.length : endIndex,
        )
        : [];
  }

  int _getTotalPages(List<PetEntity> pets) {
    return (pets.length / _petsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pet Adoption"),
        leading: IconButton(
          icon: Icon(
            context.watch<ThemeCubit>().state.isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
        actions: [
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
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PetCubit>().refreshPets();
            },
          ),
        ],
      ),
      body: BlocBuilder<PetCubit, PetState>(
        builder: (context, state) {
          if (state is PetInitial) {
            context.read<PetCubit>().loadPets();
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PetError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PetCubit>().refreshPets();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is PetLoaded) {
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

            final currentPagePets = _getCurrentPagePets(filteredPets);
            final totalPages = _getTotalPages(filteredPets);

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<PetCubit>().refreshPets();
              },
              child: Column(
                children: [
                  SearchBarWidget(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                        _currentPage = 0;
                      });
                    },
                  ),
                  Expanded(
                    child: Column(
                      children: [
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
                            itemCount:
                                currentPagePets.length +
                                (_isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == currentPagePets.length) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return PetGridTile(pet: currentPagePets[index]);
                            },
                          ),
                        ),
                        if (totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.chevron_left),
                                  onPressed:
                                      _currentPage > 0
                                          ? () {
                                            setState(() {
                                              _currentPage--;
                                            });
                                          }
                                          : null,
                                ),
                                Text(
                                  'Page ${_currentPage + 1} of $totalPages',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  onPressed:
                                      _currentPage < totalPages - 1
                                          ? () {
                                            setState(() {
                                              _currentPage++;
                                            });
                                          }
                                          : null,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
