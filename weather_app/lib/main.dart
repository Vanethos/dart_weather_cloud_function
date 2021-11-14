import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_location.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = TextEditingController();

  Future<List<WeatherLocation>>? _searchWeather;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "City Name",
                icon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchWeather = searchWeather(_controller.text);
                    setState(() {});
                  },
                ),
              ),
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (field) {
                _searchWeather = searchWeather(field);
                setState(() {});
              },
            ),
            Expanded(
              child: FutureBuilder<List<WeatherLocation>>(
                future: _searchWeather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(child: Text("Search for a city"));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text("An error has occurred"));
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: snapshot.data!
                          .map((e) => SizedBox(
                                width: double.infinity,
                                child: Card(
                                  color: Colors.amber[50],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text("${e.location}, ${e.country}"),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                    e.epochTime * 1000)
                                                .toIso8601String()),
                                        const SizedBox(
                                          height: 8.0,
                                        ),
                                        Text(
                                            "Min: ${e.minimum}ºC, Max: ${e.maximum}ºC")
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<WeatherLocation>> searchWeather(String input) {
    return http
        .post(
            Uri.parse("https://X.a.run.app"),
            body: jsonEncode({'query': input}))
        .then((response) => jsonDecode(response.body) as Iterable)
        .then((json) =>
            json.map((value) => WeatherLocation.fromMap(value)).toList());
  }
}
