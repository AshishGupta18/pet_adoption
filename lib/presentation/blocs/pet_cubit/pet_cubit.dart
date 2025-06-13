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
}