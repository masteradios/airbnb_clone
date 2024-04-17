import 'dart:async';

import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:airbnb_clone/screens/user_trips_screen.dart';
import 'package:airbnb_clone/screens/wishlists_screen.dart';
import 'package:airbnb_clone/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../models/places.dart';
import '../services/place_services/getTenPlaces.dart';
import 'chatScreen.dart';
import 'exploreScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ModelPlace> modelPlaces = [];
  Position? position;
  bool _isLoading = false;
  Timer? timer;
  Future<void> fetchPlaceDetails() async {
    setState(() {
      _isLoading = true;
    });
    modelPlaces = await PlaceServices().getTopTenPlaces(context: context);
    position = await determinePosition();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPlaceDetails();
    startTimer();
  }

  void startTimer() {
    const duration = Duration(seconds: 4);
    timer = Timer.periodic(duration, (timer) {
      if (!_isLoading) {
        if (modelPlaces.isEmpty) {
          fetchPlaceDetails();
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).user;
    List pages = [
      (_isLoading)
          ? Center(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset('assets/animations/loading.json')),
            )
          : (modelPlaces.isEmpty)
              ? Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Lottie.asset('assets/animations/loading.json')),
                )
              : ExploreScreen(
                  modelPlaces: modelPlaces,
                  position: position!,
                ),
      WishListsScreen(user: user),
      MyTrips(user: user),
      ChatScreen(),
      Center(
        child: Text('Home'),
      ),
    ];
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: Colors.white,
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Wishlists'),
          BottomNavigationBarItem(
              icon: Image.asset(
                'assets/paper.png',
                height: 22,
                color: (currentIndex == 2) ? Colors.redAccent : Colors.grey,
              ),
              label: 'Trips'),
          BottomNavigationBarItem(
              icon: Icon(Icons.messenger_outline), label: 'Inbox'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile')
        ],
        currentIndex: currentIndex,
        activeColor: Colors.redAccent,
        onTap: (newVal) {
          setState(() {
            currentIndex = newVal;
          });
        },
      ),
      body: pages[currentIndex],
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: buildTitleforAppBar());
}

Widget buildActionForAppBar() {
  return Builder(builder: (ctx) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            side: BorderSide(width: 1, color: Colors.grey)),
        onPressed: () {
          Scaffold.of(ctx).openEndDrawer();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Image.asset(
                'assets/drawer.png',
                height: 15,
              ),
            ),
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  });
}

Widget buildTitleforAppBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                child: Image.asset(
                  'assets/paper.png',
                  fit: BoxFit.contain,
                )),
            SizedBox(
              width: 5,
            ),
            Text(
              'airbnb',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ),
      Expanded(child: SizedBox()),
    ],
  );
}
