class HelpTicketsListModel {
  bool? status;
  String? message;
  List<HelpTickets>? helpTickets;

  HelpTicketsListModel({this.status, this.message, this.helpTickets});

  HelpTicketsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['help_tickets'] != null) {
      helpTickets = <HelpTickets>[];
      json['help_tickets'].forEach((v) {
        helpTickets!.add(new HelpTickets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (helpTickets != null) {
      data['help_tickets'] = helpTickets!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HelpTickets {
  int? id;
  String? subject;
  String? description;
  Department? department;
  int? status;
  String? priority;
  List<Files>? files;

  HelpTickets({
    this.id,
    this.subject,
    this.description,
    this.department,
    this.status,
    this.priority,
    this.files,
  });

  HelpTickets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    subject = json['subject'];
    description = json['description'];
    department = json['department'] != null
        ? new Department.fromJson(json['department'])
        : null;
    status = json['status'];
    priority = json['priority'];
    if (json['files'] != null) {
      files = <Files>[];
      json['files'].forEach((v) {
        files!.add(new Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['subject'] = subject;
    data['description'] = description;
    if (department != null) {
      data['department'] = department!.toJson();
    }
    data['status'] = status;
    data['priority'] = priority;
    if (files != null) {
      data['files'] = files!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Department {
  int? id;
  String? name;

  Department({this.id, this.name});

  Department.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['file_name'] = fileName;
    data['file_url'] = fileUrl;
    return data;
  }
}
