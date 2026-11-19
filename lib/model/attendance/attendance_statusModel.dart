class AttendanceStatusModel {
  bool? status;
  String? message;
  Attendance? attendance;

  AttendanceStatusModel({this.status, this.message, this.attendance});

  AttendanceStatusModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    attendance = json['attendance'] != null
        ? new Attendance.fromJson(json['attendance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (attendance != null) {
      data['attendance'] = attendance!.toJson();
    }
    return data;
  }
}

class Attendance {
  String? attendanceStatus;
  String? shiftStartTime;
  String? markInTime;
  String? markOutTime;
  String? startKm;
  int? isHoliday;

  Attendance({
    this.attendanceStatus,
    this.shiftStartTime,
    this.markInTime,
    this.markOutTime,
    this.startKm,
    this.isHoliday,
  });

  Attendance.fromJson(Map<String, dynamic> json) {
    attendanceStatus = json['attendance_status'];
    shiftStartTime = json['shift_start_time'];
    markInTime = json['mark_in_time'];
    markOutTime = json['mark_out_time'];
    startKm = json['start_km'];
    isHoliday = json['is_holiday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['attendance_status'] = attendanceStatus;
    data['shift_start_time'] = shiftStartTime;
    data['mark_in_time'] = markInTime;
    data['mark_out_time'] = markOutTime;
    data['start_km'] = startKm;
    data['is_holiday'] = isHoliday;
    return data;
  }
}
