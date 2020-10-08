import 'package:equatable/equatable.dart';

import '../data/model/weather.dart';

abstract class WeatherState extends Equatable {
  WeatherState();
}

class WeatherInitial extends WeatherState {
  WeatherInitial();

  @override
  List<Object> get props => [];
}

class WeatherLoading extends WeatherState {
  WeatherLoading();

  @override
  List<Object> get props => [];
}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  WeatherLoaded(this.weather);

  @override
  List<Object> get props => [weather];
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
