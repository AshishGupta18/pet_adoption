import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption/data/models/pet_model.dart';
import '../../../domain/entities/pet_entity.dart';
import '../../../domain/repositories/pet_repository.dart';

part 'pet_state.dart';

class PetCubit extends Cubit<PetState> {
  final PetRepository repository;

  PetCubit(this.repository) : super(PetInitial());

  Future<void> loadPets() async {
    emit(PetLoading());

    try {
      final pets = await repository.getAllPets();
      emit(PetLoaded(pets.map((pet) => pet.toEntity()).toList()));
    } catch (e) {
      emit(PetError("Failed to load pets: $e"));
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
  void adoptPet(String id) {
    if (state is PetLoaded) {
      final pets = (state as PetLoaded).pets;

      final updatedPets = pets.map((pet) {
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

      final updatedPets = pets.map((pet) {
        if (pet.id == id) {
          return pet.copyWith(isFavorited: !pet.isFavorited);
        }
        return pet;
      }).toList();

      emit(PetLoaded(updatedPets));
    }
  }



  List<PetEntity> getFavoritedPets() {
  if (state is PetLoaded) {
    return (state as PetLoaded)
        .pets
        .where((pet) => pet.isFavorited)
        .toList();
  }
  return [];
}
}

