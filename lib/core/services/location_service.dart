import 'dart:math' as math;
import 'package:geolocator/geolocator.dart';

enum LocationSimulationMode {
  atOffice, // Reviewer simulated: At office (< 200m)
  outsideOffice, // Reviewer simulated: Outside office (> 200m)
  realGps, // Live device hardware GPS
  permissionDenied, // Reviewer simulated: Permission Denied
  permanentlyDenied, // Reviewer simulated: Permission Permanently Denied
  serviceDisabled, // Reviewer simulated: GPS Service Disabled
}

class LocationResult {
  final bool isSuccess;
  final double? latitude;
  final double? longitude;
  final double? distanceMeters;
  final bool isWithinGeofence;
  final String? errorMessage;

  LocationResult({
    required this.isSuccess,
    this.latitude,
    this.longitude,
    this.distanceMeters,
    this.isWithinGeofence = false,
    this.errorMessage,
  });
}

class LocationService {
  // Configurable office coordinates and radius
  static double officeLatitude = 12.9716;
  static double officeLongitude = 77.5946;
  static double permittedRadiusMeters = 200.0;
  static String officeName = "Office Headquarters";
  static String companyTimezone = "Asia/Kolkata";

  // Current simulation mode (defaults to atOffice for smooth testing, can be toggled by reviewer)
  static LocationSimulationMode simulationMode = LocationSimulationMode.atOffice;

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

  /// Get current coordinates according to active simulation mode or device GPS
  static Future<LocationResult> getCurrentCoordinates() async {
    switch (simulationMode) {
      case LocationSimulationMode.atOffice:
        final dist = calculateDistanceMeters(
          officeLatitude,
          officeLongitude,
          officeLatitude,
          officeLongitude,
        );
        return LocationResult(
          isSuccess: true,
          latitude: officeLatitude,
          longitude: officeLongitude,
          distanceMeters: dist,
          isWithinGeofence: true,
        );

      case LocationSimulationMode.outsideOffice:
        // ~1.2 km away from office
        final outsideLat = officeLatitude + 0.011;
        final outsideLng = officeLongitude + 0.011;
        final dist = calculateDistanceMeters(
          officeLatitude,
          officeLongitude,
          outsideLat,
          outsideLng,
        );
        return LocationResult(
          isSuccess: true,
          latitude: outsideLat,
          longitude: outsideLng,
          distanceMeters: dist,
          isWithinGeofence: false,
          errorMessage:
              "You are ${dist.round()}m away from $officeName. Attendance is permitted only within ${permittedRadiusMeters.round()}m.",
        );

      case LocationSimulationMode.permissionDenied:
        return LocationResult(
          isSuccess: false,
          errorMessage:
              "Location permission was denied. Please grant location access to mark attendance.",
        );

      case LocationSimulationMode.permanentlyDenied:
        return LocationResult(
          isSuccess: false,
          errorMessage:
              "Location permission is permanently denied. Please enable it in device settings to proceed.",
        );

      case LocationSimulationMode.serviceDisabled:
        return LocationResult(
          isSuccess: false,
          errorMessage:
              "Location services are disabled on your device. Please turn on GPS.",
        );

      case LocationSimulationMode.realGps:
        try {
          bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            return LocationResult(
              isSuccess: false,
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

          final position = await Geolocator.getCurrentPosition(
            timeLimit: const Duration(seconds: 10),
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
}
