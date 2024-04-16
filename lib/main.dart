import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/providers/date_provider.dart';
import 'package:airbnb_clone/providers/guestCount_provider.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:airbnb_clone/routes.dart';
import 'package:airbnb_clone/screens/home_screen.dart';
import 'package:airbnb_clone/screens/signup_screen.dart';
import 'package:airbnb_clone/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DateProvider()),
        ChangeNotifierProvider(create: (_) => GuestCountProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          iconTheme: IconThemeData(color: Colors.black),
          useMaterial3: true,
        ),
        builder: (context, child) => Stack(
          children: [
            child!,
            DropdownAlert(
              position: AlertPosition.TOP,
              errorBackground: Colors.red,
              titleStyle: GoogleFonts.poppins(fontSize: 20),
              contentStyle: GoogleFonts.poppins(fontSize: 18),
            )
          ],
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
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    setState(() {
      isLoading = true;
    });
    await AuthService().validateToken(context: context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ModelUser _user = Provider.of<UserProvider>(context).user;
    return (isLoading)
        ? Center(
            child: Lottie.asset('assets/animations/dots.json'),
          )
        : (_user.token.isNotEmpty)
            ? HomeScreen()
            : SignUpScreen();
  }
}
