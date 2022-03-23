import 'dart:io';

import 'package:geolocator/geolocator.dart';

class LocationHelper {
  Future<Position> getLocation() async => await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high)
      .then((value) => value);


  Stream<Position> getLocationInfinity() async* {
    //  while(true) {
    //   yield await getLocation();
    // }

  }
}
