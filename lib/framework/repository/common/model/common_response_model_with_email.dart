// To parse this JSON data, do
//
//     final commonResponseModelWithEmail = commonResponseModelWithEmailFromJson(jsonString);

import 'dart:convert';

CommonResponseModelWithEmail commonResponseModelWithEmailFromJson(String str) =>
    CommonResponseModelWithEmail.fromJson(json.decode(str));

String commonResponseModelWithEmailToJson(CommonResponseModelWithEmail data) =>
    json.encode(data.toJson());

class CommonResponseModelWithEmail {
  bool? success;
  int? status;
  String? message;
  Data? data;

  CommonResponseModelWithEmail({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory CommonResponseModelWithEmail.fromJson(Map<String, dynamic> json) =>
      CommonResponseModelWithEmail(
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
  String? email;

  Data({this.email});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {'email': email};
}
