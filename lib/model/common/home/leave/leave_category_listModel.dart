class leaveCategoryListModel {
  bool? status;
  String? message;
  List<LeaveCategories>? leaveCategories;

  leaveCategoryListModel({this.status, this.message, this.leaveCategories});

  leaveCategoryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['leave_categories'] != null) {
      leaveCategories = <LeaveCategories>[];
      json['leave_categories'].forEach((v) {
        leaveCategories!.add(LeaveCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (leaveCategories != null) {
      data['leave_categories'] = leaveCategories!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class LeaveCategories {
  int? id;
  String? name;
  bool? isActive;

  LeaveCategories({this.id, this.name, this.isActive});

  LeaveCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['is_active'] = isActive;
    return data;
  }
}
