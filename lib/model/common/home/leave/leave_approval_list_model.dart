class LeaveApprovalListModel {
  bool? status;
  String? message;
  List<Leaves>? leaves;

  LeaveApprovalListModel({this.status, this.message, this.leaves});

  LeaveApprovalListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['leaves'] != null) {
      leaves = <Leaves>[];
      json['leaves'].forEach((v) {
        leaves!.add(Leaves.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (leaves != null) {
      data['leaves'] = leaves!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Leaves {
  int? id;
  int? userId;
  String? employeeName;
  String? leaveType;
  String? leaveDuration;
  String? leaveSection;
  String? startDate;
  String? endDate;
  String? remark;
  int? status;
  int? approvedBy;
  String? approverName;
  String? leaveFileUpload;

  Leaves({
    this.id,
    this.userId,
    this.employeeName,
    this.leaveType,
    this.leaveDuration,
    this.leaveSection,
    this.startDate,
    this.endDate,
    this.remark,
    this.status,
    this.approvedBy,
    this.approverName,
    this.leaveFileUpload,
  });

  Leaves.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    userId = json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? '');
    employeeName = json['employee_name']?.toString();
    leaveType = json['leave_type']?.toString();
    leaveDuration = json['leave_duration']?.toString();
    leaveSection = json['leave_section']?.toString();
    startDate = json['start_date']?.toString();
    endDate = json['end_date']?.toString();
    remark = json['remark']?.toString();
    status = json['status'] is int ? json['status'] : int.tryParse(json['status']?.toString() ?? '');
    approvedBy = json['approved_by'] is int ? json['approved_by'] : int.tryParse(json['approved_by']?.toString() ?? '');
    approverName = json['approver_name']?.toString();
    leaveFileUpload = json['leave_file_upload']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['employee_name'] = employeeName;
    data['leave_type'] = leaveType;
    data['leave_duration'] = leaveDuration;
    data['leave_section'] = leaveSection;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['remark'] = remark;
    data['status'] = status;
    data['approved_by'] = approvedBy;
    data['approver_name'] = approverName;
    data['leave_file_upload'] = leaveFileUpload;
    return data;
  }
}
