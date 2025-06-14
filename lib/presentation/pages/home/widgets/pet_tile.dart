import 'package:flutter/material.dart';
import '../../../../domain/entities/pet_entity.dart';

class PetTile extends StatelessWidget {
  final PetEntity pet;
  final VoidCallback onTap;

  const PetTile({
    super.key,
    required this.pet,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: pet.id,
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          contentPadding: const EdgeInsets.all(12),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(pet.imageUrl),
            radius: 28,
          ),
          title: Text(pet.name),
          subtitle: Text("Age: ${pet.age}, ₹${pet.price}"),
          trailing: Icon(
            pet.isFavorited ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}