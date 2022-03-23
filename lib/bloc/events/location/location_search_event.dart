
import '../../../data/model/LocationModel.dart';

abstract class LocationSearchEvent{}

class LocationSearchEventInit extends LocationSearchEvent{}

class LocationSearchEventOnQueryEdit extends LocationSearchEvent{
  final String query;

  LocationSearchEventOnQueryEdit(this.query);
}
