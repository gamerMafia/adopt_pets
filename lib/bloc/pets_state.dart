import 'package:equatable/equatable.dart';
import 'package:pets_adopt/models/pet.dart';

abstract class PetsState extends Equatable {
  const PetsState();

  @override
  List<Object?> get props => [];
}

class PetInitialState extends PetsState {}

class PetLoadingState extends PetsState {}

class PetLoadedState extends PetsState {
  final List<Pet> pets;

  const PetLoadedState(this.pets);

  @override
  List<Object?> get props => [pets];
}

class HistoryPetLoadedState extends PetsState {
  final List<Pet> pets;

  const HistoryPetLoadedState(this.pets);

  @override
  List<Object?> get props => [pets];
}
