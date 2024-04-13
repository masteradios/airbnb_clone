import 'package:airbnb_clone/screens/chatScreen.dart';
import 'package:airbnb_clone/screens/exploreScreen.dart';
import 'package:flutter/material.dart';

const url = 'http://192.168.0.105:3000';
const logo = 'assets/logo.jpg';

List pages = [
  ExploreScreen(),
  Center(
    child: Text('Wishlists'),
  ),
  Center(
    child: Text('Trips'),
  ),
  ChatScreen(),
  Center(
    child: Text('Home'),
  ),
];

const List<String> worldMapsImages = [
  'assets/world.jpg',
  'assets/america.png',
  'assets/africa.png',
  'assets/europe.png',
  'assets/middleEast.jpg',
  'assets/italy.jpg'
];

const List<String> worldMapsName = [
  'World',
  'America',
  'Africa',
  'Europe',
  'Middle East',
  'Italy'
];
