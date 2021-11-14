# Google Cloud Function Example with Dart

In this example we make a simple request to AccuWeather.

To make this example work, please create a `lib/keys.dart` file with the following:

```dart
const String weatherApiKey = '<accuweather_api_key>';
```

## Running the cloud function locally

```shell
$ dart bin/server.dart
```

This will host the cloud function locally at localhost:8080

## Testing the cloud function locally

This cloud function accepts a `query` in a json body and returns a result with the locations and forecast for the next day:

```shell
$ curl -i -X POST -H "Content-Type: application/json" -d '{"query":"fenix"}' http://localhost:8080/
HTTP/1.1 200 OK
date: Sat, 13 Nov 2021 19:36:45 GMT
content-length: 194
x-frame-options: SAMEORIGIN
content-type: text/plain; charset=utf-8
x-xss-protection: 1; mode=block
x-content-type-options: nosniff
server: dart:io with Shelf

[{"location":"Fenix","maximum":21.3,"minimum":0.3,"country":"United States","epochTime":1636804800},{"location":"Fenix","maximum":32.3,"minimum":22.6,"country":"Ecuador","epochTime":1636804800}]%
```

