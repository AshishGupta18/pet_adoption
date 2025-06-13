import '../../data/models/pet_model.dart';

abstract class PetRepository {
  Future<List<PetModel>> getAllPets();
}