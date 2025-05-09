// To parse this JSON data, do
//
//     final resetPasswordRequestModel = resetPasswordRequestModelFromJson(jsonString);

import 'dart:convert';

ResetPasswordRequestModel resetPasswordRequestModelFromJson(String str) => ResetPasswordRequestModel.fromJson(json.decode(str));

String resetPasswordRequestModelToJson(ResetPasswordRequestModel data) => json.encode(data.toJson());

class ResetPasswordRequestModel {
  String? email;
  String? userType;
  String? type;
  String? otp;
  String? password;

  ResetPasswordRequestModel({
    this.email,
    this.userType,
    this.type,
    this.otp,
    this.password,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) => ResetPasswordRequestModel(
    email: json["email"],
    userType: json["userType"],
    type: json["type"],
    otp: json["otp"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email ?? '',
    "userType": userType ?? '',
    "type": type ?? '',
    "otp": otp ?? '',
    "password": password ?? '',
  };
}
