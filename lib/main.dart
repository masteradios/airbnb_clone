import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:airbnb_clone/routes.dart';
import 'package:airbnb_clone/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          iconTheme: IconThemeData(color: Colors.black),
          useMaterial3: true,
        ),
        onGenerateRoute: (settings) => getRoutes(routeSettings: settings),
        home: HomeScreen(),
      ),
    );
  }
}
