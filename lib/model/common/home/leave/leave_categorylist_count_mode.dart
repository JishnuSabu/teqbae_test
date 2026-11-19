class leaveCategorylistCountModel {
  bool? status;
  String? message;
  List<Data>? data;

  leaveCategorylistCountModel({this.status, this.message, this.data});

  leaveCategorylistCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? userId;
  String? username;
  String? leaveType;
  int? totalCount;

  Data({this.userId, this.username, this.leaveType, this.totalCount});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    leaveType = json['leave_type'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = userId;
    data['username'] = username;
    data['leave_type'] = leaveType;
    data['total_count'] = totalCount;
    return data;
  }
}
