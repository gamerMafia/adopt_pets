import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_adopt/bloc/pets_bloc.dart';
import 'package:pets_adopt/bloc/pets_event.dart';
import 'package:pets_adopt/bloc/pets_state.dart';
import 'package:pets_adopt/pages/details_page.dart';
import 'package:pets_adopt/pages/history_page.dart';
import 'package:pets_adopt/utility/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final petsBloc = BlocProvider.of<PetsBloc>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          child: AppBar(
            elevation: 0,
            title: TextField(
              onChanged: (query) {
                context.read<PetsBloc>().add(SearchPetEvent(query));
              },
              cursorColor: AppColor.buttonBrownColor,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                prefixIconColor: AppColor.buttonBrownColor,
                hintText: 'Search your pets',
                filled: true,
                contentPadding: const EdgeInsets.all(15),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColor.borderBrownColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColor.borderBrownColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColor.borderBrownColor),
                ),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<PetsBloc, PetsState>(
        bloc: petsBloc,
        builder: (context, state) {
          if (state is PetInitialState) {
            context.read<PetsBloc>().add(const LoadPetsEvent(true));
          } else if (state is PetLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.buttonBrownColor,
              ),
            );
          } else if (state is PetLoadedState) {
            final pets = state.pets;
            return ListView.builder(
              itemCount: pets.length,
              itemBuilder: (context, index) {
                final pet = pets[index];
                return Stack(
                  children: [
                    Card(
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
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push<void>(
                                DetailsPage.route(
                                    context.read<PetsBloc>(), pet),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(16),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0)),
                                child: Hero(
                                  tag: pet.image,
                                  transitionOnUserGestures: true,
                                  flightShuttleBuilder: (
                                      flightContext,
                                      animation,
                                      flightDirection,
                                      fromHeroContext,
                                      toHeroContext,
                                      ) {
                                    return ScaleTransition(
                                      scale: animation.drive(
                                        Tween<double>(begin: 1.0, end: 0.5).chain(
                                          CurveTween(curve: Curves.easeInOut),
                                        ),
                                      ),
                                      child: toHeroContext.widget,
                                    );
                                  },
                                  child: Image.asset(
                                    pet.image,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${pet.age} year',
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? Colors.white.withOpacity(0.6)
                                            : AppColor.lightBrownColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '\u{20B9}${pet.price}',
                                      style: TextStyle(
                                        color: isDarkTheme
                                            ? Colors.white.withOpacity(0.8)
                                            : AppColor.buttonBrownColor,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(35),
                                    elevation: 0,
                                    backgroundColor: pet.isAdopted
                                        ? Colors.black
                                        : AppColor.buttonBrownColor,
                                  ),
                                  onPressed: () {
                                    if (!pet.isAdopted) {
                                      //petsBloc.add(AdoptPet(pet));
                                      context
                                          .read<PetsBloc>()
                                          .add(AdoptPetEvent(pet));

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'You\'ve now adopted ${pet.name}'),
                                      ));
                                    }
                                  },
                                  child: Text(
                                    pet.isAdopted
                                        ? 'Already Adopted'
                                        : 'Adopt Me',
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
                    ),
                    if (pet.isAdopted)
                      Positioned.fill(
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push<void>(
                              DetailsPage.route(
                                  context.read<PetsBloc>(), pet),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 16,
                                left: 16,
                                right: 16,
                                bottom: pets.length == index ? 16 : 0),
                            decoration: BoxDecoration(
                                color: isDarkTheme
                                    ? Colors.white.withOpacity(0.3)
                                    : Colors.black.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                          ),
                        ),
                      )
                  ],
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push<void>(
            HistoryPage.route(context.read<PetsBloc>()),
          );
        },
        mini: true,
        child: const Icon(Icons.history),
      ),
    );
  }
}
