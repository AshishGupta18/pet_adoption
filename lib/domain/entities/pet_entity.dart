import 'package:equatable/equatable.dart';

class PetEntity extends Equatable {
  final String id;
  final String name;
  final int age;
  final double price;
  final String imageUrl;
  final bool isAdopted;
  final bool isFavorited;

  const PetEntity({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.imageUrl,
    this.isAdopted = false,
    this.isFavorited = false,
  });

  @override
  List<Object?> get props =>
      [id, name, age, price, imageUrl, isAdopted, isFavorited];
}