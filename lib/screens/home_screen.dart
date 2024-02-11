import 'package:flutter/material.dart';

import '../widgets/showSnackBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: openDrawer(context: context),
      appBar: buildAppBar(),
      body: Center(
        child: TextButton(
            onPressed: () {
              displaySnackBar(content: 'content', context: context);
            },
            child: Text('Home')),
      ),
    );
  }
}

AppBar buildAppBar() {
  return AppBar(
      automaticallyImplyLeading: false,
      actions: [buildActionforAppBar()],
      title: buildTitleforAppBar());
}

Widget buildActionforAppBar() {
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
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
                height: 30,
                width: 30,
                child: Image.asset(
                  'assets/paper.png',
                  fit: BoxFit.contain,
                )),
            const SizedBox(
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
