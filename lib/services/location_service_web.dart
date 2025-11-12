import 'dart:html' as html;

class LocationService {
  static final instance = LocationService._internal();
  LocationService._internal();

  Future<bool> isLocationServiceEnabled() async =>
      html.window.navigator.geolocation != null;

  Future<bool> requestLocationPermission() async => true;

  Future<void> openLocationSettings() async =>
      print('openLocationSettings() not supported on web');

  Future<void> openAppSettings() async =>
      print('openAppSettings() not supported on web');

  Future<Map<String, dynamic>> getCurrentLocation() async {
    final nav = html.window.navigator.geolocation;
    if (nav == null) throw Exception('Geolocation not supported');

    final pos = await nav.getCurrentPosition();
    final lat = (pos.coords?.latitude ?? 0).toDouble();
    final lon = (pos.coords?.longitude ?? 0).toDouble();

    return {
      'latitude': lat,
      'longitude': lon,
      'address': '$lat, $lon'
    };
  }

  Future<String> getTimezone([double? lat, double? lon]) async =>
      DateTime.now().timeZoneName;

  Future<void> saveLocationToSupabase([dynamic arg1, dynamic arg2]) async {
    double lat;
    double lon;
    if (arg1 is Map) {
      lat = (arg1['latitude'] ?? 0).toDouble();
      lon = (arg1['longitude'] ?? 0).toDouble();
    } else {
      lat = (arg1 ?? 0).toDouble();
      lon = (arg2 ?? 0).toDouble();
    }
    print('Saving location to Supabase: $lat, $lon');
  }

  Future<Map<String, double>> getCurrentLocationFromSupabase() async =>
      {'latitude': 0.0, 'longitude': 0.0};
}
