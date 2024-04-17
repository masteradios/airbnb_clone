import 'package:flutter_dotenv/flutter_dotenv.dart';
String url=dotenv.env['URL']!;

const logo = 'assets/logo.jpg';

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

const rules = '''
By clicking this button, I hereby acknowledge and agree to adhere to all terms, conditions, and regulations outlined by the owner.
''';
