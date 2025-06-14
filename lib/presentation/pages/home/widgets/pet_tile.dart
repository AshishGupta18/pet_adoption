import 'package:flutter/material.dart';
import 'package:pet_adoption/domain/entities/pet_entity.dart';

class PetTile extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onTap;

  const PetTile({super.key, required this.pet, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: pet.id,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(pet.imageUrl),
            radius: 28,
          ),
          title: Text(pet.name),
          subtitle: Text('Age: ${pet.age}, ₹${pet.price.toStringAsFixed(0)}'),
          trailing: Icon(
            pet.isAdopted
                ? Icons.check_circle
                : pet.isFavorited
                    ? Icons.favorite
                    : Icons.pets,
            color: pet.isAdopted
                ? Colors.green
                : pet.isFavorited
                    ? Colors.red
                    : null,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}