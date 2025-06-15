import '../../domain/repositories/pet_repository.dart';
import '../models/pet_model.dart';
import '../services/petfinder_service.dart';

class PetfinderRepositoryImpl implements PetRepository {
  final PetfinderService _petfinderService;

  PetfinderRepositoryImpl(this._petfinderService);

  @override
  Future<List<PetModel>> getAllPets() async {
    final pets = await _petfinderService.getPets();
    return pets.map((entity) => PetModel.fromEntity(entity)).toList();
  }

  @override
  Future<List<PetModel>> getPetsPage(int page, int pageSize) async {
    final pets = await _petfinderService.getPets(page: page, limit: pageSize);
    return pets.map((entity) => PetModel.fromEntity(entity)).toList();
  }
}
