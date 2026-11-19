class ExpenseSummaryModel {
  bool? status;
  String? message;
  String? month;
  int? year;
  Counts? counts;
  Amounts? amounts;

  ExpenseSummaryModel({
    this.status,
    this.message,
    this.month,
    this.year,
    this.counts,
    this.amounts,
  });

  ExpenseSummaryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    month = json['month'];
    year = json['year'];
    counts = json['counts'] != null ? Counts.fromJson(json['counts']) : null;
    amounts = json['amounts'] != null
        ? Amounts.fromJson(json['amounts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['month'] = month;
    data['year'] = year;
    if (counts != null) {
      data['counts'] = counts!.toJson();
    }
    if (amounts != null) {
      data['amounts'] = amounts!.toJson();
    }
    return data;
  }
}

class Counts {
  int? approved;
  int? rejected;
  int? pending;
  int? reimbursed;

  Counts({this.approved, this.rejected, this.pending, this.reimbursed});

  Counts.fromJson(Map<String, dynamic> json) {
    approved = json['approved'];
    rejected = json['rejected'];
    pending = json['pending'];
    reimbursed = json['reimbursed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approved'] = approved;
    data['rejected'] = rejected;
    data['pending'] = pending;
    data['reimbursed'] = reimbursed;
    return data;
  }
}

class Amounts {
  int? approved;
  int? rejected;
  int? pending;
  int? reimbursed;
  int? total;

  Amounts({
    this.approved,
    this.rejected,
    this.pending,
    this.reimbursed,
    this.total,
  });

  Amounts.fromJson(Map<String, dynamic> json) {
    approved = json['approved'];
    rejected = json['rejected'];
    pending = json['pending'];
    reimbursed = json['reimbursed'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['approved'] = approved;
    data['rejected'] = rejected;
    data['pending'] = pending;
    data['reimbursed'] = reimbursed;
    data['total'] = total;
    return data;
  }
}
