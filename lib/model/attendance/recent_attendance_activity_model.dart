class RecentAttendanceActivityModel {
  bool? status;
  String? message;
  List<RecentActivities>? recentActivities;

  RecentAttendanceActivityModel({
    this.status,
    this.message,
    this.recentActivities,
  });

  RecentAttendanceActivityModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['recent_activities'] != null) {
      recentActivities = <RecentActivities>[];
      json['recent_activities'].forEach((v) {
        recentActivities!.add(RecentActivities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (recentActivities != null) {
      data['recent_activities'] = recentActivities!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class RecentActivities {
  String? type;
  String? date;
  String? time;
  String? location;

  RecentActivities({this.type, this.date, this.time, this.location});

  RecentActivities.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    date = json['date'];
    time = json['time'];
    location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['date'] = date;
    data['time'] = time;
    data['location'] = location;
    return data;
  }
}
