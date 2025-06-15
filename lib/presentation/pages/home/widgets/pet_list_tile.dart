// import 'package:flutter/material.dart';
// import '../../../../domain/entities/pet_entity.dart';
// import '../../../routes/app_routes.dart';

// class PetListTile extends StatelessWidget {
//   final PetEntity pet;

//   const PetListTile({super.key, required this.pet});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (!pet.isAdopted) {
//           Navigator.pushNamed(
//             context,
//             AppRoutes.details,
//             arguments: pet,
//           );
//         }
//       },
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         child: ListTile(
//           leading: Hero(
//             tag: pet.id,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(8),
//               child: Image.network(
//                 pet.imageUrl,
//                 width: 60,
//                 height: 60,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           title: Text(pet.name),
//           subtitle: Text('${pet.age} years old • ₹${pet.price.toStringAsFixed(0)}'),
//           trailing: pet.isAdopted
//               ? const Text("Adopted", style: TextStyle(color: Colors.grey))
//               : const Icon(Icons.arrow_forward_ios),
//         ),
//       ),
//     );
//   }
// }