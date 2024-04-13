import 'package:airbnb_clone/constants.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBackButton(),
            buildSearchCard(),
          ],
        ),
      ),
    );
  }
}

class buildSearchCard extends StatelessWidget {
  const buildSearchCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
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
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    )),
              ),
              buildSearchTextField(),
              Expanded(child: buildMaps())
            ],
          ),
        ),
      ),
    );
  }
}

class buildMaps extends StatelessWidget {
  const buildMaps({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: worldMapsName.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120, // Adjust the width as needed
                  height: 100, // Adjust the height as needed
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      worldMapsImages[index], // Replace with your image URL
                      fit: BoxFit.fill,
                      height: 50, // Adjust the fit as needed
                    ),
                  ),
                ),
                Text(
                  worldMapsName[index],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        });
  }
}

class buildSearchTextField extends StatelessWidget {
  const buildSearchTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // to trigger disabledBorder
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: Colors.grey),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 1, color: Colors.black)),
        hintText: "Search destinations",
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black,
          size: 25,
        ),
        hintStyle: TextStyle(fontSize: 16, color: Color(0xFFB3B1B1)),
      ),
    );
  }
}

class buildBackButton extends StatelessWidget {
  const buildBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios)),
    );
  }
}
