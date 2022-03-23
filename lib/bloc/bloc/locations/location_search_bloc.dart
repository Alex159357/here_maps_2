

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:here_maps_test/bloc/events/location/location_search_event.dart';
import 'package:here_maps_test/bloc/states/location/location_search_state.dart';

class LocationSearchBloc extends Bloc<LocationSearchEvent, LocationSearchState>{

  LocationSearchBloc() : super(LocationSearchState());

  @override
  Stream<LocationSearchState> mapEventToState(LocationSearchEvent event) async*{
    if(event is LocationSearchEventOnQueryEdit){
      yield LocationSearchState(query: event.query.toLowerCase());
    }
  }

}