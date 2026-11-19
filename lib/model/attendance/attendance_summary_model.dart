class AttendanceSummaryModel {
  bool? status;
  String? message;
  AttendanceSummary? attendanceSummary;
  List<WorkHours>? workHours;

  AttendanceSummaryModel({
    this.status,
    this.message,
    this.attendanceSummary,
    this.workHours,
  });

  AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    attendanceSummary = json['attendance_summary'] != null
        ? AttendanceSummary.fromJson(json['attendance_summary'])
        : null;
    if (json['work_hours'] != null) {
      workHours = <WorkHours>[];
      json['work_hours'].forEach((v) {
        workHours!.add(WorkHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (attendanceSummary != null) {
      data['attendance_summary'] = attendanceSummary!.toJson();
    }
    if (workHours != null) {
      data['work_hours'] = workHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceSummary {
  String? date;
  String? day;
  String? month;
  String? checkInTime;
  String? checkOutTime;
  String? workHours;
  int? monthlyLeaveCount;
  int? monthlyAttendanceCount;

  AttendanceSummary({
    this.date,
    this.day,
    this.month,
    this.checkInTime,
    this.checkOutTime,
    this.workHours,
    this.monthlyLeaveCount,
    this.monthlyAttendanceCount,
  });

  AttendanceSummary.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    day = json['day'];
    month = json['month'];
    checkInTime = json['check_in_time'];
    checkOutTime = json['check_out_time'];
    workHours = json['work_hours'];
    monthlyLeaveCount = json['monthly_leave_count'];
    monthlyAttendanceCount = json['monthly_attendance_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['day'] = day;
    data['month'] = month;
    data['check_in_time'] = checkInTime;
    data['check_out_time'] = checkOutTime;
    data['work_hours'] = workHours;
    data['monthly_leave_count'] = monthlyLeaveCount;
    data['monthly_attendance_count'] = monthlyAttendanceCount;
    return data;
  }
}

class WorkHours {
  String? date;
  double? workHour;

  WorkHours({this.date, this.workHour});

  WorkHours.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['work_hour'] != null) {
      workHour = double.tryParse(json['work_hour'].toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['work_hour'] = workHour;
    return data;
  }
}
