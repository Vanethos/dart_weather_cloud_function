import 'dart:convert';

import 'package:functions_framework/functions_framework.dart';
import 'package:shelf/shelf.dart';
import 'package:http/http.dart' as http;
import 'package:weather_service/keys.dart';
import 'package:weather_service/models/location.dart';
import 'package:weather_service/models/weather.dart';
import 'package:weather_service/models/weather_location.dart';

@CloudFunction()
Future<Response> function(Request request) async {
  final queryBody = await request.readAsString();
  final query = jsonDecode(queryBody)['query'];
  final searchUri = Uri.parse(
      "http://dataservice.accuweather.com/locations/v1/cities/search?apikey=$weatherApiKey&q=$query");
  final cities = await http
      .get(searchUri)
      .then((response) =>
        jsonDecode(response.body) as Iterable
      )
      .then((locations) => locations.map((value) => Location.fromMap(value)))
      .then((list) => list.take(3));

  if (cities.isEmpty) {
    return Response.ok("{}");
  }

  final List<WeatherLocation> result = <WeatherLocation>[];

  for (var city in cities) {
    final weatherSearch = Uri.parse(
        'http://dataservice.accuweather.com//forecasts/v1/daily/1day/${city.key}?apikey=$weatherApiKey&metric=true');
    final weather = await http
        .get(weatherSearch)
        .then((response) => jsonDecode(response.body))
        .then((weather) => Weather.fromMap(weather));

    result.add(
      WeatherLocation(
        epochTime: weather.dailyForecasts.first.epochDate,
        location: city.localizedName,
        country: city.region.englishName,
        maximum: weather.dailyForecasts.first.temperature.maximum.value,
        minimum: weather.dailyForecasts.first.temperature.minimum.value,
      ),
    );
  }

  final resultMap = result.map((location) => location.toMap()).toList();

  return Response.ok(jsonEncode(resultMap));
}
