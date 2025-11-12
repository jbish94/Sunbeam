import 'package:geolocator/geolocator.dart';

class LocationService {
  static final instance = LocationService._internal();
  LocationService._internal();

  Future<bool> isLocationServiceEnabled() async =>
      await Geolocator.isLocationServiceEnabled();

  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> openLocationSettings() async =>
      Geolocator.openLocationSettings();

  Future<void> openAppSettings() async =>
      Geolocator.openAppSettings();

  Future<Map<String, dynamic>> getCurrentLocation() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition();
    final lat = pos.latitude;
    final lon = pos.longitude;

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
