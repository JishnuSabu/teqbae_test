class CheckInCheckOutDetailsModel {
  bool? status;
  String? message;
  String? date;
  List<AttendanceList>? attendanceList;

  CheckInCheckOutDetailsModel({
    this.status,
    this.message,
    this.date,
    this.attendanceList,
  });

  CheckInCheckOutDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    date = json['date'];
    if (json['attendance_list'] != null) {
      attendanceList = <AttendanceList>[];
      json['attendance_list'].forEach((v) {
        attendanceList!.add(AttendanceList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['date'] = date;
    if (attendanceList != null) {
      data['attendance_list'] = attendanceList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceList {
  int? id;
  String? date;
  String? scheduledCheckIn;
  String? scheduledCheckOut;
  String? checkIn;
  String? checkOut;
  int? status;
  String? statusLabel;

  AttendanceList({
    this.id,
    this.date,
    this.scheduledCheckIn,
    this.scheduledCheckOut,
    this.checkIn,
    this.checkOut,
    this.status,
    this.statusLabel,
  });

  AttendanceList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    scheduledCheckIn = json['scheduled_check_in'];
    scheduledCheckOut = json['scheduled_check_out'];
    checkIn = json['check_in'];
    checkOut = json['check_out'];
    status = json['status'];
    statusLabel = json['status_label'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['scheduled_check_in'] = scheduledCheckIn;
    data['scheduled_check_out'] = scheduledCheckOut;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    data['status'] = status;
    data['status_label'] = statusLabel;
    return data;
  }
}
