import 'dart:convert';

Weather weatherFromMap(String str) => Weather.fromMap(json.decode(str));

String weatherToMap(Weather data) => json.encode(data.toMap());

class Weather {
    Weather({
        required this.dailyForecasts,
    });

    final List<DailyForecast> dailyForecasts;

    factory Weather.fromMap(Map<String, dynamic> json) => Weather(
        dailyForecasts: List<DailyForecast>.from(json["DailyForecasts"].map((x) => DailyForecast.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "DailyForecasts": List<dynamic>.from(dailyForecasts.map((x) => x.toMap())),
    };
}

class DailyForecast {
    DailyForecast({
        required this.date,
        required this.epochDate,
        required this.temperature,
    });

    final DateTime date;
    final int epochDate;
    final Temperature temperature;

    factory DailyForecast.fromMap(Map<String, dynamic> json) => DailyForecast(
        date: DateTime.parse(json["Date"]),
        epochDate: json["EpochDate"],
        temperature: Temperature.fromMap(json["Temperature"]),
    );

    Map<String, dynamic> toMap() => {
        "Date": date.toIso8601String(),
        "EpochDate": epochDate,
        "Temperature": temperature.toMap(),
    };
}

class Temperature {
    Temperature({
        required this.minimum,
        required this.maximum,
    });

    final Extremes minimum;
    final Extremes maximum;

    factory Temperature.fromMap(Map<String, dynamic> json) => Temperature(
        minimum: Extremes.fromMap(json["Minimum"]),
        maximum: Extremes.fromMap(json["Maximum"]),
    );

    Map<String, dynamic> toMap() => {
        "Minimum": minimum.toMap(),
        "Maximum": maximum.toMap(),
    };
}

class Extremes {
    Extremes({
        required this.value,
        required this.unit,
        required this.unitType,
    });

    final double value;
    final String unit;
    final int unitType;


    factory Extremes.fromMap(Map<String, dynamic> json) => Extremes(
        value: json["Value"],
        unit: json["Unit"],
        unitType: json["UnitType"],
    );

    Map<String, dynamic> toMap() => {
        "Value": value,
        "Unit": unit,
        "UnitType": unitType,
    };
}
