import 'package:equatable/equatable.dart';
import 'package:pets_adopt/models/pet.dart';

abstract class PetsEvent extends Equatable {
  const PetsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPetsEvent extends PetsEvent {
  final bool isInit;

  const LoadPetsEvent(this.isInit);

  @override
  List<Object?> get props => [isInit];
}

class AdoptPetEvent extends PetsEvent {
  final Pet pet;

  const AdoptPetEvent(this.pet);

  @override
  List<Object?> get props => [pet];
}

class SearchPetEvent extends PetsEvent {
  final String query;

  const SearchPetEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class AdoptHistoryPetEvent extends PetsEvent {

  const AdoptHistoryPetEvent();

  @override
  List<Object?> get props => [];
}