// To parse this JSON data, do
//
//     final commonResponseModelWithMobile = commonResponseModelWithMobileFromJson(jsonString);

import 'dart:convert';

CommonResponseModelWithMobile commonResponseModelWithMobileFromJson(String str) => CommonResponseModelWithMobile.fromJson(json.decode(str));

String commonResponseModelWithMobileToJson(CommonResponseModelWithMobile data) => json.encode(data.toJson());

class CommonResponseModelWithMobile {
  bool? success;
  int? status;
  String? message;
  Data? data;

  CommonResponseModelWithMobile({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory CommonResponseModelWithMobile.fromJson(Map<String, dynamic> json) => CommonResponseModelWithMobile(
    success: json['success'],
    status: json['status'],
    message: json['message'],
    data: json['data'] == null ? null : Data.fromJson(json['data']),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

class Data {
  String? mobile;

  Data({
    this.mobile,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    mobile: json['mobile'],
  );

  Map<String, dynamic> toJson() => {
    'mobile': mobile,
  };
}
