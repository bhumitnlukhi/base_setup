// To parse this JSON data, do
//
//     final verifyOtpRequestModel = verifyOtpRequestModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpRequestModel verifyOtpRequestModelFromJson(String str) => VerifyOtpRequestModel.fromJson(json.decode(str));

String verifyOtpRequestModelToJson(VerifyOtpRequestModel data) => json.encode(data.toJson());

class VerifyOtpRequestModel {
  String? email;
  String? userType;
  String? otp;
  String? sendingType;
  String? type;

  VerifyOtpRequestModel({
    this.email,
    this.userType,
    this.otp,
    this.sendingType,
    this.type,
  });

  factory VerifyOtpRequestModel.fromJson(Map<String, dynamic> json) => VerifyOtpRequestModel(
    email: json["email"],
    userType: json["userType"],
    otp: json["otp"],
    sendingType: json["sendingType"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "email": email ?? '',
    "userType": userType ?? '',
    "otp": otp ?? '',
    "sendingType": sendingType ?? '',
    "type": type ?? '',
  };
}
