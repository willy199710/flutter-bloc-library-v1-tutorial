import 'package:flutter/material.dart';
import 'package:flutter_bloc_v1_tutorial/notifiers/weather_state.dart';
import 'package:flutter_bloc_v1_tutorial/pages/weather_search_page.dart';
import 'package:flutter_riverpod/all.dart';

import '../data/model/weather.dart';

class WeatherDetailPage extends StatefulWidget {
  final Weather masterWeather;

  const WeatherDetailPage({
    Key key,
    @required this.masterWeather,
  }) : super(key: key);

  @override
  _WeatherDetailPageState createState() => _WeatherDetailPageState();
}

class _WeatherDetailPageState extends State<WeatherDetailPage> {
  @override
  void didChangeDependencies() {
    context
        .read(weatherStateNotifierProvider)
        .getDetailedWeather(widget.masterWeather.cityName);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Detail"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Consumer(
          // ignore: missing_return
          builder: (_, watch, child) {
            final state = watch(weatherStateNotifierProvider.state);

            if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(context, state.weather);
            }
          },
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(BuildContext context, Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the Celsius temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        Text(
          // Display the Fahrenheit temperature with 1 decimal place
          "${weather.temperatureFahrenheit?.toStringAsFixed(1)} °F",
          style: TextStyle(fontSize: 80),
        ),
      ],
    );
  }
}
