import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:here_sdk/routing.dart' as here;

import '../../../data/model/LocationModel.dart';
import '../../../data/model/rout_details.dart';

typedef ShowDialogFunction = void Function(String title, String message);
typedef OnRouteDetailsReady = void Function(LocationModel model, RoutDetails routDetails, List<Waypoint> waypoints, bool ifLast);
typedef OnRouteDetailsError = void Function(String errorTitle, String message);
typedef OnRoutDone = void Function();

class Routing {
  final HereMapController _hereMapController;
  final List<MapPolyline> _mapPolylines = [];
  late RoutingEngine _routingEngine;
  final Color _lineColor;
  final List<LocationModel?> locationList;

  late OnRouteDetailsReady onRouteDetailsReady;
  late OnRouteDetailsError onRouteDetailsError;
  late OnRoutDone onRoutDone;
  final GeoCoordinates myLocation;

  Routing(HereMapController hereMapController, this.myLocation,
      this._lineColor, this.locationList)
      : _hereMapController = hereMapController {
    double distanceToEarthInMeters = 7000;
    _hereMapController.camera.lookAtPointWithDistance(myLocation, distanceToEarthInMeters);
    // _hereMapController.pinWidget(Image.asset("assets/map_location.png"), myLocation);
    

    try {
      _routingEngine = RoutingEngine();
    } on InstantiationException {
      throw ("Initialization of RoutingEngine failed.");
    }
  }

  Future<void> addRoute(List<Waypoint> waypoints) async {
    _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
        (RoutingError? routingError, List<here.Route>? routeList) async {
      if (routingError == null) {
        // When error is null, then the list guaranteed to be not null.
        here.Route route = routeList!.first;
        _showRouteOnMap(route);
        _logRouteSectionDetails(route);
        _logRouteViolations(route);
        onRoutDone.call();
      } else {
        var error = routingError.toString();
        onRouteDetailsError.call(
          routingError.name,
          routingError.toString(),
        );
      }
    });
  }

  Future<void> placeWidgets(LocationModel element, int position) async {
    print("CurrentWidget -> ${element.type}");
    Widget? content = element.type == "home"? Image.asset("assets/unit_home.png", width: 15, height: 15,): Text("$position");
    _hereMapController.pinWidget(_createWidget(content), GeoCoordinates(element.geometry.lat, element.geometry.lon));
    _hereMapController.camera.flyTo(GeoCoordinates(element.geometry.lat, element.geometry.lon));
  }

  Widget _createWidget(Widget content) {
    return Center(
      child: Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/union.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(child: Container(margin: EdgeInsets.only(bottom: content is Image? 12 :10), child: content))),
    );
  }

  Future<LocationModel?> getRouteDetail({required LocationModel lastModel}) async {
    var element = lastModel;
    var nextElement = element != locationList.last ? locationList[locationList.indexOf(lastModel) + 1] : null;

    if (nextElement != null) {
      var startWaypoint = Waypoint.withDefaults(
          GeoCoordinates(element.geometry.lat, element.geometry.lon));
      var destinationWaypoint = Waypoint.withDefaults(
          GeoCoordinates(nextElement.geometry.lat, nextElement.geometry.lon));
      //

      List<Waypoint> waypoints = [startWaypoint, destinationWaypoint];
      _routingEngine.calculateCarRoute(waypoints, CarOptions.withDefaults(),
          (RoutingError? routingError, List<here.Route>? routeList) async {
        if (routingError == null) {
          here.Route route = routeList!.first;
          RoutDetails(
              id: element.id,
              estimatedTravelTimeInSeconds: route.duration.inMicroseconds,
              lengthInMeters: route.lengthInMeters);
          onRouteDetailsReady.call(
              nextElement,
              RoutDetails(
                  id: nextElement.id,
                  estimatedTravelTimeInSeconds: route.duration.inMilliseconds,
                  lengthInMeters: route.lengthInMeters),
              waypoints,
              nextElement == locationList.last);
        } else {
          var error = routingError.name;
          print("CurrentItem -> ${error.toString()}");
          onRouteDetailsError.call(
            routingError.name,
            routingError.toString(),
          );
        }
      });
    }
    return null;
  }

  void _logRouteViolations(here.Route route) {
    for (var section in route.sections) {
      for (var notice in section.sectionNotices) {
        print("This route contains the following warning: " +
            notice.code.toString());
      }
    }
  }

  void clearMap() {
    for (var mapPolyline in _mapPolylines) {
      _hereMapController.mapScene.removeMapPolyline(mapPolyline);
    }
    _mapPolylines.clear();
  }

  void _logRouteSectionDetails(here.Route route) {
    DateFormat dateFormat = DateFormat().add_Hm();

    for (int i = 0; i < route.sections.length; i++) {
      Section section = route.sections.elementAt(i);

      print("Route Section : " + (i + 1).toString());
      print("Route Section Departure Time : " +
          dateFormat.format(section.departureTime!));
      print("Route Section Arrival Time : " +
          dateFormat.format(section.arrivalTime!));
      print(
          "Route Section length : " + section.lengthInMeters.toString() + " m");
      print("Route Section duration : " +
          section.duration.inSeconds.toString() +
          " s");
    }
  }

  String formatTime(int sec) {
    int hours = sec ~/ 3600;
    int minutes = (sec % 3600) ~/ 60;

    return '$hours:$minutes min';
  }

  String formatLength(int meters) {
    int kilometers = meters ~/ 1000;
    int remainingMeters = meters % 1000;

    return '$kilometers.$remainingMeters km';
  }

  _showRouteOnMap(here.Route route) {
    // Show route as polyline.
    GeoPolyline routeGeoPolyline = route.geometry;
    double widthInPixels = 5;
    MapPolyline routeMapPolyline =
        MapPolyline(routeGeoPolyline, widthInPixels, _lineColor);
    _hereMapController.mapScene.addMapPolyline(routeMapPolyline);
    _mapPolylines.add(routeMapPolyline);
  }

  GeoCoordinates _createRandomGeoCoordinatesInViewport() {
    GeoBox? geoBox = _hereMapController.camera.boundingBox;
    if (geoBox == null) {
      // Happens only when map is not fully covering the viewport.
      return GeoCoordinates(52.530932, 13.384915);
    }

    GeoCoordinates northEast = geoBox.northEastCorner;
    GeoCoordinates southWest = geoBox.southWestCorner;

    double minLat = southWest.latitude;
    double maxLat = northEast.latitude;
    double lat = _getRandom(minLat, maxLat);

    double minLon = southWest.longitude;
    double maxLon = northEast.longitude;
    double lon = _getRandom(minLon, maxLon);

    return GeoCoordinates(lat, lon);
  }

  double _getRandom(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  void toMyLocation() {
    _hereMapController.camera.flyTo(myLocation);
  }
}
