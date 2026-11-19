class ExpenseCategoryModel {
  bool? status;
  String? message;
  List<ExpenseCategories>? expenseCategories;

  ExpenseCategoryModel({this.status, this.message, this.expenseCategories});

  ExpenseCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['expense_categories'] != null) {
      expenseCategories = <ExpenseCategories>[];
      json['expense_categories'].forEach((v) {
        expenseCategories!.add(ExpenseCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (expenseCategories != null) {
      data['expense_categories'] = expenseCategories!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class ExpenseCategories {
  int? id;
  String? name;

  ExpenseCategories({this.id, this.name});

  ExpenseCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
