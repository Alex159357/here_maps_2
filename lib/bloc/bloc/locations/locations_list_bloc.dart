import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:here_maps_test/data/model/GeometryModel.dart';
import 'package:here_maps_test/data/model/LocationModel.dart';
import 'package:here_maps_test/data/model/address_model.dart';
import 'package:here_maps_test/helpers/location_helper.dart';

import '../../../api/api_services.dart';
import '../../events/location/location_list_vent.dart';
import '../../states/location/location_list_event.dart';

class LocationListBloc extends Bloc<LocationListEvent, LocationListState>{
  ApiServices apiServices;
  LocationHelper locationHelper;
  List<LocationModel> resultList = [];
  LocationListBloc({required this.apiServices, required LocationListState initialState, required this.locationHelper}) : super(initialState);


 @override
  Stream<LocationListState> mapEventToState(LocationListEvent event) async*{
   yield* workWithData(event);
  }

  Stream<LocationListState> workWithData(LocationListEvent event) async*{
    if(event is StartLoadListEvent) {
      var myLocation = await locationHelper.getLocation();
      resultList.add(LocationModel("-1", "home", AddressModel("Current Location", "", "", ""), GeometryModel(-118.2221621670418, 33.961573923652544 )));
      var data = await apiServices.getLocations();
      resultList.addAll(data);
      resultList.add(LocationModel( "-2", "current", AddressModel("Current Location", "", "", ""), GeometryModel(-118.2221621670418, 33.961573923652544 )));
      yield LocationLoadedState(resultList);
    }
    if(event is OnListOrderChanged){
      yield LocationLoadedState(resultList);
    }
  }

}