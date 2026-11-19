enum AttendanceSyncStatus {
  pending,
  synced,
  rejected,
}

class AttendanceEvent {
  final String idempotencyKey; // UUID
  final String eventType; // check_in or check_out
  final String timestamp; // ISO 8601
  final double latitude;
  final double longitude;
  final AttendanceSyncStatus syncStatus;
  final String date; // YYYY-MM-DD
  final String? errorMessage;

  AttendanceEvent({
    required this.idempotencyKey,
    required this.eventType,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.syncStatus = AttendanceSyncStatus.pending,
    required this.date,
    this.errorMessage,
  });

  AttendanceEvent copyWith({
    AttendanceSyncStatus? syncStatus,
    String? errorMessage,
  }) {
    return AttendanceEvent(
      idempotencyKey: idempotencyKey,
      eventType: eventType,
      timestamp: timestamp,
      latitude: latitude,
      longitude: longitude,
      syncStatus: syncStatus ?? this.syncStatus,
      date: date,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  factory AttendanceEvent.fromJson(Map<String, dynamic> json) {
    return AttendanceEvent(
      idempotencyKey: json['idempotency_key']?.toString() ?? '',
      eventType: json['event_type']?.toString() ?? 'check_in',
      timestamp: json['timestamp']?.toString() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      syncStatus: _parseSyncStatus(json['sync_status']?.toString()),
      date: json['date']?.toString() ?? '',
      errorMessage: json['error_message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'idempotency_key': idempotencyKey,
        'event_type': eventType,
        'timestamp': timestamp,
        'latitude': latitude,
        'longitude': longitude,
        'sync_status': syncStatus.name,
        'date': date,
        'error_message': errorMessage,
      };

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
