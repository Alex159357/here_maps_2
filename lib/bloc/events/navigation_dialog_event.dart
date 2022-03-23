

import 'package:here_sdk/routing.dart';

import '../../data/model/LocationModel.dart';
import '../../data/model/rout_details.dart';

abstract class NavigationDialogEvent{}

class NavigationDialogEventShowDialog extends NavigationDialogEvent{
  final LocationModel model;
  final int position;
  final RoutDetails routDetails;
  final List<Waypoint> waypoints;
  final bool isLast;

  NavigationDialogEventShowDialog({required this.model, required this.position, required this.routDetails, required this.waypoints, required this.isLast});
}

class NavigationDialogEventCloseDialog extends NavigationDialogEvent{
  final LocationModel model;

  NavigationDialogEventCloseDialog({required this.model});
}

class NavigationDialogEventNavigate extends NavigationDialogEvent{
  final List<Waypoint> waypoints;
  final LocationModel model;
  final RoutDetails routDetails;

  NavigationDialogEventNavigate({required this.waypoints, required this.model, required this.routDetails});
}