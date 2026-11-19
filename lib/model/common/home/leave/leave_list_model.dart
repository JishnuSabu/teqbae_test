class LeaveListModel {
  bool? status;
  String? message;
  List<LeaveList>? leaveList;

  LeaveListModel({this.status, this.message, this.leaveList});

  LeaveListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['leave_list'] != null) {
      leaveList = <LeaveList>[];
      json['leave_list'].forEach((v) {
        leaveList!.add(LeaveList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
  String? date;
  String? startDate;
  String? endDate;
  String? leaveType;
  String? leaveDuration;
  String? leaveSection;
  String? remark;
  int? status;
  String? approvedBy;
  String? approverName;
  String? approverText;
  String? leaveFileUpload;

  LeaveList({
    this.id,
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
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    date = json['date']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    leaveType = json['leave_type']?.toString();
    leaveDuration = json['leave_duration']?.toString();
    leaveSection = json['leave_section']?.toString();
    remark = json['remark']?.toString();
    status = json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '');
    approvedBy = json['approved_by']?.toString();
    approverName = json['approver_name']?.toString();
    approverText = json['approver_text']?.toString();
    leaveFileUpload = json['leave_file_upload']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
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
