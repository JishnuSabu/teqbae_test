class HrManagerExpenseApproveListModel {
  bool? status;
  String? message;
  List<Expenses>? expenses;

  HrManagerExpenseApproveListModel({this.status, this.message, this.expenses});

  HrManagerExpenseApproveListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['expenses'] != null) {
      expenses = <Expenses>[];
      json['expenses'].forEach((v) {
        expenses!.add(new Expenses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = status;
    data['message'] = message;
    if (expenses != null) {
      data['expenses'] = expenses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expenses {
  String? id;
  String? userId;
  String? employeeName;
  String? date;
  String? categoryId;
  String? category;
  String? amount;
  String? remark;
  String? status;
  String? approvedBy;
  String? approverName;

  Expenses({
    this.id,
    this.userId,
    this.employeeName,
    this.date,
    this.categoryId,
    this.category,
    this.amount,
    this.remark,
    this.status,
    this.approvedBy,
    this.approverName,
  });

  Expenses.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    userId = json['user_id']?.toString();
    employeeName = json['employee_name']?.toString();
    date = json['date']?.toString();
    categoryId = json['category_id']?.toString();
    category = json['category']?.toString();
    amount = json['amount']?.toString();
    remark = json['remark']?.toString();
    status = json['status']?.toString();
    approvedBy = json['approved_by']?.toString();
    approverName = json['approver_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['user_id'] = userId;
    data['employee_name'] = employeeName;
    data['date'] = date;
    data['category_id'] = categoryId;
    data['category'] = category;
    data['amount'] = amount;
    data['remark'] = remark;
    data['status'] = status;
    data['approved_by'] = approvedBy;
    data['approver_name'] = approverName;
    return data;
  }
}
