import 'package:airbnb_clone/screens/login_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute getRoutes({required RouteSettings routeSettings}) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return LoginScreen();
      });
    default:
      return MaterialPageRoute(builder: (context) {
        return Scaffold(
          body: Center(
            child: Text('No such route'),
          ),
        );
      });
  }
}
