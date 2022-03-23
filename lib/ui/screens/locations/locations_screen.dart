import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:here_maps_test/api/api_services.dart';
import 'package:here_maps_test/bloc/bloc/locations/locations_list_bloc.dart';
import 'package:here_maps_test/bloc/events/location/location_search_event.dart';
import 'package:here_maps_test/bloc/states/location/location_search_state.dart';
import 'package:here_maps_test/helpers/location_helper.dart';
import 'package:here_maps_test/ui/screens/navigation/navigation_screen.dart';

import '../../../bloc/bloc/locations/location_search_bloc.dart';
import '../../../bloc/events/location/location_list_vent.dart';
import '../../../bloc/states/location/location_list_event.dart';
import '../../widgets/buttons/buttons.dart';
import '../../widgets/list/dragable_list.dart';




class LocationsScreen extends StatelessWidget {
  const LocationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
    ));
    return Hero(
      tag: "search_for_location",
      child: BlocProvider(
        create: (context) {
          return LocationListBloc(
            locationHelper: LocationHelper(),
              apiServices: ApiServices(),
              initialState: InitLocationListState());
        },
        child: BlocBuilder<LocationListBloc, LocationListState>(
          builder: (context, state) {
            if (state is InitLocationListState) {
              context.read<LocationListBloc>().add(StartLoadListEvent());
            }
            if (state is LocationLoadedState) {
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: const Text("Create Orders."),
                    foregroundColor: Theme.of(context).textTheme.titleMedium!.color,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    bottom: PreferredSize(
                        child: Container(
                          color: Theme.of(context).dividerColor,
                          height: 1.0,
                        ),
                        preferredSize: const Size.fromHeight(1.0)),
                  ),
                  body: BlocProvider(
                    create: (BuildContext context)=> LocationSearchBloc(),
                    child: Container(
                      margin: const EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          searchField,
                          Expanded(
                            child: DraggableList(
                              list: state.locationList,
                              onListOrderChanged: (v){},
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 22, right: 22, bottom: 32),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Buttons().buttonCancel(context: context, text: "DISCARD", onClick: (){
                                  Navigator.of(context).pop();
                                } ),
                              Buttons().primaryButton(context: context, text: "Optimize", icon: Image.asset("assets/rocket.png"), onClick: (){
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return NavigationScreen( locationList: state.locationList,);
                                    }));
                              }),
                            ],),
                          )
                        ],
                      ),
                    ),
                  ));
            } else {
              return Scaffold(
                body: Center(
                  child: Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget get searchField => BlocBuilder<LocationSearchBloc, LocationSearchState>(
    builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 3,
              offset: Offset(
                1.0,
                1.5,
              ),
            )
          ],
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(7),
        margin: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 10),
        child: Container(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFF5F5F5),
                  ),
                  child: TextFormField(
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      onChanged: (v)=> context.read<LocationSearchBloc>().add(LocationSearchEventOnQueryEdit(v)),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 15),
                        // add padding to adjust text
                        isDense: true,
                        border: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Email",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: Icon(
                            Icons.search,
                            color: Color(0xFF424242),
                          ),
                        ),
                      )),
                ),
              ),
              Container(
                width: 6,
              ),
              ClipOval(
                child: Container(
                    padding: const EdgeInsets.all(12),
                    color: const Color(0xFFEBE9FF),
                    child: Image.asset('assets/camera_icon.png')),
              ),
            ],
          ),
        ),
      );
    },
  );
}
