class ForgotPasswordOtpRequestModel {
  bool? status;
  String? message;
  int? userId;
  int? resendAfter;

  ForgotPasswordOtpRequestModel({
    this.status,
    this.message,
    this.userId,
    this.resendAfter,
  });

  ForgotPasswordOtpRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    resendAfter = json['resend_after'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['user_id'] = userId;
    data['resend_after'] = resendAfter;
    return data;
  }
}
