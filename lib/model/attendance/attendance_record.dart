import 'package:teqbae_test/model/attendance/attendance_event.dart';

class AttendanceRecord {
  final String id;
  final String date;
  final String? checkIn;
  final String? checkOut;
  final String? duration;
  final AttendanceSyncStatus syncStatus;

  AttendanceRecord({
    required this.id,
    required this.date,
    this.checkIn,
    this.checkOut,
    this.duration,
    this.syncStatus = AttendanceSyncStatus.synced,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      id: json['id']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      checkIn: json['check_in']?.toString(),
      checkOut: json['check_out']?.toString(),
      duration: json['duration']?.toString(),
      syncStatus: _parseSyncStatus(json['sync_status']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'check_in': checkIn,
        'check_out': checkOut,
        'duration': duration,
        'sync_status': syncStatus.name,
      };

  AttendanceRecord copyWith({
    String? id,
    String? date,
    String? checkIn,
    String? checkOut,
    String? duration,
    AttendanceSyncStatus? syncStatus,
  }) {
    return AttendanceRecord(
      id: id ?? this.id,
      date: date ?? this.date,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      duration: duration ?? this.duration,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  static AttendanceSyncStatus _parseSyncStatus(String? value) {
    switch (value?.toLowerCase()) {
      case 'synced':
        return AttendanceSyncStatus.synced;
      case 'rejected':
        return AttendanceSyncStatus.rejected;
      case 'pending':
      default:
        return AttendanceSyncStatus.pending;
    }
  }
}
