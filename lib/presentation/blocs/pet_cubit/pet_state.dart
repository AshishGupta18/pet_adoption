part of 'pet_cubit.dart';

abstract class PetState {}

class PetInitial extends PetState {}

class PetLoading extends PetState {}

class PetLoaded extends PetState {
  final List<PetEntity> pets;

  PetLoaded(this.pets);
}

class PetError extends PetState {
  final String message;

  PetError(this.message);
}
