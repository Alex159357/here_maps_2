

import 'package:geolocator/geolocator.dart';

class Variables{
  final String _api_key = "18f15822d30d84fc474b9a7983de94a9";
  final String _base_url = "https://api.openweathermap.org/data/2.5/";
  static Position? myLocation;

  String get API_KEY => _api_key;

  String get BASE_URL => _base_url;

}