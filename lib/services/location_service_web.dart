import 'dart:html' as html;

class LocationService {
  static final instance = LocationService._internal();
  LocationService._internal();

  Future<Map<String, double>> getCurrentLocation() async {
    final nav = html.window.navigator.geolocation;
    if (nav != null) {
      final position = await nav.getCurrentPosition();
      return {
        'latitude': position.coords?.latitude ?? 0,
        'longitude': position.coords?.longitude ?? 0,
      };
    }
    throw Exception('Geolocation not supported');
  }

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    return '$lat, $lon';
  }
}
