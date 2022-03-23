import 'package:here_maps_test/data/model/GeometryModel.dart';

import 'address_model.dart';

class LocationModel{
  String id;
  String type;
  AddressModel address;
  GeometryModel geometry;

  LocationModel(this.id, this.type, this.address, this.geometry);

  factory LocationModel.fromJson(Map<String, dynamic> json)=> LocationModel(
      json["id"].toString(), json["type"].toString(),
      AddressModel.fromJson(json["address"]),
      GeometryModel.fromJson(json["geometry"]));

}