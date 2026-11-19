class LeaveRequestModel {
  final String id;
  final String leaveType;
  final String startDate;
  final String endDate;
  final int days;
  final String reason;
  final String status;
  final String appliedAt;

  LeaveRequestModel({
    required this.id,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.reason,
    required this.status,
    required this.appliedAt,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      id: json['id']?.toString() ?? '',
      leaveType: json['leave_type']?.toString() ?? 'Casual',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString() ?? '',
      days: (json['days'] as num?)?.toInt() ?? 1,
      reason: json['reason']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      appliedAt: json['applied_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'leave_type': leaveType,
        'start_date': startDate,
        'end_date': endDate,
        'days': days,
        'reason': reason,
        'status': status,
        'applied_at': appliedAt,
      };
}
