

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../events/navigation_dialog_event.dart';
import '../../states/navigation_dialog/navigation_dialog_state.dart';

class NavigationDialogBloc extends Bloc<NavigationDialogEvent, NavigationDialogState>{
  NavigationDialogBloc(NavigationDialogState initialState) : super(initialState);


  @override
  Stream<NavigationDialogState> mapEventToState(NavigationDialogEvent event) async*{
    if(event is NavigationDialogEventShowDialog){
      yield NavigationDialogStateShowDialog(model: event.model, position: event.position, routDetails: event.routDetails, waypoints: event.waypoints, isLast: event.isLast);
    }
    if(event is NavigationDialogEventCloseDialog){
      yield NavigationDialogStateCloseDialog(model: event.model);
    }
    if(event is NavigationDialogEventNavigate){
      yield NavigationDialogStateNavigate(waypoints: event.waypoints, model: event.model, routDetails: event.routDetails);
    }
  }

}
