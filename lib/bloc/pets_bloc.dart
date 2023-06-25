import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_adopt/bloc/pets_event.dart';
import 'package:pets_adopt/bloc/pets_state.dart';
import 'package:pets_adopt/models/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetsBloc extends Bloc<PetsEvent, PetsState> {
  List<Pet> pets = [];
  List<Pet> filteredPets = [];
  final SharedPreferences sharedPreferences;

  PetsBloc({required this.sharedPreferences}) : super(PetInitialState()) {
    on<LoadPetsEvent>(_handleLoadPets);
    on<AdoptPetEvent>(_handleAdoptPet);
    on<SearchPetEvent>(_handleSearchPet);
    on<AdoptHistoryPetEvent>(_handleAdoptedPetHistory);
  }

  void _handleLoadPets(LoadPetsEvent event, Emitter<PetsState> emit) async {
    emit(PetLoadingState());


    if (event.isInit) {
      await Future.delayed(const Duration(seconds: 2));
    }

    pets = [
      Pet(
          name: 'American Bobtail',
          age: '2',
          price: 1000,
          image: 'assets/american_bobtail.webp'),
      Pet(
          name: 'Belgian Sheepdog',
          age: '1',
          price: 7500,
          image: 'assets/belgian_sheepdog.webp'),
      Pet(
          name: 'Bombay',
          age: '1.5',
          price: 5000.0,
          image: 'assets/bombay.webp'),
      Pet(
          name: 'Britush Shorthair',
          age: '3',
          price: 1500.0,
          image: 'assets/britush_shorthair.webp'),
      Pet(
          name: 'Egyptian Mau',
          age: '3',
          price: 200.0,
          image: 'assets/egyptian_mau.webp'),
      Pet(
          name: 'Field Spaniel',
          age: '4',
          price: 120.0,
          image: 'assets/field_spaniel.webp'),
      Pet(
          name: 'Labrador Retriever',
          age: '2',
          price: 12000.0,
          image: 'assets/labrador_retriever.webp'),
      Pet(
          name: 'Maine Coon',
          age: '2.5',
          price: 1000.0,
          image: 'assets/maine_coon.webp'),
      Pet(
          name: 'Papillon',
          age: '1.2',
          price: 23330.0,
          image: 'assets/papillon.webp'),
      Pet(
          name: 'Persian',
          age: '4',
          price: 4000.0,
          image: 'assets/persian.webp'),
      Pet(
          name: 'Pomeranian',
          age: '2',
          price: 3900.0,
          image: 'assets/pomeranian.webp'),
      Pet(name: 'Pug', age: '3', price: 20001.0, image: 'assets/pug.webp'),
      Pet(
          name: 'Ragdoll',
          age: '1',
          price: 20002.0,
          image: 'assets/ragdoll.webp'),
      Pet(
          name: 'Rottweiler',
          age: '1.1',
          price: 9999.0,
          image: 'assets/rottweiler.webp'),
      Pet(
          name: 'Russian Blue',
          age: '4',
          price: 1111.0,
          image: 'assets/russian_blue.webp'),
      Pet(
          name: 'Scottish',
          age: '5',
          price: 200000.0,
          image: 'assets/scottish.webp'),
      Pet(
          name: 'Selkirk Rex',
          age: '2',
          price: 30000.0,
          image: 'assets/selkirk_rex.webp'),
      Pet(
          name: 'Shiba Inu',
          age: '4.1',
          price: 8989.0,
          image: 'assets/shiba_inu.webp'),
      Pet(
          name: 'Sussex Spaniel',
          age: '2.3',
          price: 1122.0,
          image: 'assets/sussex_spaniel.webp'),
      Pet(
          name: 'Turkish Angora',
          age: '0.5',
          price: 22000.0,
          image: 'assets/turkish_angora.webp'),
    ];
    getAdoptedPets();
    filteredPets = pets;
    emit(PetLoadedState(filteredPets));
  }

  void _handleAdoptPet(AdoptPetEvent event, Emitter<PetsState> emit) {
    emit(PetLoadingState());

    final petIndex = filteredPets.indexOf(event.pet);
    if (petIndex >= 0) {
      final updatedPets = List<Pet>.from(filteredPets);
      updatedPets[petIndex].isAdopted = true;
      saveAdoptedPet(updatedPets[petIndex].name);
      emit(PetLoadedState(updatedPets));
    }
  }

  void _handleSearchPet(SearchPetEvent event, Emitter<PetsState> emit) {
    emit(PetLoadingState());

    if (event.query.isNotEmpty) {
      filteredPets = pets
          .where((pet) =>
              pet.name.toLowerCase().contains(event.query.toLowerCase()))
          .toList();
    } else {
      filteredPets = pets;
    }
    emit(PetLoadedState(filteredPets));
  }

  void _handleAdoptedPetHistory(
      AdoptHistoryPetEvent event, Emitter<PetsState> emit) {
    List<Pet> historyPet = [];
    List<String>? adoptedPets =
        sharedPreferences.getStringList('adopted_pets') ?? [];
    for (String pet in adoptedPets) {
      for (Pet adoptedPet in pets) {
        if (pet == adoptedPet.name) {
          historyPet.add(adoptedPet);
        }
      }
    }
    emit(HistoryPetLoadedState(historyPet));
  }

  void saveAdoptedPet(String petName) async {
    List<String>? adoptedPets =
        sharedPreferences.getStringList('adopted_pets') ?? [];
    adoptedPets.add(petName);
    await sharedPreferences.setStringList('adopted_pets', adoptedPets);
  }

  void getAdoptedPets() {
    List<String>? adoptedPets =
        sharedPreferences.getStringList('adopted_pets') ?? [];
    for (Pet adoptedPet in pets) {
      for (String pet in adoptedPets) {
        if (pet == adoptedPet.name) {
          adoptedPet.isAdopted = true;
        }
      }
    }
  }
}
