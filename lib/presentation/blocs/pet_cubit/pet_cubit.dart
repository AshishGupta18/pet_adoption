import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/pet_entity.dart';
import '../../../domain/repositories/pet_repository.dart';
import 'package:pet_adoption/data/models/pet_model.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetRepository repository;
  static const int _pageSize = 10;
  int _currentPage = 0;
  bool _hasMore = true;

  PetCubit(this.repository) : super(PetInitial());

  Future<void> loadPets() async {
    emit(PetLoading());
    _currentPage = 0;
    _hasMore = true;

    try {
      final pets = await repository.getAllPets();
      final prefs = await SharedPreferences.getInstance();
      final adoptedIds = prefs.getStringList('adopted') ?? [];
      final favoritedIds = prefs.getStringList('favorited') ?? [];

      final updatedPets =
          pets.map((pet) {
            return pet.toEntity().copyWith(
              isAdopted: adoptedIds.contains(pet.id),
              isFavorited: favoritedIds.contains(pet.id),
            );
          }).toList();

      emit(PetLoaded(updatedPets));
    } catch (e) {
      emit(PetError("Failed to load pets: $e"));
    }
  }

  Future<void> loadMorePets() async {
    if (!_hasMore) return;

    if (state is PetLoaded) {
      final currentPets = (state as PetLoaded).pets;
      _currentPage++;

      try {
        final newPets = await repository.getPetsPage(_currentPage, _pageSize);
        if (newPets.isEmpty) {
          _hasMore = false;
          return;
        }

        final prefs = await SharedPreferences.getInstance();
        final adoptedIds = prefs.getStringList('adopted') ?? [];
        final favoritedIds = prefs.getStringList('favorited') ?? [];

        final updatedNewPets =
            newPets.map((pet) {
              return pet.toEntity().copyWith(
                isAdopted: adoptedIds.contains(pet.id),
                isFavorited: favoritedIds.contains(pet.id),
              );
            }).toList();

        emit(PetLoaded([...currentPets, ...updatedNewPets]));
      } catch (e) {
        emit(PetError("Failed to load more pets: $e"));
      }
    }
  }

  /// ✅ Get a specific pet by ID
  PetEntity? getPetById(String id) {
    if (state is PetLoaded) {
      final pets = (state as PetLoaded).pets;
      try {
        return pets.firstWhere((pet) => pet.id == id);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// ✅ Mark a pet as adopted
  void adoptPet(String id) async {
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

      final adoptedIds =
          updatedPets
              .where((pet) => pet.isAdopted)
              .map((pet) => pet.id)
              .toList();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('adopted', adoptedIds);
    }
  }

  /// ✅ Toggle pet's favorite status
  void toggleFavorite(String id) async {
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

      final favoritedIds =
          updatedPets
              .where((pet) => pet.isFavorited)
              .map((pet) => pet.id)
              .toList();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorited', favoritedIds);
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
}
