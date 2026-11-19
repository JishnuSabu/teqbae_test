class LeaveBalanceModel {
  final int casual;
  final int sick;
  final int total;

  LeaveBalanceModel({
    required this.casual,
    required this.sick,
    required this.total,
  });

  factory LeaveBalanceModel.empty() => LeaveBalanceModel(
        casual: 0,
        sick: 0,
        total: 0,
      );

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      casual: (json['casual'] as num?)?.toInt() ?? 0,
      sick: (json['sick'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'casual': casual,
        'sick': sick,
        'total': total,
      };

  LeaveBalanceModel copyWith({
    int? casual,
    int? sick,
    int? total,
  }) {
    return LeaveBalanceModel(
      casual: casual ?? this.casual,
      sick: sick ?? this.sick,
      total: total ?? this.total,
    );
  }
}
