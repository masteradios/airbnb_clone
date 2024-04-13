import 'package:airbnb_clone/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
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
