import 'package:flutter/material.dart';
import '../../../../domain/entities/pet_entity.dart';
import 'pet_grid_tile.dart';

class PetGrid extends StatelessWidget {
  final List<PetEntity> pets;
  final VoidCallback onLoadMore;
  final bool hasMorePets;
  final bool isLoading;

  const PetGrid({
    super.key,
    required this.pets,
    required this.onLoadMore,
    required this.hasMorePets,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.extentAfter < 200 &&
            hasMorePets &&
            !isLoading) {
          onLoadMore();
        }
        return true;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: pets.length + (hasMorePets ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == pets.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }
          return PetGridTile(pet: pets[index]);
        },
      ),
    );
  }
}
