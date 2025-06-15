import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/services/petfinder_service.dart';
import '../../../domain/entities/pet_entity.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetfinderService _petfinderService;
  int _currentPage = 1;
  bool _hasMorePets = true;
  bool _isLoading = false;
  static const int _pageSize = 20;

  PetCubit(this._petfinderService) : super(PetInitial());

  Future<void> loadPets() async {
    if (_isLoading) return;

    _isLoading = true;
    emit(PetLoading());

    try {
      final pets = await _petfinderService.getPets(
        page: _currentPage,
        limit: _pageSize,
      );
      if (pets.isEmpty) {
        _hasMorePets = false;
        emit(PetLoaded([]));
      } else {
        emit(PetLoaded(pets));
        _currentPage++;
      }
    } catch (e) {
      emit(PetError("Failed to load pets: $e"));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refreshPets() async {
    _currentPage = 1;
    _hasMorePets = true;
    await loadPets();
  }

  Future<void> loadMorePets() async {
    if (!_hasMorePets || _isLoading) return;

    if (state is PetLoaded) {
      _isLoading = true;
      final currentPets = (state as PetLoaded).pets;

      try {
        final newPets = await _petfinderService.getPets(
          page: _currentPage,
          limit: _pageSize,
        );
        if (newPets.isEmpty) {
          _hasMorePets = false;
          return;
        }

        emit(PetLoaded([...currentPets, ...newPets]));
        _currentPage++;
      } catch (e) {
        emit(PetError("Failed to load more pets: $e"));
      } finally {
        _isLoading = false;
      }
    }
  }

  /// ✅ Get a specific pet by ID
  PetEntity? getPetById(String id) {
    if (state is PetLoaded) {
      final pets = (state as PetLoaded).pets;
      try {
        return pets.firstWhere((pet) => pet.id == id);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// ✅ Mark a pet as adopted
  void adoptPet(String id) {
    if (state is PetLoaded) {
      final pets = (state as PetLoaded).pets;
      final updatedPets =
          pets.map((pet) {
            if (pet.id == id) {
              return pet.copyWith(isAdopted: true);
            }
            return pet;
          }).toList();
      emit(PetLoaded(updatedPets));
    }
  }

  /// ✅ Toggle pet's favorite status
  void toggleFavorite(String id) {
    if (state is PetLoaded) {
      final pets = (state as PetLoaded).pets;
      final updatedPets =
          pets.map((pet) {
            if (pet.id == id) {
              return pet.copyWith(isFavorited: !pet.isFavorited);
            }
            return pet;
          }).toList();
      emit(PetLoaded(updatedPets));
    }
  }

  /// ✅ Get all favorited pets
  List<PetEntity> getFavoritedPets() {
    if (state is PetLoaded) {
      return (state as PetLoaded).pets.where((pet) => pet.isFavorited).toList();
    }
    return [];
  }

  /// ✅ Get all adopted pets
  List<PetEntity> getAdoptedPets() {
    if (state is PetLoaded) {
      return (state as PetLoaded).pets.where((pet) => pet.isAdopted).toList();
    }
    return [];
  }

  bool get hasMorePets => _hasMorePets;
  bool get isLoading => _isLoading;
}
