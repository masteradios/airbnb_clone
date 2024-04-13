import 'package:airbnb_clone/constants.dart';
import 'package:airbnb_clone/models/user.dart';
import 'package:airbnb_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/showSnackBar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List pages = [
    SearchScreen(),
    Center(
      child: Text('Home'),
    ),
  ];

  int currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: openDrawer(context: context),
      appBar: buildAppBar(),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home')
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

class SearchScreen extends StatelessWidget {
  SearchScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Hero(
            tag: 'Search',
            child: Material(
                borderRadius: BorderRadius.circular(30),
                elevation: 20,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchScreeen();
                    }));
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Where to?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Anywhere'),
                          Text('Anytime'),
                          Text('Add Guests'),
                        ],
                      )
                    ],
                  ),
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 35,
                  ),
                )),
          ),
        )
      ],
    );
  }
}

class SearchScreeen extends StatefulWidget {
  SearchScreeen({
    super.key,
  });

  @override
  State<SearchScreeen> createState() => _SearchScreeenState();
}

class _SearchScreeenState extends State<SearchScreeen> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Stays',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (_currentIndex == 0)
                        Positioned(
                          bottom: 2, // Adjust as needed
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4, // Adjust the height as needed
                            color: Colors.black, // Adjust the color as needed
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Experiences',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      if (_currentIndex == 1)
                        Positioned(
                          bottom: 2, // Adjust as needed
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4, // Adjust the height as needed
                            color: Colors.black, // Adjust the color as needed
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Hero(
                tag: 'Search',
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 20,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    height: 350,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Where to?',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                        ),
                        TextFormField(
                          // to trigger disabledBorder
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.black)),
                            hintText: "Search destinations",
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 25,
                            ),
                            hintStyle: TextStyle(
                                fontSize: 16, color: Color(0xFFB3B1B1)),
                          ),
                        ),
                        Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: worldMapsName.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width:
                                              120, // Adjust the width as needed
                                          height:
                                              100, // Adjust the height as needed
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.asset(
                                              worldMapsImages[
                                                  index], // Replace with your image URL
                                              fit: BoxFit.fill,
                                              height:
                                                  50, // Adjust the fit as needed
                                            ),
                                          ),
                                        ),
                                        Text(
                                          worldMapsName[index],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                }))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
      automaticallyImplyLeading: false,
      actions: [buildActionForAppBar()],
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
