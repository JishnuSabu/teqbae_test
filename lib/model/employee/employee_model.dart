import 'package:teqbae_test/model/common/settings/profile_info_model.dart';

class OfficeModel {
  final String name;
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String timezone;

  OfficeModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.timezone,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) {
    return OfficeModel(
      name: json['name']?.toString() ?? 'Headquarters',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 12.9716,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.5946,
      radiusMeters: (json['radius_meters'] as num?)?.toDouble() ?? 200.0,
      timezone: json['timezone']?.toString() ?? 'Asia/Kolkata',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'radius_meters': radiusMeters,
        'timezone': timezone,
      };
}

class EmployeeModel {
  final String id;
  final String name;
  final String department;
  final String designation;
  final OfficeModel? office;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.department,
    required this.designation,
    this.office,
  });

  factory EmployeeModel.empty() => EmployeeModel(
        id: '',
        name: '',
        department: '',
        designation: '',
      );

  factory EmployeeModel.fromProfile(Profile profile) {
    return EmployeeModel(
      id: profile.empCode ??
          (profile.employeeId != null ? "${profile.employeeId}" : ""),
      name: profile.name ?? "",
      department: profile.department ?? "",
      designation: profile.designation ?? "",
      office: OfficeModel(
        name: profile.presentAddress?.isNotEmpty == true
            ? profile.presentAddress!
            : "Headquarters",
        latitude: 12.9716,
        longitude: 77.5946,
        radiusMeters: 200.0,
        timezone: "Asia/Kolkata",
      ),
    );
  }

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      office: json['office'] != null
          ? OfficeModel.fromJson(json['office'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'department': department,
        'designation': designation,
        'office': office?.toJson(),
      };
}
