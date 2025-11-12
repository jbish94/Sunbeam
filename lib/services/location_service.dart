import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'supabase_service.dart';

class LocationService {
  final SupabaseService _supabaseService = SupabaseService();

  /// Gets the device's current location coordinates.
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  /// Converts coordinates into a human-readable address string.
  Future<String?> getReadableAddress(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        return "${p.locality}, ${p.administrativeArea}";
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Saves both coordinates and address to Supabase
  Future<void> saveLocationToSupabase(Position position,
      {String? address}) async {
    await _supabaseService.insertLocation({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address ?? '',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Gets the full location flow — position + readable address + save
  Future<Map<String, dynamic>?> fetchAndSaveLocation() async {
    final position = await getCurrentPosition();
    if (position == null) return null;

    final address = await getReadableAddress(position);
    await saveLocationToSupabase(position, address: address);

    return {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'address': address,
    };
  }
}
