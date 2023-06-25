import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pets_adopt/bloc/pets_bloc.dart';
import 'package:pets_adopt/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utility/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(sharedPreferences));
}

class SimpleBlocObserver extends BlocObserver {

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (bloc is Cubit)
      print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

class MyApp extends StatelessWidget {

  final SharedPreferences sharedPreferences;

  const MyApp(this.sharedPreferences, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Adoption App',
      theme: CustomTheme.lightTheme,
      darkTheme: CustomTheme.darkTheme,
      home: BlocProvider<PetsBloc>(
        create: (context) => PetsBloc(sharedPreferences: sharedPreferences),
        child: const HomePage(),
      ),
    );
  }
}
