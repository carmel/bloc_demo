import 'dart:async';

import 'package:bloc_demo/meta_weather_api/meta_weather_api_client.dart';
import 'package:bloc_demo/meta_weather_api/models/weather.dart' hide Weather;
import 'package:bloc_demo/weather_repository/models/weather.dart';

class WeatherFailure implements Exception {}

class WeatherRepository {
  WeatherRepository({MetaWeatherApiClient? weatherApiClient})
      : _weatherApiClient = weatherApiClient ?? MetaWeatherApiClient();

  final MetaWeatherApiClient _weatherApiClient;

  Future<Weather> getWeather(String city) async {
    final location = await _weatherApiClient.locationSearch(city);
    final woeid = location.woeid;
    final weather = await _weatherApiClient.getWeather(woeid);
    return Weather(
      temperature: weather.theTemp,
      location: location.title,
      condition: weather.weatherStateAbbr.toCondition,
    );
  }
}

extension on WeatherState {
  WeatherCondition get toCondition {
    switch (this) {
      case WeatherState.clear:
        return WeatherCondition.clear;
      case WeatherState.snow:
      case WeatherState.sleet:
      case WeatherState.hail:
        return WeatherCondition.snowy;
      case WeatherState.thunderstorm:
      case WeatherState.heavyRain:
      case WeatherState.lightRain:
      case WeatherState.showers:
        return WeatherCondition.rainy;
      case WeatherState.heavyCloud:
      case WeatherState.lightCloud:
        return WeatherCondition.cloudy;
      default:
        return WeatherCondition.unknown;
    }
  }
}
