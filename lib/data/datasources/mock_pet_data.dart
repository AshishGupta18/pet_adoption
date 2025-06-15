import '../models/pet_model.dart';

class MockPetDataSource {
  Future<List<PetModel>> fetchPets() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API delay

    return [
      PetModel(
        id: 'pet_1',
        name: 'Max',
        age: 2,
        price: 1500.0,
        imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1',
      ),
      PetModel(
        id: 'pet_2',
        name: 'Luna',
        age: 1,
        price: 2000.0,
        imageUrl:
            'https://images.unsplash.com/photo-1517849845537-4d257902454a',
      ),
      PetModel(
        id: 'pet_3',
        name: 'Charlie',
        age: 3,
        price: 1800.0,
        imageUrl:
            'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8',
      ),
      PetModel(
        id: 'pet_4',
        name: 'Bella',
        age: 2,
        price: 2200.0,
        imageUrl:
            'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
      ),
      PetModel(
        id: 'pet_5',
        name: 'Rocky',
        age: 4,
        price: 2500.0,
        imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
      ),
      PetModel(
        id: 'pet_6',
        name: 'Daisy',
        age: 1,
        price: 1900.0,
        imageUrl: 'https://images.unsplash.com/photo-1543852786-1cf6624b9987',
      ),
      PetModel(
        id: 'pet_7',
        name: 'Buddy',
        age: 2,
        price: 2100.0,
        imageUrl:
            'https://images.unsplash.com/photo-1530281700549-e82e7bf110d6',
      ),
      PetModel(
        id: 'pet_8',
        name: 'Molly',
        age: 3,
        price: 2300.0,
        imageUrl:
            'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9',
      ),
      PetModel(
        id: 'pet_9',
        name: 'Jack',
        age: 2,
        price: 1700.0,
        imageUrl: 'https://images.unsplash.com/photo-1546527868-ccb7ee7dfa6a',
      ),
      PetModel(
        id: 'pet_10',
        name: 'Lucy',
        age: 1,
        price: 2400.0,
        imageUrl:
            'https://images.unsplash.com/photo-1517849845537-4d257902454a',
      ),
      PetModel(
        id: 'pet_11',
        name: 'Cooper',
        age: 3,
        price: 2600.0,
        imageUrl:
            'https://images.unsplash.com/photo-1537151608828-ea2b11777ee8',
      ),
      PetModel(
        id: 'pet_12',
        name: 'Lily',
        age: 2,
        price: 2800.0,
        imageUrl:
            'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e',
      ),
      PetModel(
        id: 'pet_13',
        name: 'Bear',
        age: 4,
        price: 3000.0,
        imageUrl: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b',
      ),
      PetModel(
        id: 'pet_14',
        name: 'Maggie',
        age: 1,
        price: 2700.0,
        imageUrl: 'https://images.unsplash.com/photo-1543852786-1cf6624b9987',
      ),
      PetModel(
        id: 'pet_15',
        name: 'Duke',
        age: 2,
        price: 2900.0,
        imageUrl:
            'https://images.unsplash.com/photo-1530281700549-e82e7bf110d6',
      ),
    ];
  }
}
