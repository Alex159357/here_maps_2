import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';

import '../../api/api_services.dart';
import '../../data/model/whether_data.dart';

class WhetherWidget extends StatelessWidget {
  const WhetherWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: FutureBuilder(
          future: ApiServices().getWhether(
              GeoCoordinates(34.04294776373491, -118.26619126684135)),
          builder:
              (BuildContext context, AsyncSnapshot<WhetherData?> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                width: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [ ///Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX12.3.sdk
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Text(
                        "${snapshot.data!.temp.toInt()}°",
                        style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Image.asset("assets/temp_c.png"),
                    )
                  ],
                ),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ));
  }
}
