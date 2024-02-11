import 'package:airbnb_clone/screens/home_screen.dart';
import 'package:airbnb_clone/screens/login_screen.dart';
import 'package:airbnb_clone/screens/signup_screen.dart';
import 'package:flutter/material.dart';

MaterialPageRoute getRoutes({required RouteSettings routeSettings}) {
  switch (routeSettings.name) {
    case SignUpScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return SignUpScreen();
      });
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return LoginScreen();
      });
    case HomeScreen.routeName:
      return MaterialPageRoute(builder: (context) {
        return HomeScreen();
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
