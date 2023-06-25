import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pets_adopt/bloc/pets_bloc.dart';
import 'package:pets_adopt/bloc/pets_event.dart';
import 'package:pets_adopt/bloc/pets_state.dart';
import 'package:pets_adopt/models/pet.dart';
import 'package:pets_adopt/pages/details_page.dart';

void main() {
  testWidgets('DetailsPage widget test', (WidgetTester tester) async {
    final pet = Pet(
      name: 'Test Pet',
      age: '3',
      price: 100,
      image: 'assets/images/test_pet.jpg',
      isAdopted: false,
    );

    // Create a mock PetsBloc for testing
    final petsBloc = MockPetsBloc();

    // Mock the necessary PetsState for the test
    when(petsBloc.state).thenReturn(PetLoadedState([
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
    ]));

    // Pump the DetailsPage widget with the mock bloc
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: petsBloc,
          child: DetailsPage(pet: pet),
        ),
      ),
    );

    // Verify that the DetailsPage displays the correct content
    expect(find.text(pet.name), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    // Simulate tapping the Adopt Me button
    await tester.tap(find.text('Adopt Me'));
    await tester.pumpAndSettle();

    // Verify that the appropriate events are dispatched and SnackBar is shown
    verify(petsBloc.add(AdoptPetEvent(pet))).called(1);
    expect(find.text('You\'ve now adopted ${pet.name}'), findsOneWidget);

    // Perform other necessary assertions or interactions
  });
}

class MockPetsBloc extends MockBloc<PetsEvent, PetsState> implements PetsBloc {}

class MockPetsState extends Mock implements PetsState {}
