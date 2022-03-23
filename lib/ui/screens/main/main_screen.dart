import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_maps_test/bloc/cubit/main/main_cubit.dart';
import 'package:here_maps_test/helpers/location_helper.dart';
import 'package:here_maps_test/ui/screens/locations/locations_screen.dart';
import 'package:here_maps_test/ui/widgets/map_view/map_view.dart';
import 'package:here_maps_test/variables.dart';

import '../../../bloc/cubit/main/screen.dart';
import '../history/history_screen.dart';
import '../navigation/map_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  Future<LocationPermission> _getPermissions() async{
    LocationPermission permission;
    // Variables.myLocation = await LocationHelper().getLocation();
    return await Geolocator.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
    ));
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: FutureBuilder(
          future: _getPermissions(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData && (snapshot.data == LocationPermission.always || snapshot.data == LocationPermission.whileInUse)){
              return _bodyWrapper(context);
            }else return Scaffold(
              backgroundColor: Colors.red,
              body: Text("No permission granted :("),
            );
          }else {
            return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            body: Center(child: Text("")),
          );
          }
        },),
      ),
    );
  }

  Widget _bodyWrapper(BuildContext context){
    return BlocProvider(
        create: (BuildContext context) => MainCubit(),
        child: Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            extendBody: true,
            appBar: _appbar(context),
            floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GestureDetector(
                onVerticalDragUpdate:
                DefaultBottomBarController.of(context).onDrag,
                onVerticalDragEnd:
                DefaultBottomBarController.of(context).onDragEnd,
                child: _fab),
            bottomNavigationBar: BottomExpandableAppBar(
              horizontalMargin: 16,
              bottomAppBarBody: Padding(
                  padding: const EdgeInsets.all(8.0), child: _bottomMenu),
            ),
            body: Container(
                margin: const EdgeInsets.only(top: 20), child: _body)));
  }

  Widget get _bottomMenu =>
      BlocBuilder<MainCubit, Screens>(builder: (context, screen) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: InkWell(
                  onTap: () =>
                      context.read<MainCubit>().onAction(Screens.HISTORY),
                  child: _getMnuItem(
                      title: "History",
                      icon: "assets/сlock.png",
                      context: context)),
            ),
            screen == Screens.MAP
                ? const Spacer(
                    flex: 2,
                  )
                : Expanded(
                    child: InkWell(
                        onTap: () =>
                            context.read<MainCubit>().onAction(Screens.MAP),
                        child: _getMnuItem(
                            title: "History",
                            icon: "assets/сlock.png",
                            context: context)),
                  ),
            Expanded(
                child: _getMnuItem(
                    title: "Profile",
                    icon: "assets/user.png",
                    context: context)),
          ],
        );
      });

  Widget get _body => BlocBuilder<MainCubit, Screens>(
        builder: (context, screen) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: screen == Screens.PROFILE
                ? MapView(mapTypeFlow: MapTypeFlow.ONLY_MY_LOCATION,)
                : screen == Screens.HISTORY
                    ? HistoryScreen()
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FutureBuilder(
                          future: LocationHelper().getLocation(),
                          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                          if(snapshot.connectionState == ConnectionState.done){
                            return MapScreen(position: snapshot.data,);
                          }else {
                            return const Center(child: CircularProgressIndicator(),);
                          }
                        },)),
          );
        },
      );

  Widget _getMnuItem(
          {required String title,
          required String icon,
          required BuildContext context}) =>
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: SizedBox(
                width: 18, height: 18, child: Image.asset(icon)),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      );

  Widget get _fab => BlocBuilder<MainCubit, Screens>(builder: (context, screen) {
        return screen == Screens.MAP
            ? Container(
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2.0,
                      spreadRadius: 0.01,
                      offset: Offset(
                        0.0,
                        -2.5,
                      ),
                    )
                  ],
                  color: Colors.white,
                ),
                padding: const EdgeInsets.all(7),
                child: FloatingActionButton.extended(
                  label: const Text("START A ROUTE"),
                  elevation: 2,
                  heroTag: "search_for_location",
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const LocationsScreen();
                    })).then((value){
                      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
                        statusBarBrightness: Brightness.dark,
                        statusBarColor: Colors.transparent,
                      ));
                    });
                  },
                ),
              )
            : Container();
      });

  AppBar _appbar(BuildContext context) => AppBar(
        elevation: 0,
        title: Text("Plan", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        bottom: PreferredSize(
            child: Text(
              "Add orders and plan your route",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            preferredSize: Size(1, 1)),
        backgroundColor: Theme.of(context).primaryColor,
      );
}
