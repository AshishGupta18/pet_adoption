import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
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
  final ConfettiController _confettiController =
      ConfettiController(duration: const Duration(seconds: 2));

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
        builder: (_) => AlertDialog(
          title: const Text('Adopted!'),
          content: Text("You’ve now adopted ${widget.pet.name}"),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pet = context
        .select<PetCubit, PetEntity?>((cubit) => cubit.getPetById(widget.pet.id));

    if (pet == null) return const SizedBox();

   return Scaffold(
  appBar: AppBar(title: Text(pet.name)),
  body: Stack(
    children: [
      ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageViewerPage(
                    imageUrl: pet.imageUrl,
                    tag: pet.id,
                  ),
                ),
              );
            },
            child: Hero(
              tag: pet.id,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  pet.imageUrl,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            pet.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text("Age: ${pet.age} years"),
          Text("Price: ₹${pet.price.toStringAsFixed(0)}"),
          const SizedBox(height: 24),
          AdoptButton(
            isAdopted: pet.isAdopted,
            onPressed: _handleAdoption,
          ),
        ],
      ),
      Align(
        alignment: Alignment.topCenter,
        child: ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive,
          shouldLoop: false,
          numberOfParticles: 30,
          maxBlastForce: 10,
          minBlastForce: 5,
        ),
      ),
    ],
  ),
);
  }
}