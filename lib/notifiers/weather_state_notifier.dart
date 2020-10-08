import 'package:flutter_riverpod/all.dart';

import '../data/weather_repository.dart';
import 'weather_state.dart';

class WeatherStateNotifier extends StateNotifier<WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherStateNotifier(ProviderReference ref)
      : weatherRepository = ref.read(fakeWeatherRepositoryProvider),
        super(WeatherInitial());

  void getWeather(String cityName) async {
    state = WeatherLoading();

    try {
      final weather = await weatherRepository.fetchWeather(cityName);
      state = WeatherLoaded(weather);
    } on NetworkError {
      state = WeatherError("Couldn't fetch weather. Is the device online?");
    }
  }

  void getDetailedWeather(String cityName) async {
    state = WeatherLoading();

    try {
      final weather = await weatherRepository.fetchDetailedWeather(cityName);
      state = WeatherLoaded(weather);
    } on NetworkError {
      state = WeatherError("Couldn't fetch weather. Is the device online?");
    }
  }
}
