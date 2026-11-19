class DepartmentsModel {
  bool? status;
  String? message;
  List<Departments>? departments;

  DepartmentsModel({this.status, this.message, this.departments});

  DepartmentsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['departments'] != null) {
      departments = <Departments>[];
      json['departments'].forEach((v) {
        departments!.add(Departments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (departments != null) {
      data['departments'] = departments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Departments {
  int? id;
  String? name;

  Departments({this.id, this.name});

  Departments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
