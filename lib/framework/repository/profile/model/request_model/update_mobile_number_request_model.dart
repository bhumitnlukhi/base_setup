// To parse this JSON data, do
//
//     final updateEmailRequestModel = updateEmailRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateMobileRequestModel updateMobileRequestModelFromJson(String str) => UpdateMobileRequestModel.fromJson(json.decode(str));

String updateMobileRequestModelToJson(UpdateMobileRequestModel data) => json.encode(data.toJson());

class UpdateMobileRequestModel {
  String? contactNumber;
  // String? otp;
  // String? password;

  UpdateMobileRequestModel({
    this.contactNumber,
    // this.otp,
    // this.password,
  });

  factory UpdateMobileRequestModel.fromJson(Map<String, dynamic> json) => UpdateMobileRequestModel(
    contactNumber: json['contactNumber'],
    // otp: json['otp'],
    // password: json['password'],
  );

  Map<String, dynamic> toJson() => {
    'contactNumber': contactNumber,
    // 'otp': otp,
    // 'password': password,
  };
}
