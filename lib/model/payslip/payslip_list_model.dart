class PayslipListModel {
  bool? status;
  String? message;
  List<Payslips>? payslips;

  PayslipListModel({this.status, this.message, this.payslips});

  PayslipListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['payslips'] != null) {
      payslips = <Payslips>[];
      json['payslips'].forEach((v) {
        payslips!.add(Payslips.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (payslips != null) {
      data['payslips'] = payslips!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Payslips {
  int? id;
  String? period;
  String? startDate;
  String? endDate;
  String? month;
  String? totalAmount;
  String? totalAmountDisplay;
  String? status;

  Payslips({
    this.id,
    this.period,
    this.startDate,
    this.endDate,
    this.month,
    this.totalAmount,
    this.totalAmountDisplay,
    this.status,
  });

  Payslips.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int
        ? json['id']
        : int.tryParse(json['id']?.toString() ?? '');
    period = json['period'];
    startDate = json['start_date'];
    endDate = json['end_date']?.toString();
    month = json['month'];
    totalAmount = json['total_amount']?.toString();
    totalAmountDisplay = json['total_amount_display'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['period'] = period;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['month'] = month;
    data['total_amount'] = totalAmount;
    data['total_amount_display'] = totalAmountDisplay;
    data['status'] = status;
    return data;
  }
}
