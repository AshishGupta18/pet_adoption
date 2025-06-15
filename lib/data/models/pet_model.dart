import '../../domain/entities/pet_entity.dart';

class PetModel {
  final String id;
  final String name;
  final int age;
  final double price;
  final String imageUrl;
  bool isAdopted;
  bool isFavorited;

  PetModel({
    required this.id,
    required this.name,
    required this.age,
    required this.price,
    required this.imageUrl,
    this.isAdopted = false,
    this.isFavorited = false,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      isAdopted: json['isAdopted'] ?? false,
      isFavorited: json['isFavorited'] ?? false,
    );
  }

  factory PetModel.fromEntity(PetEntity entity) {
    return PetModel(
      id: entity.id,
      name: entity.name,
      age: entity.age,
      price: entity.price,
      imageUrl: entity.imageUrl,
      isAdopted: entity.isAdopted,
      isFavorited: entity.isFavorited,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'price': price,
    'imageUrl': imageUrl,
    'isAdopted': isAdopted,
    'isFavorited': isFavorited,
  };
}

extension PetModelMapper on PetModel {
  PetEntity toEntity() => PetEntity(
    id: id,
    name: name,
    age: age,
    price: price,
    imageUrl: imageUrl,
    isAdopted: isAdopted,
    isFavorited: isFavorited,
  );
}
