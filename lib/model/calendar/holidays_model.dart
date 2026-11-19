class HolidaysModel {
  bool? status;
  String? message;
  Holidays? holidays;

  HolidaysModel({this.status, this.message, this.holidays});

  HolidaysModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];

    holidays = json['holidays'] != null
        ? Holidays.fromJson(json['holidays'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['status'] = status;
    data['message'] = message;

    if (holidays != null) {
      data['holidays'] = holidays!.toJson();
    }

    return data;
  }
}

class Holidays {
  List<Holiday> january;
  List<Holiday> february;
  List<Holiday> march;
  List<Holiday> april;
  List<Holiday> may;
  List<Holiday> june;
  List<Holiday> july;
  List<Holiday> august;
  List<Holiday> september;
  List<Holiday> october;
  List<Holiday> november;
  List<Holiday> december;

  Holidays({
    this.january = const [],
    this.february = const [],
    this.march = const [],
    this.april = const [],
    this.may = const [],
    this.june = const [],
    this.july = const [],
    this.august = const [],
    this.september = const [],
    this.october = const [],
    this.november = const [],
    this.december = const [],
  });

  Holidays.fromJson(Map<String, dynamic> json)
    : january = _parseHolidays(json['january']),
      february = _parseHolidays(json['february']),
      march = _parseHolidays(json['march']),
      april = _parseHolidays(json['april']),
      may = _parseHolidays(json['may']),
      june = _parseHolidays(json['june']),
      july = _parseHolidays(json['july']),
      august = _parseHolidays(json['august']),
      september = _parseHolidays(json['september']),
      october = _parseHolidays(json['october']),
      november = _parseHolidays(json['november']),
      december = _parseHolidays(json['december']);

  static List<Holiday> _parseHolidays(dynamic value) {
    if (value == null || value is! List) {
      return [];
    }

    return value
        .map((item) => Holiday.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'january': january.map((v) => v.toJson()).toList(),
      'february': february.map((v) => v.toJson()).toList(),
      'march': march.map((v) => v.toJson()).toList(),
      'april': april.map((v) => v.toJson()).toList(),
      'may': may.map((v) => v.toJson()).toList(),
      'june': june.map((v) => v.toJson()).toList(),
      'july': july.map((v) => v.toJson()).toList(),
      'august': august.map((v) => v.toJson()).toList(),
      'september': september.map((v) => v.toJson()).toList(),
      'october': october.map((v) => v.toJson()).toList(),
      'november': november.map((v) => v.toJson()).toList(),
      'december': december.map((v) => v.toJson()).toList(),
    };
  }
}

class Holiday {
  int? id;
  String? holidayName;
  String? holidayDate;
  String? reason;
  String? leaveMode;
  int? status;

  Holiday({
    this.id,
    this.holidayName,
    this.holidayDate,
    this.reason,
    this.leaveMode,
    this.status,
  });

  Holiday.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    holidayName = json['holiday_name'];
    holidayDate = json['holiday_date'];
    reason = json['reason'];
    leaveMode = json['leave_mode'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'holiday_name': holidayName,
      'holiday_date': holidayDate,
      'reason': reason,
      'leave_mode': leaveMode,
      'status': status,
    };
  }
}
