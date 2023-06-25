import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pets_adopt/models/pet.dart';
import 'package:pets_adopt/pages/details_page.dart';

void main() {
  testWidgets('Widget test with BuildContext', (WidgetTester tester) async {

    final pet = Pet(
      name: 'Dog',
      age: '3',
      price: 1000,
      image: 'assets/american_bobtail.webp',
      isAdopted: false,
    );

    BuildContext? context;

    await tester.pumpWidget(
      Builder(
        builder: (BuildContext builderContext) {
          context = builderContext;
          return MaterialApp(
            home: DetailsPage(pet: pet),
          );
        },
      ),
    );

    expect(find.text(pet.name), findsOneWidget);

    await tester.tap(find.text('Adopt Me'));
    await tester.pumpAndSettle();


    expect(find.text('You\'ve now adopted ${pet.name}'), findsOneWidget);
  });
}
