class PayslipDetailsModel {
  bool? status;
  String? message;
  Payslip? payslip;

  PayslipDetailsModel({this.status, this.message, this.payslip});

  PayslipDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    payslip = json['payslip'] != null
        ? Payslip.fromJson(json['payslip'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (payslip != null) {
      data['payslip'] = payslip!.toJson();
    }
    return data;
  }
}

class Payslip {
  int? id;
  int? employeeId;
  String? period;
  String? payMonth;
  int? workingDays;
  int? lopDays;
  String? status;
  String? filePath;
  Earnings? earnings;
  Earnings? deductions;
  Summary? summary;

  Payslip({
    this.id,
    this.employeeId,
    this.period,
    this.payMonth,
    this.workingDays,
    this.lopDays,
    this.status,
    this.filePath,
    this.earnings,
    this.deductions,
    this.summary,
  });

  Payslip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeeId = json['employee_id'];
    period = json['period'];
    payMonth = json['pay_month'];
    workingDays = json['working_days'];
    lopDays = json['lop_days'];
    status = json['status'];
    filePath = json['file_path'];
    earnings = json['earnings'] != null
        ? Earnings.fromJson(json['earnings'])
        : null;
    deductions = json['deductions'] != null
        ? Earnings.fromJson(json['deductions'])
        : null;
    summary = json['summary'] != null
        ? Summary.fromJson(json['summary'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['employee_id'] = employeeId;
    data['period'] = period;
    data['pay_month'] = payMonth;
    data['working_days'] = workingDays;
    data['lop_days'] = lopDays;
    data['status'] = status;
    data['file_path'] = filePath;
    if (earnings != null) {
      data['earnings'] = earnings!.toJson();
    }
    if (deductions != null) {
      data['deductions'] = deductions!.toJson();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    return data;
  }
}

class Earnings {
  String? totalDisplay;
  List<Items>? items;

  Earnings({this.totalDisplay, this.items});

  Earnings.fromJson(Map<String, dynamic> json) {
    totalDisplay = json['total_display'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_display'] = totalDisplay;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? name;
  String? amount;

  Items({this.name, this.amount});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount'] = amount;
    return data;
  }
}

class Summary {
  String? grossPay;
  String? grossPayDisplay;
  String? netPay;
  String? netPayDisplay;

  Summary({
    this.grossPay,
    this.grossPayDisplay,
    this.netPay,
    this.netPayDisplay,
  });

  Summary.fromJson(Map<String, dynamic> json) {
    grossPay = json['gross_pay'];
    grossPayDisplay = json['gross_pay_display'];
    netPay = json['net_pay'];
    netPayDisplay = json['net_pay_display'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gross_pay'] = grossPay;
    data['gross_pay_display'] = grossPayDisplay;
    data['net_pay'] = netPay;
    data['net_pay_display'] = netPayDisplay;
    return data;
  }
}
