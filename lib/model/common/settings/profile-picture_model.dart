class ProfilePictureModel {
  bool? status;
  String? message;
  String? profilePicture;

  ProfilePictureModel({this.status, this.message, this.profilePicture});

  ProfilePictureModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    profilePicture = json['profile_picture'];
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    data['profile_picture'] = profilePicture;
    return data;
  }
}
