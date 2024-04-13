import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:airbnb_clone/routes.dart';
import 'package:airbnb_clone/screens/home_screen.dart';
import 'package:airbnb_clone/screens/signup_screen.dart';
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
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).user;
    return (user.token.isEmpty) ? HomeScreen() : SignUpScreen();
  }
}
