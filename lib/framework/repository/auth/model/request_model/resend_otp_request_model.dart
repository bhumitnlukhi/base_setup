// To parse this JSON data, do
//
//     final resendOtpRequestModel = resendOtpRequestModelFromJson(jsonString);

import 'dart:convert';

ResendOtpRequestModel resendOtpRequestModelFromJson(String str) => ResendOtpRequestModel.fromJson(json.decode(str));

String resendOtpRequestModelToJson(ResendOtpRequestModel data) => json.encode(data.toJson());

class ResendOtpRequestModel {
  String? email;
  String? userType;
  String? type;
  String? sendingType;
  bool? verifyBeforeGenerate;

  ResendOtpRequestModel({
    this.email,
    this.userType,
    this.type,
    this.sendingType,
    this.verifyBeforeGenerate,
  });

  factory ResendOtpRequestModel.fromJson(Map<String, dynamic> json) => ResendOtpRequestModel(
    email: json["email"],
    userType: json["userType"],
    type: json["type"],
    sendingType: json["sendingType"],
    verifyBeforeGenerate: json["verifyBeforeGenerate"],
  );

  Map<String, dynamic> toJson() => {
    "email": email ?? '',
    "userType": userType ?? '',
    "type": type ?? '',
    "sendingType": sendingType ?? '',
    "verifyBeforeGenerate": verifyBeforeGenerate ?? false,
  };
}
