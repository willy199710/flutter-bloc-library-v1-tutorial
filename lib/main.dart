import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'pages/weather_search_page.dart';

void main() => runApp(ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: WeatherSearchPage(),
    );
  }
}
