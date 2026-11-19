class LoginModel {
  bool? status;
  String? message;
  String? token;
  int? roleId;
  String? roleType;
  User? user;

  LoginModel({
    this.status,
    this.message,
    this.token,
    this.roleId,
    this.roleType,
    this.user,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    token = json['token'];
    roleId = json['role_id'];
    roleType = json['role_type'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['token'] = token;
    data['role_id'] = roleId;
    data['role_type'] = roleType;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? userId;
  String? firstName;
  String? userName;
  String? employeeid;
  String? mobileno;
  String? profilePicture;
  bool? active;

  User({
    this.userId,
    this.firstName,
    this.userName,
    this.employeeid,
    this.mobileno,
    this.profilePicture,
    this.active,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    userName = json['user_name'];
    employeeid = json['employeeid'];
    mobileno = json['mobileno'];
    profilePicture = json['profile_picture'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['first_name'] = firstName;
    data['user_name'] = userName;
    data['employeeid'] = employeeid;
    data['mobileno'] = mobileno;
    data['profile_picture'] = profilePicture;
    data['active'] = active;
    return data;
  }
}
