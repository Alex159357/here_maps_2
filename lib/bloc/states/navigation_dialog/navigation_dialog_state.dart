

import 'package:here_sdk/routing.dart';

import '../../../data/model/LocationModel.dart';
import '../../../data/model/rout_details.dart';

abstract class NavigationDialogState{}

class NavigationDialogStateInitial extends NavigationDialogState{}

class NavigationDialogStateShowDialog extends NavigationDialogState{
  final LocationModel model;
  final int position;
  final RoutDetails routDetails;
  final List<Waypoint> waypoints;
  final bool isLast;

  NavigationDialogStateShowDialog({required this.model, required this.position, required this.routDetails, required this.waypoints, required this.isLast});
}

class NavigationDialogStateCloseDialog extends NavigationDialogState{
  final LocationModel model;

  NavigationDialogStateCloseDialog({required this.model});
}

class NavigationDialogStateNavigate extends NavigationDialogState{
  final List<Waypoint> waypoints;
  final LocationModel model;
  final RoutDetails routDetails;

  NavigationDialogStateNavigate({required this.waypoints, required this.model, required this.routDetails});
}