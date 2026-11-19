class PayslipCurrentMonthDataModel {
  bool? status;
  String? message;
  Data? data;

  PayslipCurrentMonthDataModel({this.status, this.message, this.data});

  PayslipCurrentMonthDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? currentDate;
  String? month;
  String? period;
  int? workingDays;
  int? lopDays;
  String? netPay;
  String? deduction;
  String? creditedOn;
  String? filePath;

  Data({
    this.id,
    this.currentDate,
    this.month,
    this.period,
    this.workingDays,
    this.lopDays,
    this.netPay,
    this.deduction,
    this.creditedOn,
    this.filePath,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    currentDate = json['current_date'];
    month = json['month'];
    period = json['period'];
    workingDays = json['working_days'];
    lopDays = json['lop_days'];
    netPay = json['net_pay'];
    deduction = json['deduction'];
    creditedOn = json['salary_credited_date'];
    filePath = json['file_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['current_date'] = currentDate;
    data['month'] = month;
    data['period'] = period;
    data['working_days'] = workingDays;
    data['lop_days'] = lopDays;
    data['net_pay'] = netPay;
    data['deduction'] = deduction;
    data['salary_credited_date'] = creditedOn;
    data['file_path'] = filePath;
    return data;
  }
}
