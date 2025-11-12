import 'dart:html' as html;

class PositionLike {
  final double latitude;
  final double longitude;
  PositionLike(this.latitude, this.longitude);
}

class LocationService {
  static final instance = LocationService._internal();
  LocationService._internal();

  Future<bool> isLocationServiceEnabled() async {
    return html.window.navigator.geolocation != null;
  }

  Future<bool> requestLocationPermission() async {
    // Browser prompts automatically, so assume allowed
    return true;
  }

  Future<void> openLocationSettings() async {
    print('openLocationSettings() not supported on web');
  }

  Future<void> openAppSettings() async {
    print('openAppSettings() not supported on web');
  }

  Future<PositionLike> getCurrentLocation() async {
    final nav = html.window.navigator.geolocation;
    if (nav == null) throw Exception('Geolocation not supported');

    final pos = await nav.getCurrentPosition();
    final lat = (pos.coords?.latitude ?? 0).toDouble();
    final lon = (pos.coords?.longitude ?? 0).toDouble();
    return PositionLike(lat, lon);
  }

  Future<String> getTimezone([double? lat, double? lon]) async {
    return DateTime.now().timeZoneName;
  }

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    return '$lat, $lon';
  }

  Future<void> saveLocationToSupabase(double lat, double lon) async {
    print('Saving location to Supabase: $lat, $lon');
  }

  Future<PositionLike> getCurrentLocationFromSupabase() async {
    return PositionLike(0.0, 0.0);
  }
}
