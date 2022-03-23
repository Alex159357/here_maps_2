

import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen.dart';

class MainCubit extends Cubit<Screens>{
  MainCubit() : super(Screens.MAP);

  void onAction(Screens state) => emit(state);

}