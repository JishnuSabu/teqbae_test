class NotificationModel {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String section; // "Today", "Yesterday", "Earlier"
  final String category; // "Leave", "Expenses", "Payroll", "Attendance"
  final bool isRead;
  final String icon;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.section,
    required this.category,
    required this.isRead,
    required this.icon,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? time,
    String? section,
    String? category,
    bool? isRead,
    String? icon,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      section: section ?? this.section,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
    );
  }
}
