class hrLeaverequestCountModel {
  bool? status;
  String? message;
  int? pendingRequests;
  int? approvedRequests;
  int? rejectedRequests;
  int? onLeaveToday;

  hrLeaverequestCountModel({
    this.status,
    this.message,
    this.pendingRequests,
    this.approvedRequests,
    this.rejectedRequests,
    this.onLeaveToday,
  });

  hrLeaverequestCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    pendingRequests = json['pending_requests'];
    approvedRequests = json['approved_requests'];
    rejectedRequests = json['rejected_requests'];
    onLeaveToday = json['on_leave_today'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['pending_requests'] = pendingRequests;
    data['approved_requests'] = approvedRequests;
    data['rejected_requests'] = rejectedRequests;
    data['on_leave_today'] = onLeaveToday;
    return data;
  }
}
