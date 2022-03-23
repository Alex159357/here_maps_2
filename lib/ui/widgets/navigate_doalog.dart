

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/bloc/navigation_dialog/navigation_dialog_bloc.dart';
import '../../bloc/events/navigation_dialog_event.dart';
import '../../bloc/states/navigation_dialog/navigation_dialog_state.dart';
import 'buttons/buttons.dart';

class NavigateDialog extends StatelessWidget {
  const NavigateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationDialogBloc, NavigationDialogState>(builder: (BuildContext context, state) {
      if(state is NavigationDialogStateShowDialog) {
        var drop = DateTime.now()
            .add(Duration(seconds: state.routDetails.estimatedTravelTimeInSeconds));
        var dropTime = DateFormat('hh:mm a').format(drop);
        return Card(
          elevation: 30,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              height: 170,
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
                            state.model.type == "home"
                                ? Image.asset(
                              "assets/home.png",
                              width: 40,
                              height: 40,
                            )
                                : state.model.type == "current"
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
                                "${state.position}",
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
                                            Text(state.model.address.street,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                  fontSize: 20,
                                                )),
                                            state.model.type == "home" ||
                                                state.model.type == "current"
                                                ? Container()
                                                : Text(
                                                "${state.model.address.city}, ${state.model.address.state}, ${state.model.address.zip}",
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
                            !state.isLast
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
                            !state.isLast
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
                                Buttons().buttonUsual(
                                  icon: Image.asset("assets/checkmark.png"),
                                    context: context,
                                    onClick: () {
                                      context.read<NavigationDialogBloc>().add(NavigationDialogEventCloseDialog(model: state.model));
                                      // Navigator.of(context).pop(model);
                                    },
                                    text: "Done".toUpperCase()),
                                Buttons().primaryButton(
                                    context: context,
                                    icon: Image.asset("assets/compass.png"),
                                    onClick: () {
                                      context.read<NavigationDialogBloc>().add(NavigationDialogEventNavigate(waypoints: state.waypoints ,model: state.model, routDetails: state.routDetails));
                                      // _routingExample!.addRoute(waypoints);
                                      // Navigator.of(context).pop(model);
                                    },
                                    text: "Navigate")
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            )
        );
      }else{
        return Container();
      }
    },
    );
  }
}
