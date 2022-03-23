

import '../../../data/model/LocationModel.dart';

abstract class LocationListEvent{}

class StartLoadListEvent extends LocationListEvent{}

class OnListOrderChanged extends LocationListEvent{
  final List<LocationModel> resultList;

  OnListOrderChanged(this.resultList);
}
