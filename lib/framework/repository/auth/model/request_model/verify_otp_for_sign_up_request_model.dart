// To parse this JSON data, do
//
//     final verifyOtpRequestModel = verifyOtpRequestModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpForSignUpRequestModel verifyOtpForSignUpRequestModelFromJson(String str) => VerifyOtpForSignUpRequestModel.fromJson(json.decode(str));

String verifyOtpForSignUpRequestModelToJson(VerifyOtpForSignUpRequestModel data) => json.encode(data.toJson());

class VerifyOtpForSignUpRequestModel {
  String? uuid;
  String? password;
  String? userType;
  String? otp;
  String? sendingType;
  String? type;

  VerifyOtpForSignUpRequestModel({
    this.uuid,
    this.password,
    this.userType,
    this.otp,
    this.sendingType,
    this.type,
  });

  factory VerifyOtpForSignUpRequestModel.fromJson(Map<String, dynamic> json) => VerifyOtpForSignUpRequestModel(
    uuid: json["uuid"],
    password: json["password"],
    userType: json["userType"],
    otp: json["otp"],
    sendingType: json["sendingType"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid ?? '',
    "password": password ?? '',
    "userType": userType ?? '',
    "otp": otp ?? '',
    "sendingType": sendingType ?? '',
    "type": type ?? '',
  };
}
