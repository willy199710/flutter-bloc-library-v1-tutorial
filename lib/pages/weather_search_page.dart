import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/model/weather.dart';
import '../notifiers/weather_state.dart';
import '../notifiers/weather_state_notifier.dart';
import 'weather_detail_page.dart';

final weatherStateNotifierProvider =
    StateNotifierProvider<WeatherStateNotifier, WeatherState>(
        (ref) => WeatherStateNotifier(ref));

class WeatherSearchPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(weatherStateNotifierProvider, (previous, WeatherState next) {
      if (next is WeatherError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
          ),
        );
      }
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(weatherStateNotifierProvider);

            if (state is WeatherInitial) {
              return buildInitialInput();
            } else if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(context, state.weather);
            } else if (state is WeatherError) {
              return buildInitialInput();
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
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
          // Display the temperature with 1 decimal place
          "${weather.temperatureCelsius.toStringAsFixed(1)} °C",
          style: TextStyle(fontSize: 80),
        ),
        ElevatedButton(
          child: Text('See Details'),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.lightBlue[100]),
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => WeatherDetailPage(masterWeather: weather),
              ),
            );
          },
        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(ref, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(WidgetRef ref, String cityName) {
    ref.read(weatherStateNotifierProvider.notifier).getWeather(cityName);
  }
}
