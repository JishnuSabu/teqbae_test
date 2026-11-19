class AnnouncementModel {
  bool? status;
  String? message;
  List<Announcements>? announcements;

  AnnouncementModel({this.status, this.message, this.announcements});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['announcements'] != null) {
      announcements = <Announcements>[];
      json['announcements'].forEach((v) {
        announcements!.add(Announcements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (announcements != null) {
      data['announcements'] = announcements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Announcements {
  int? id;
  String? name;
  String? description;
  String? date;
  int? status;
  String? author;
  List<Files>? files;

  Announcements({
    this.id,
    this.name,
    this.description,
    this.date,
    this.status,
    this.author,
    this.files,
  });

  Announcements.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    date = json['date'];
    status = json['status'];
    author = json['author'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['date'] = date;
    data['status'] = status;
    data['author'] = author;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Files {
  int? id;
  String? fileName;
  String? fileUrl;

  Files({this.id, this.fileName, this.fileUrl});

  Files.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fileName = json['file_name'];
    fileUrl = json['file_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['file_name'] = fileName;
    data['file_url'] = fileUrl;
    return data;
  }
}
