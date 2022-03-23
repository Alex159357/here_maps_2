

import 'package:here_maps_test/data/model/LocationModel.dart';

abstract class LocationListState{}

class InitLocationListState extends LocationListState{}

class LocationLoadedState extends LocationListState{
  final List<LocationModel> locationList;
  LocationLoadedState(this.locationList);
}

