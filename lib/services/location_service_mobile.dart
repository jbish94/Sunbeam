import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<void> init() async {
    await Geolocator.requestPermission();
  }

  Future<String> getLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    return '${pos.latitude}, ${pos.longitude}';
  }
}
