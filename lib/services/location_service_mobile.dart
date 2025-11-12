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

  Future<void> openLocationSettings() async => Geolocator.openLocationSettings();
  Future<void> openAppSettings() async => Geolocator.openAppSettings();

  Future<Map<String, dynamic>> getCurrentLocation() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition();
    final lat = pos.latitude;
    final lon = pos.longitude;
    final address = '$lat, $lon';
    return {'latitude': lat, 'longitude': lon, 'address': address};
  }

  Future<String> getAddressFromCoordinates(double lat, double lon) async {
    return '$lat, $lon';
  }

  Future<String> getTimezone([double? lat, double? lon]) async =>
      DateTime.now().timeZoneName;

  Future<bool> saveLocationToSupabase(dynamic position) async {
    final lat = (position['latitude'] ?? 0).toDouble();
    final lon = (position['longitude'] ?? 0).toDouble();
    print('Saving location to Supabase: $lat, $lon');
    return true;
  }

  Future<Map<String, dynamic>> getCurrentLocationFromSupabase() async {
    return {'latitude': 0.0, 'longitude': 0.0, 'address': 'Unknown'};
  }
}
