import '../../domain/repositories/pet_repository.dart';
import '../datasources/mock_pet_data.dart';
import '../models/pet_model.dart';

class PetRepositoryImpl implements PetRepository {
  final MockPetDataSource dataSource;

  PetRepositoryImpl({required this.dataSource});

  @override
  Future<List<PetModel>> getAllPets() {
    return dataSource.fetchPets();
  }
}