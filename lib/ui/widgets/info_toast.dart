import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:here_maps_test/data/model/rout_details.dart';
import 'package:here_sdk/core.dart';

import '../../api/api_services.dart';
import '../../bloc/bloc/navigation_dialog/navigation_dialog_bloc.dart';
import '../../bloc/states/navigation_dialog/navigation_dialog_state.dart';
import '../../data/model/whether_data.dart';
import 'whether.dart';


class InfoToast extends StatelessWidget {
  const InfoToast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int stepsCount = 0;
    int estimatedTravelTimeInSeconds = 0;
    int lengthInMeters = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        BlocBuilder<NavigationDialogBloc, NavigationDialogState>(builder: (BuildContext context, state) {
          if(state is NavigationDialogStateNavigate){
            stepsCount ++;
            estimatedTravelTimeInSeconds += state.routDetails.estimatedTravelTimeInSeconds;
            lengthInMeters += state.routDetails.lengthInMeters;
          }
            return estimatedTravelTimeInSeconds > 0 && lengthInMeters > 0? InfoToastBody(stopsCount: stepsCount, timeSeconds: estimatedTravelTimeInSeconds, routeMils: lengthInMeters): Container();
        },),
        const WhetherWidget()
      ],
    );
  }
}


class InfoToastBody extends StatefulWidget {
  final int stopsCount;
  final int timeSeconds;
  final int routeMils;

  const InfoToastBody({required this.stopsCount, required this.timeSeconds, required this.routeMils, Key? key}) : super(key: key);
  @override
  State<InfoToastBody> createState() => _InfoToastBodyState();
}

class _InfoToastBodyState extends State<InfoToastBody> {
  static late bool isShown;
  @override
  void initState() {
    isShown = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.fromMicrosecondsSinceEpoch(widget.timeSeconds * 1000);
    return isShown?  Card(
      shadowColor: Theme.of(context).primaryColor,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${widget.stopsCount} Stops"),
            Text("${time.hour} hrs ${time.minute} mins"),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                  color: Color(0xFFC4C4C4),
                  borderRadius:
                  BorderRadius.all(Radius.circular(100))),
            ),
            Text("${widget.routeMils ~/ 1609.344} mi"),
            GestureDetector(
              onTap: (){
                setState(() {
                  isShown = false;
                });
              },
              child: ClipOval(
                child: Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.black26,
                    child: Image.asset("assets/x.png")
                ),
              ),
            )
          ],
        ),
      ),
    ) : Container();
  }
}


