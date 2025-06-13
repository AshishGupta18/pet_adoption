import '../models/pet_model.dart';

class MockPetDataSource {
  Future<List<PetModel>> fetchPets() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API delay

    return List.generate(15, (index) {
      return PetModel(
        id: 'pet_$index',
        name: 'Pet #$index',
        age: 1 + index % 5,
        price: 100.0 + (index * 10),
        imageUrl: 'https://picsum.photos/seed/pet$index/200/300',
      );
    });
  }
}