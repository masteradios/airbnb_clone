import 'package:airbnb_clone/screens/searchScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/buildShimmer.dart';

class ImageDetails {
  final String name;
  final String imageUrl;

  ImageDetails({required this.name, required this.imageUrl});
}

class ExploreScreen extends StatefulWidget {
  ExploreScreen({
    super.key,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Future<ImageDetails> fetchImageDetails() async {
    // Simulate fetching image details from an API
    // Replace this with your actual API call
    // For simplicity, using a delayed Future
    await Future.delayed(Duration(seconds: 1));

    return ImageDetails(
      name: "Example Image",
      imageUrl: "assets/signupimage.png",
    );
  }

  double value = 0;

  @override
  Widget build(BuildContext context) {
    ModelUser user = Provider.of<UserProvider>(context).user;
    return Column(
      children: [
        buildSearchTile(),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: fetchImageDetails(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show shimmer effect while waiting for image details
                      return BuildShimmer();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Show image once image details are fetched
                      return buildPlaceTile();
                    }
                  });
            },
            itemCount: 4,
          ),
        )
      ],
    );
  }
}

class buildPlaceTile extends StatelessWidget {
  const buildPlaceTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/signupimage.png'),
                  fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Place',
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.redAccent,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '5.0',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '1242 km away',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )
            ],
          )
        ],
      ),
    );
  }
}

class buildSearchTile extends StatelessWidget {
  const buildSearchTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Material(
          borderRadius: BorderRadius.circular(30),
          elevation: 20,
          child: ListTile(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SearchScreen();
              }));
            },
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Where to?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
    );
  }
}
