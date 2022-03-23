import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:here_maps_test/api/api_services.dart';
import 'package:here_maps_test/data/model/LocationModel.dart';
import 'package:here_maps_test/data/model/whether_data.dart';
import 'package:here_maps_test/ui/screens/navigation/routing.dart';
import 'package:here_maps_test/ui/widgets/buttons/buttons.dart';
import 'package:here_maps_test/ui/widgets/info_toast.dart';
import 'package:here_maps_test/ui/widgets/map_view/map_view.dart';
import 'package:here_maps_test/ui/widgets/navigate_doalog.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart';
import 'package:intl/intl.dart';

import '../../../bloc/bloc/navigation_dialog/navigation_dialog_bloc.dart';
import '../../../bloc/events/navigation_dialog_event.dart';
import '../../../bloc/states/navigation_dialog/navigation_dialog_state.dart';
import '../../../data/model/rout_details.dart';

class NavigationScreen extends StatefulWidget {
  final List<LocationModel> locationList;

  NavigationScreen({Key? key, required this.locationList}) : super(key: key);

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  List<GeoCoordinates> coordinates = [];
  late HereMapController hereMapController;
  Routing? _routing;

  @override
  void initState() {
    widget.locationList.forEach((element) {
      print("ListOrder -> ${element.address.street}");
      coordinates
          .add(GeoCoordinates(element.geometry.lat, element.geometry.lon));
    });
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    return BlocProvider(
      create: (BuildContext context) => NavigationDialogBloc(NavigationDialogStateInitial()),
      child: BlocConsumer<NavigationDialogBloc, NavigationDialogState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) async {
            if(state is NavigationDialogStateNavigate){

              await _routing!.placeWidgets(state.model, widget.locationList.indexOf(state.model));
               await _routing!.addRoute(state.waypoints);
               await _routing!.getRouteDetail(lastModel: state.model);

            }else if(state is NavigationDialogStateCloseDialog){

              // await _routingExample!.placeWidgets(state.model, widget.locationList.indexOf(state.model));
              await _routing!.getRouteDetail(lastModel: state.model);
            }
          },
          buildWhen: (previous, current) => false,
          builder: (context, state) {
            return Scaffold(
              body: Stack(
                children: [
                  HereMap(onMapCreated: (controller)=> _onMapCreated(controller, context)),
                  Positioned.fill(
                    top: 40,
                    right: 15,
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: InfoToast()
                    ),
                  ),
                  Positioned.fill(
                    top: -20,
                    right: 15,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          _routing!.toMyLocation();
                        },
                        child: Card(
                            elevation: 30,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/my_location.png",
                                width: 18,
                                height: 17,
                              ),
                            )),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    top: 70,
                    right: 15,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          if(_routing != null) {
                            _routing!.clearMap();
                             _routing!.toMyLocation();
                              _routing!.getRouteDetail(lastModel: widget.locationList[1]);
                              _routing!.onRouteDetailsReady =
                                  (model, routDetails, waypoints, isLast) {
                                context.read<NavigationDialogBloc>().add(NavigationDialogEventShowDialog(
                                    model: model,
                                    routDetails: routDetails,
                                    waypoints: waypoints,
                                    isLast: isLast,
                                    position: widget.locationList.indexOf(model)
                                ));
                              };
                            }
                          },
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/map.png",
                                width: 18,
                                height: 17,
                              ),
                            )),
                      ),
                    ),
                  ),
                  const Positioned.fill(
                    top: 70,
                    left: 15,
                    right: 15,
                    bottom: 35,
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: NavigateDialog()
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
    // return HereMap(onMapCreated: _onMapCreated);
  }

  void _onMapCreated(HereMapController hereMapController, BuildContext context) {
    hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
        (MapError? error) {
      if (error == null) {
        try {
          //Variables.myLocation
          _routing = Routing(
              hereMapController,
              GeoCoordinates(33.961573923652544, -118.2221621670418),
              Theme.of(context).primaryColor, widget.locationList);

          ///////
          if (mounted) {
            _routing!.placeWidgets(widget.locationList[0], 0);
            _routing!.getRouteDetail(lastModel:  widget.locationList[1]);
            _routing!.onRouteDetailsReady = (model, routDetails, waypoints, isLast) {
              context.read<NavigationDialogBloc>().add(NavigationDialogEventShowDialog(model: model, routDetails: routDetails, waypoints: waypoints, isLast: isLast, position: widget.locationList.indexOf(model)));
            };
            _routing!.onRouteDetailsError = (title, message) {
              _showErrorDialog(title, message);
            };
          }

          //////
          // _showDialogN();
          // _showDialog(widget.locationList[1], 1).then((value) {});

        } on InstantiationException {
          throw ("Initialization of RoutingEngine failed.");
        }
      } else {
        print("Map scene not loaded. MapError: " + error.toString());
      }
    });
  }

  void _showDialogN() async {
    if (mounted) {
      _routing!.placeWidgets(widget.locationList[0], 0);
      _routing!.getRouteDetail(lastModel: widget.locationList[1]);
      _routing!.onRouteDetailsReady = (model, routDetails, waypoints, isLast) {
        if (model != widget.locationList[0]) {
          _routing!
              .placeWidgets(model, widget.locationList.indexOf(model));
        }
        _showDialog(model, widget.locationList.indexOf(model), routDetails, waypoints, isLast)
            .then((value) {
          if (value != null) {
            _routing!.getRouteDetail(lastModel: value);
          }
        });
      };
      _routing!.onRouteDetailsError = (title, message) {
        _showErrorDialog(title, message);
      };
    }
  }

  Future<void> _showErrorDialog(String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Okay"))
          ],
        );
      },
    );
  }

  Future<LocationModel?> _showDialog(LocationModel model, int position,
      RoutDetails routDetails, List<Waypoint> waypoints, bool isLast) async {
    var drop = DateTime.now()
        .add(Duration(seconds: routDetails.estimatedTravelTimeInSeconds));
    var dropTime = DateFormat('hh:mm a').format(drop);
    return showModalBottomSheet<LocationModel>(
        barrierColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        isDismissible: true,
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 160,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          model.type == "home"
                              ? Image.asset(
                                  "assets/home.png",
                                  width: 40,
                                  height: 40,
                                )
                              : model.type == "current"
                                  ? Image.asset(
                                      "assets/location.png",
                                      width: 40,
                                      height: 40,
                                    )
                                  : Container(
                                      decoration: const BoxDecoration(
                                          color: Color(0xFFEBE9FF),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 7, horizontal: 11),
                                      margin: const EdgeInsets.only(right: 22),
                                      child: Text(
                                        "$position",
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(model.address.street,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    fontSize: 20,
                                                  )),
                                          model.type == "home" ||
                                                  model.type == "current"
                                              ? Container()
                                              : Text(
                                                  "${model.address.city}, ${model.address.state}, ${model.address.zip}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall!),
                                        ],
                                      ),
                                    ),
                                    Image.asset("assets/more.png")
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 1, color: Theme.of(context).dividerColor),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            dropTime,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 13),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: 4,
                            height: 4,
                            decoration: const BoxDecoration(
                                color: Color(0xFFC4C4C4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100))),
                          ),
                          Text(
                            "Pickup",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w100,
                                    fontSize: 13),
                          ),
                          !isLast
                              ? Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFC4C4C4),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(100))),
                                )
                              : Container(),
                          !isLast
                              ? Text(
                                  "Dropoff",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w100,
                                          fontSize: 13),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                        width: 320.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Buttons().buttonCancel(
                                  context: context,
                                  onClick: () {
                                    Navigator.of(context).pop(model);
                                  },
                                  text: "Done".toUpperCase()),
                              Buttons().primaryButton(
                                  context: context,
                                  onClick: () {
                                    _routing!.addRoute(waypoints);
                                    Navigator.of(context).pop(model);
                                  },
                                  text: "Navigate")
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

}
