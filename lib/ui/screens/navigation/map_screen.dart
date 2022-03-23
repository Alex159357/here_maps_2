

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';

import '../../widgets/map_view/map_view.dart';
import '../../widgets/whether.dart';
import 'routing.dart';

class MapScreen extends StatefulWidget {
  final Position position;
  const MapScreen({Key? key, required this.position}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late HereMapController hereMapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          HereMap(onMapCreated:  _onMapCreated),
          const Positioned.fill(
            top: 25,
              child: Align(
              alignment: Alignment.topRight,
              child: WhetherWidget()))
        ],
      )
    );
  }

  void _onMapCreated(HereMapController controller) async{
    controller.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) async {
      if(error == null){
        controller.camera.lookAtPointWithDistance(GeoCoordinates(33.961573923652544, -118.2221621670418), 5000);
        controller.pinWidget(Image.asset("assets/map_location.png"), GeoCoordinates(33.961573923652544, -118.2221621670418));
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }
}

