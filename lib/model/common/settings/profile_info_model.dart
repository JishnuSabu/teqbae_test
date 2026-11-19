class EmployeeProfileInfoModel {
  bool? status;
  String? message;
  Profile? profile;

  EmployeeProfileInfoModel({this.status, this.message, this.profile});

  EmployeeProfileInfoModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    profile = json['profile'] != null
        ? Profile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? profilePicture;
  int? id;
  int? employeeId;
  String? name;
  String? empCode;
  String? designation;
  String? department;
  String? employmentType;
  String? dateOfJoining;
  String? fatherName;
  String? motherName;
  String? dateOfBirth;
  String? gender;
  String? maritalStatus;
  String? nationality;
  String? bloodGroup;
  String? phoneNumber;
  String? emergencyContact;
  String? email;
  String? presentAddress;
  String? permanentAddress;

  Profile({
    this.profilePicture,
    this.id,
    this.employeeId,
    this.name,
    this.empCode,
    this.designation,
    this.department,
    this.employmentType,
    this.dateOfJoining,
    this.fatherName,
    this.motherName,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.nationality,
    this.bloodGroup,
    this.phoneNumber,
    this.emergencyContact,
    this.email,
    this.presentAddress,
    this.permanentAddress,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    profilePicture = json['profile_picture'];
    id = json['id'];
    employeeId = json['employee_id'];
    name = json['name'];
    empCode = json['emp_code'];
    designation = json['designation'];
    department = json['department'];
    employmentType = json['employment_type'];
    dateOfJoining = json['date_of_joining'];
    fatherName = json['father_name'];
    motherName = json['mother_name'];
    dateOfBirth = json['date_of_birth'];
    gender = json['gender'];
    maritalStatus = json['marital_status'];
    nationality = json['nationality'];
    bloodGroup = json['blood_group'];
    phoneNumber = json['phone_number'];
    emergencyContact = json['emergency_contact'];
    email = json['email'];
    presentAddress = json['present_address'];
    permanentAddress = json['permanent_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['profile_picture'] = profilePicture;
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['name'] = name;
    data['emp_code'] = empCode;
    data['designation'] = designation;
    data['department'] = department;
    data['employment_type'] = employmentType;
    data['date_of_joining'] = dateOfJoining;
    data['father_name'] = fatherName;
    data['mother_name'] = motherName;
    data['date_of_birth'] = dateOfBirth;
    data['gender'] = gender;
    data['marital_status'] = maritalStatus;
    data['nationality'] = nationality;
    data['blood_group'] = bloodGroup;
    data['phone_number'] = phoneNumber;
    data['emergency_contact'] = emergencyContact;
    data['email'] = email;
    data['present_address'] = presentAddress;
    data['permanent_address'] = permanentAddress;
    return data;
  }
}
