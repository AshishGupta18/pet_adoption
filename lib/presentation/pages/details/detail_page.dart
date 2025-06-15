import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import '../../../domain/entities/pet_entity.dart';
import '../../../presentation/blocs/pet_cubit/pet_cubit.dart';
import '../../../presentation/pages/home/widgets/adopt_button.dart';
import '../home/widgets/image_viewer.dart';

class DetailsPage extends StatefulWidget {
  final PetEntity pet;

  const DetailsPage({super.key, required this.pet});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleAdoption() {
    if (!widget.pet.isAdopted) {
      context.read<PetCubit>().adoptPet(widget.pet.id);
      _confettiController.play();

      showDialog(
        context: context,
        builder:
            (_) => AlertDialog(
              title: const Text('Adopted!'),
              content: Text("You've now adopted ${widget.pet.name}"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = context.select<PetCubit, PetEntity?>(
      (cubit) => cubit.getPetById(widget.pet.id),
    );

    if (pet == null) return const SizedBox();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => ImageViewerPage(
                            imageUrl: pet.imageUrl,
                            tag: pet.id,
                          ),
                    ),
                  );
                },
                child: Hero(
                  tag: pet.id,
                  child: Image.network(pet.imageUrl, fit: BoxFit.cover),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  pet.isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: pet.isFavorited ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<PetCubit>().toggleFavorite(pet.id);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            'Age',
                            '${pet.age} years',
                            Icons.cake,
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            'Price',
                            '₹${pet.price.toStringAsFixed(0)}',
                            Icons.attach_money,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AdoptButton(
                    isAdopted: pet.isAdopted,
                    onPressed: _handleAdoption,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ConfettiWidget(
        confettiController: _confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        shouldLoop: false,
        numberOfParticles: 30,
        maxBlastForce: 10,
        minBlastForce: 5,
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
