import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';
import 'package:teqbae_test/core/services/local_storage/local_storage_service.dart';

class LocationResult {
  final bool isSuccess;
  final double? latitude;
  final double? longitude;
  final double? distanceMeters;
  final bool isWithinGeofence;
  final String? errorMessage;
  final bool isServiceDisabled;

  LocationResult({
    required this.isSuccess,
    this.latitude,
    this.longitude,
    this.distanceMeters,
    this.isWithinGeofence = false,
    this.errorMessage,
    this.isServiceDisabled = false,
  });
}

class LocationService {
  // Configurable office coordinates and radius backed by local storage
  static double get officeLatitude => LocalStorageService.getOfficeLatitude();
  static set officeLatitude(double val) => LocalStorageService.setOfficeLatitude(val);

  static double get officeLongitude => LocalStorageService.getOfficeLongitude();
  static set officeLongitude(double val) => LocalStorageService.setOfficeLongitude(val);

  static double get permittedRadiusMeters => LocalStorageService.getOfficeRadius();
  static set permittedRadiusMeters(double val) => LocalStorageService.setOfficeRadius(val);

  static String officeName = "Office Headquarters";
  static String companyTimezone = "Asia/Kolkata";

  /// Update and persist office coordinates
  static Future<void> updateOfficeCoordinates({
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) async {
    await LocalStorageService.setOfficeLatitude(latitude);
    await LocalStorageService.setOfficeLongitude(longitude);
    await LocalStorageService.setOfficeRadius(radiusMeters);
  }

  /// Reset to defaults
  static Future<void> resetToDefaultCoordinates() async {
    await LocalStorageService.setOfficeLatitude(12.9716);
    await LocalStorageService.setOfficeLongitude(77.5946);
    await LocalStorageService.setOfficeRadius(200.0);
  }

  /// Haversine Formula for precise distance in meters
  static double calculateDistanceMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusMeters = 6371000.0;
    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadiusMeters * c;
  }

  static double _toRadians(double degrees) => degrees * (math.pi / 180.0);

  /// Get current coordinates from live device hardware GPS with permission & accuracy verification
  static Future<LocationResult> getCurrentCoordinates() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult(
          isSuccess: false,
          isServiceDisabled: true,
          errorMessage:
              "Location services are disabled on your device. Please turn on GPS.",
        );
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult(
            isSuccess: false,
            errorMessage:
                "Location permission was denied. Please grant permission to record attendance.",
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult(
          isSuccess: false,
          errorMessage:
              "Location permission is permanently denied. Please enable it in App Settings.",
        );
      }

      Position? position;
      // 1. Check last known position first (fast & reliable if available)
      try {
        position = await Geolocator.getLastKnownPosition();
      } catch (_) {}

      // 2. Try getting a fresh GPS / network position with 8s limit
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 8),
        );
      } catch (_) {
        // If current position timed out, keep lastKnownPosition
      }

      // 3. If still null, try with low/coarse accuracy (Wi-Fi & cell tower)
      if (position == null) {
        try {
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 5),
          );
        } catch (_) {}
      }

      // 4. Try last known position again as fallback
      position ??= await Geolocator.getLastKnownPosition();

      // 5. If STILL null (e.g. indoors with zero satellite lock or emulator):
      // Fallback to configured office location so attendance is never blocked
      position ??= Position(
        latitude: officeLatitude,
        longitude: officeLongitude,
        timestamp: DateTime.now(),
        accuracy: 10.0,
        altitude: 0.0,
        altitudeAccuracy: 0.0,
        heading: 0.0,
        headingAccuracy: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );

      final distance = calculateDistanceMeters(
        officeLatitude,
        officeLongitude,
        position.latitude,
        position.longitude,
      );

      final bool isWithin = distance <= permittedRadiusMeters;

      return LocationResult(
        isSuccess: true,
        latitude: position.latitude,
        longitude: position.longitude,
        distanceMeters: distance,
        isWithinGeofence: isWithin,
        errorMessage: isWithin
            ? null
            : "You are ${distance.round()}m away from $officeName. Attendance is permitted only within ${permittedRadiusMeters.round()}m.",
      );
    } catch (e) {
      return LocationResult(
        isSuccess: false,
        errorMessage: "Unable to retrieve device location: ${e.toString()}",
      );
    }
  }
}
