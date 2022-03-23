import 'package:expandable_bottom_bar/expandable_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:here_maps_test/ui/theme/app_theme.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';

import 'ui/screens/main/main_screen.dart';

void main() {
  SdkContext.init(IsolateOrigin.main);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppTheme().lightTheme,
      debugShowCheckedModeBanner: false,
      home: DefaultBottomBarController(
        child: const MainScreen(),
      ),
    );
  }


}