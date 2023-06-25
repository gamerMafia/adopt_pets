import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_adopt/bloc/pets_bloc.dart';
import 'package:pets_adopt/bloc/pets_event.dart';
import 'package:pets_adopt/bloc/pets_state.dart';
import 'package:pets_adopt/models/pet.dart';
import 'package:pets_adopt/utility/colors.dart';
import 'package:pets_adopt/utility/confetti_dialog.dart';
import 'package:photo_view/photo_view.dart';

class DetailsPage extends StatelessWidget {
  final Pet pet;

  const DetailsPage({super.key, required this.pet});

  static Route<void> route(PetsBloc petsBloc, Pet pet) {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider.value(
        value: petsBloc,
        child: DetailsPage(pet: pet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pet.name,
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
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: isDarkTheme ? null : AppColor.cardBackground,
        elevation: 0,
      ),
      body: BlocBuilder<PetsBloc, PetsState>(
        builder: (context, state) {
          if (state is PetLoadedState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Card(
                  margin: const EdgeInsets.all(16),
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
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: PhotoView(
                                      tightMode: true,
                                      imageProvider: AssetImage(pet.image),
                                      heroAttributes:  PhotoViewHeroAttributes(tag: pet.image),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Hero(
                              tag: pet.image,
                              child: Image.asset(
                                pet.image,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: ElevatedButton(
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
                        context.read<PetsBloc>().add(AdoptPetEvent(pet));

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('You\'ve now adopted ${pet.name}'),
                        ));
                        _handleAdoptButtonPressed(pet.name, context);
                      }
                    },
                    child: Text(
                      pet.isAdopted ? 'Already Adopted' : 'Adopt Me',
                      style: TextStyle(
                        color: pet.isAdopted
                            ? AppColor.hintBrownColor
                            : AppColor.buttonTextBrownColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleAdoptButtonPressed(String petName, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AdoptionPopup(petName: petName);
      },
    );
  }
}
