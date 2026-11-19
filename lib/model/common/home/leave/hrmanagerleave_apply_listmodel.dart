class HrManagerApplyLeaveModel {
  bool? status;
  String? message;
  List<LeaveList>? leaveList;

  HrManagerApplyLeaveModel({this.status, this.message, this.leaveList});

  HrManagerApplyLeaveModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['leave_list'] != null) {
      leaveList = <LeaveList>[];
      json['leave_list'].forEach((v) {
        leaveList!.add(new LeaveList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (leaveList != null) {
      data['leave_list'] = leaveList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaveList {
  int? id;
  int? userId;
  String? username;
  String? date;
  String? startDate;
  String? endDate;
  String? leaveType;
  String? leaveDuration;
  String? leaveSection;
  String? remark;
  int? status;
  int? approvedBy;
  String? approverName;
  String? approverText;
  String? leaveFileUpload;

  LeaveList({
    this.id,
    this.userId,
    this.username,
    this.date,
    this.startDate,
    this.endDate,
    this.leaveType,
    this.leaveDuration,
    this.leaveSection,
    this.remark,
    this.status,
    this.approvedBy,
    this.approverName,
    this.approverText,
    this.leaveFileUpload,
  });

  LeaveList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    username = json['username'];
    date = json['date'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    leaveType = json['leave_type'];
    leaveDuration = json['leave_duration'];
    leaveSection = json['leave_section'];
    remark = json['remark'];
    status = json['status'];
    approvedBy = json['approved_by'];
    approverName = json['approver_name'];
    approverText = json['approver_text'];
    leaveFileUpload = json['leave_file_upload'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['username'] = username;
    data['date'] = date;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['leave_type'] = leaveType;
    data['leave_duration'] = leaveDuration;
    data['leave_section'] = leaveSection;
    data['remark'] = remark;
    data['status'] = status;
    data['approved_by'] = approvedBy;
    data['approver_name'] = approverName;
    data['approver_text'] = approverText;
    data['leave_file_upload'] = leaveFileUpload;
    return data;
  }
}
