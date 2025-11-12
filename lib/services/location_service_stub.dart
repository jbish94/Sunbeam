class LocationService {
  static final instance = LocationService._internal();
  LocationService._internal();

  Future<dynamic> getCurrentLocation() async =>
      {'latitude': 0.0, 'longitude': 0.0};

  Future<String> getAddressFromCoordinates(double lat, double lon) async =>
      'Unavailable';
}
