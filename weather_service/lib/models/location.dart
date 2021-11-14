class Location {
  Location({
    required this.key,
    required this.localizedName,
    required this.region,
  });

  final String key;
  final String localizedName;
  final Country region;

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        key: json["Key"],
        localizedName: json["LocalizedName"],
        region: Country.fromMap(json["Country"]),
      );
}

class Country {
  Country({
    required this.id,
    required this.localizedName,
    required this.englishName,
  });

  final String id;
  final String localizedName;
  final String englishName;

  factory Country.fromMap(Map<String, dynamic> json) => Country(
        id: json["ID"],
        localizedName: json["LocalizedName"],
        englishName: json["EnglishName"],
      );
}
