import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pet_adoption/data/models/pet_model.dart';
import '../../../domain/entities/pet_entity.dart';
import '../../../domain/repositories/pet_repository.dart';
import 'package:hive/hive.dart';
part 'pet_state.dart';



late Box petBox;
class PetCubit extends Cubit<PetState> {
  final PetRepository repository;

  PetCubit(this.repository) : super(PetInitial()){
    petBox = Hive.box('pet_state');
  }

Future<void> loadPets() async {
  emit(PetLoading());

  try {
    final pets = await repository.getAllPets();

    // Read saved states from Hive
 final savedAdoptions = petBox.get('adopted', defaultValue: <String>{}).cast<String>();
final savedFavorites = petBox.get('favorited', defaultValue: <String>{}).cast<String>();

    // Merge states into pets
    final updatedPets = pets.map((pet) {
      return pet.toEntity().copyWith(
        isAdopted: savedAdoptions.contains(pet.id),
        isFavorited: savedFavorites.contains(pet.id),
      );
    }).toList();

    emit(PetLoaded(updatedPets));
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

    // Save adopted pets IDs to Hive
    final adoptedIds = updatedPets
        .where((pet) => pet.isAdopted)
        .map((pet) => pet.id)
        .toSet();

    petBox.put('adopted', adoptedIds);
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

    // Save favorite pet IDs to Hive
    final favoritedIds = updatedPets
        .where((pet) => pet.isFavorited)
        .map((pet) => pet.id)
        .toSet();

    petBox.put('favorited', favoritedIds);
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


List<PetEntity> getAdoptedPets() {
  if (state is PetLoaded) {
    return (state as PetLoaded)
        .pets
        .where((pet) => pet.isAdopted)
        .toList();
  }
  return [];
}

}

