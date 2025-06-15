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

  @override
  Future<List<PetModel>> getPetsPage(int page, int pageSize) async {
    final allPets = await dataSource.fetchPets();
    final startIndex = page * pageSize;
    if (startIndex >= allPets.length) {
      return [];
    }
    final endIndex =
        (startIndex + pageSize) > allPets.length
            ? allPets.length
            : startIndex + pageSize;
    return allPets.sublist(startIndex, endIndex);
  }
}
