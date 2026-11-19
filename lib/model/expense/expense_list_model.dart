class ExpenseListModel {
  bool? status;
  String? message;
  List<ExpenseDetails>? expenseDetails;

  ExpenseListModel({this.status, this.message, this.expenseDetails});

  ExpenseListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['expense_details'] != null) {
      expenseDetails = <ExpenseDetails>[];
      json['expense_details'].forEach((v) {
        expenseDetails!.add(ExpenseDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (expenseDetails != null) {
      data['expense_details'] = expenseDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ExpenseDetails {
  int? id;
  String? date;
  String? amount;
  String? remark;
  String? status;
  List<Categories>? categories;
  List<Images>? images;

  ExpenseDetails({
    this.id,
    this.date,
    this.amount,
    this.remark,
    this.status,
    this.categories,
    this.images,
  });

  ExpenseDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '');
    date = json['date']?.toString();
    amount = json['amount']?.toString();
    remark = json['remark']?.toString();
    status = json['status']?.toString();
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['amount'] = amount;
    data['remark'] = remark;
    data['status'] = status;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
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

class Images {
  int? id;
  String? imageUrl;

  Images({this.id, this.imageUrl});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    return data;
  }
}
