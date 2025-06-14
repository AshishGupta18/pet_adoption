import 'package:flutter/material.dart';

class AdoptButton extends StatelessWidget {
  final bool isAdopted;
  final VoidCallback onPressed;

  const AdoptButton({
    super.key,
    required this.isAdopted,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isAdopted ? null : onPressed,
      icon: const Icon(Icons.pets),
      label: Text(isAdopted ? 'Already Adopted' : 'Adopt Me'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        backgroundColor: isAdopted ? Colors.grey : Colors.green,
      ),
    );
  }
}