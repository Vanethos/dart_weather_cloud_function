import 'dart:convert';

class WeatherLocation {
  final String location;
  final String country;
  final int epochTime;
  final double maximum;
  final double minimum;

  WeatherLocation({
    required this.location,
    required this.country,
    required this.maximum,
    required this.minimum,
    required this.epochTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'country': country,
      'epochTime': epochTime,
      'maximum': maximum,
      'minimum': minimum,
    };
  }

  String toJson() => json.encode(toMap());

  factory WeatherLocation.fromMap(Map<String, dynamic> map) {
    return WeatherLocation(
      location: map['location'],
      country: map['country'],
      epochTime: map['epochTime'],
      maximum: map['maximum'],
      minimum: map['minimum'],
    );
  }

  factory WeatherLocation.fromJson(String source) => WeatherLocation.fromMap(json.decode(source));
}
