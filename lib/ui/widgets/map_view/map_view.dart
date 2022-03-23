

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_maps_test/data/model/LocationModel.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';


enum PointType {
  NUMBERED_DOT, MY_LOCATOIN, HOME
}

enum MapTypeFlow{
  ONLY_MY_LOCATION, NAVIGATION
}


class MapView extends StatelessWidget {
  final Position? position;
  final MapTypeFlow mapTypeFlow;
  final List<LocationModel>? list;
  MapView({this.position, required this.mapTypeFlow, this.list, Key? key}) : super(key: key);

  List<GeoCoordinates> coordinates = [];


  @override
  Widget build(BuildContext context) {
    coordinates.add(GeoCoordinates(34.04294776373491, -118.26619126684135));
    coordinates.add(GeoCoordinates(33.94850166270941, -118.10937211014961));
    coordinates.add(GeoCoordinates(33.961573923652544, -118.2221621670418));
    coordinates.add(GeoCoordinates(34.06396490682465, -118.29458705104759));
    return HereMap(onMapCreated: mapTypeFlow == MapTypeFlow.ONLY_MY_LOCATION?  _onMapCreated: _onMapCreatedNavigator);
  }

  void _onMapCreatedNavigator(HereMapController hereMapController) async{
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) async {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }
      const double distanceToEarthInMeters = 50000;
      hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(34.04294776373491 , -118.26619126684135), distanceToEarthInMeters);
      hereMapController.mapScene.setLayerVisibility(MapSceneLayers.vehicleRestrictions, VisibilityState.visible);
      hereMapController.mapScene.addMapPolyline(_createPolyline(coordinates)!);


      coordinates.forEach((element) {
        hereMapController.pinWidget(
          _createWidget(PointType.HOME), element,);
      });


      // hereMapController.mapScene.addMapMarker(marker!);
    });
  }

  void _onMapCreated(HereMapController hereMapController) async{
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) async {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }
      const double distanceToEarthInMeters = 50000;

      hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(position!.latitude, position!.longitude), distanceToEarthInMeters);
      hereMapController.mapScene.setLayerVisibility(MapSceneLayers.landmarks, VisibilityState.visible);
      hereMapController.pinWidget(
        _createWidget(PointType.HOME), GeoCoordinates(34.04294776373491 , -118.26619126684135),);
      hereMapController.frameRate = 120;
      // hereMapController.mapScene.addMapMarker(marker!);
    });

    // hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) async {
    //   if (error == null) {
    //     const double distanceToEarthInMeters = 80000;
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.extrudedBuildings, VisibilityState.visible);
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.trafficFlow, VisibilityState.visible);
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.trafficIncidents, VisibilityState.visible);
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.safetyCameras, VisibilityState.visible);
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.vehicleRestrictions, VisibilityState.visible);
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.landmarks, VisibilityState.visible);
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.extrudedBuildings, VisibilityState.visible);
    //     // hereMapController.mapScene.setLayerVisibility(MapSceneLayers.buildingFootprints, VisibilityState.visible);
    //     hereMapController.pinWidget(
    //       _createWidget(PointType.HOME), GeoCoordinates(34.04294776373491 , -118.26619126684135),);
    //     hereMapController.camera.lookAtPointWithDistance(GeoCoordinates(34.04294776373491 , -118.26619126684135), distanceToEarthInMeters);
    //     hereMapController.mapScene.setLayerVisibility(MapSceneLayers.buildingFootprints, VisibilityState.visible);
    //     hereMapController.frameRate = 120;
    //   }else {
    //     print('Map scene not loaded. MapError: ${error.toString()}');
    //     return;
    //   }
    // });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

  }

  Widget _createWidget(PointType type) {
    return Image.asset('assets/map_location.png');
  }

  MapPolyline? _createPolyline(List<GeoCoordinates> coordinates) {
    GeoPolyline geoPolyline;
    try {
      print("Add_point SUCCESS");
      geoPolyline = GeoPolyline(coordinates);
    } on Exception {
      print("Add_point ERROR");
      return null;
    }

    double widthInPixels = 10;
    Color lineColor = Color.fromARGB(255, 255, 0, 138);
    MapPolyline mapPolyline = MapPolyline(geoPolyline, widthInPixels, lineColor);

    return mapPolyline;
  }

}
