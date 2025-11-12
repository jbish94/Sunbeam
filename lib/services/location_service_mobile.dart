import 'package:geolocator/geolocator.dart';

class PositionLike {
  final double latitude;
  final double longitude;
  PositionLike(this.latitude, this.longitude);
}

class LocationService {
  static final instance = LocationService._internal();
  LocationService._internal();

  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  Future<PositionLike> getCurrentLocation() async {
    await Geolocator.requestPermission();
    final pos = await Geolocator.getCurrentPosition();
    return PositionLike(pos.latitude, pos.longitude);
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
    // Stub value
    return PositionLike(0.0, 0.0);
  }
}
