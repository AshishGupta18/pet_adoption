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
      icon: Icon(
        isAdopted ? Icons.check_circle : Icons.pets,
        color: isAdopted ? Colors.grey : Colors.white,
      ),
      label: Text(
        isAdopted ? 'Already Adopted' : 'Adopt Me',
        style: TextStyle(
          color: isAdopted ? Colors.grey : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isAdopted
                ? Colors.grey[300]
                : Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
