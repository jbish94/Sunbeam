import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService {
  static const _locationTimeout = Duration(seconds: 12);

  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<void> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }

  Future<void> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  Future<bool> requestLocationPermission() async {
    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      return true;
    }

    permission = await Geolocator.requestPermission();

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<Position> getCurrentLocation() async {
    final enabled = await isLocationServiceEnabled();
    if (!enabled) {
      throw Exception('Location services are disabled');
    }

    final granted = await requestLocationPermission();
    if (!granted) {
      throw Exception('Location permission denied');
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: _locationTimeout,
    );
  }

  Future<String?> getAddressFromCoordinates(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);
    if (placemarks.isEmpty) return null;

    final p = placemarks.first;
    final parts = <String>[
      if (p.locality != null && p.locality!.isNotEmpty) p.locality!,
      if (p.administrativeArea != null && p.administrativeArea!.isNotEmpty)
        p.administrativeArea!,
      if (p.country != null && p.country!.isNotEmpty) p.country!,
    ];

    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  Future<String?> getTimezone(double lat, double lng) async {
    // Simple fallback: device timezone name.
    return DateTime.now().timeZoneName;
  }

  import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// inside class LocationService { ... }

final _supabase = Supabase.instance.client;

Future<void> saveLocationToSupabase(Position position) async {
  final user = _supabase.auth.currentUser;
  if (user == null) {
    return; // or throw, depending on your auth model
  }

  await _supabase.from('user_locations').upsert({
    'user_id': user.id,
    'latitude': position.latitude,
    'longitude': position.longitude,
    'updated_at': DateTime.now().toIso8601String(),
  });
}

  /// Used by HomeScreen and others: get current position + address.
  Future<Map<String, dynamic>?> fetchAndSaveLocation() async {
    final position = await getCurrentLocation();
    final address =
        await getAddressFromCoordinates(position.latitude, position.longitude);

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
      'timezone': await getTimezone(
        position.latitude,
        position.longitude,
      ),
    };
  }

  /// Stub for existing callers expecting this method.
  /// Extend later if you truly want to read location from Supabase.
  Future<Map<String, dynamic>?> getCurrentLocationFromSupabase() async {
    return null;
  }
}
