import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:here_maps_test/data/model/LocationModel.dart';
import 'package:here_maps_test/data/model/whether_data.dart';
import 'package:here_sdk/core.dart';

import '../helpers/http_helper.dart';
import '../variables.dart';

class ApiServices with Variables, HttpHelper{

  Future<List<LocationModel>> getLocations() async{
    final String response = await rootBundle.loadString('assets/data.json');
    List<dynamic> data = await json.decode(response)["orders"];
    List<LocationModel> resList = [];
    for (var element in data) {
      resList.add(LocationModel.fromJson(element));
    }
    return resList;
  }


  Future<WhetherData?> getWhether(GeoCoordinates geoCoordinates)async{
    try{
      final response = await Dio().get(BASE_URL+"weather?lat=${geoCoordinates.latitude}&lon=${geoCoordinates.longitude}&units=metric&appid=$API_KEY");
      // print("Whether -> ${response.data}");
      if(response.statusCode == 200){
        var data = await response.data["main"];
        // ["weather"]
        print("LoadedData -> ${data}");
        return WhetherData.fromJson(data);
      }
    }catch(e){
      print("********************************** ERROR **********************************");
      print(e);
      return null;
    }
  }
}