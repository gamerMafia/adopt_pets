import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_adopt/bloc/pets_bloc.dart';
import 'package:pets_adopt/bloc/pets_event.dart';
import 'package:pets_adopt/bloc/pets_state.dart';
import 'package:pets_adopt/utility/colors.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  static Route<void> route(PetsBloc petsBloc) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: petsBloc,
        child: const HistoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    context.read<PetsBloc>().add(const AdoptHistoryPetEvent());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adoption History',
          style: TextStyle(
            color: isDarkTheme ? Colors.white : AppColor.buttonBrownColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkTheme ? Colors.white : AppColor.buttonBrownColor,
          ),
          onPressed: () {
            context.read<PetsBloc>().add(const LoadPetsEvent(false));
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: isDarkTheme ? null : AppColor.cardBackground,
        elevation: 0,
      ),
      body: BlocBuilder<PetsBloc, PetsState>(
        builder: (context, state) {
           if (state is HistoryPetLoadedState) {
            final pets = state.pets;
            return WillPopScope(
              onWillPop: () {
                context.read<PetsBloc>().add(const LoadPetsEvent(false));
                return Future.value(true);
              },
              child: ListView.builder(
                itemCount: pets.length,
                itemBuilder: (context, index) {
                  final pet = pets[index];
                  return Card(
                    margin: EdgeInsets.only(
                        top: 16,
                        left: 16,
                        right: 16,
                        bottom: pets.length == index ? 16 : 0),
                    //color: AppColor.cardBackground,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(16),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            child: Image.asset(
                              pet.image,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pet.name,
                                style: TextStyle(
                                    color: isDarkTheme
                                        ? Colors.white
                                        : AppColor.darkBrownColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(35),
                                  elevation: 0,
                                  backgroundColor: pet.isAdopted
                                      ? Colors.black
                                      : AppColor.buttonBrownColor,
                                ),
                                onPressed: null,
                                child: Text(
                                  pet.isAdopted ? 'Already Adopted' : 'Adopt Me',
                                  style: TextStyle(
                                    color: pet.isAdopted
                                        ? AppColor.hintBrownColor
                                        : AppColor.buttonTextBrownColor,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
