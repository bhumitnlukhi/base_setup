// To parse this JSON data, do
//
//     final signUpRequestModel = signUpRequestModelFromJson(jsonString);

import 'dart:convert';

SignUpRequestModel signUpRequestModelFromJson(String str) => SignUpRequestModel.fromJson(json.decode(str));

String signUpRequestModelToJson(SignUpRequestModel data) => json.encode(data.toJson());

class SignUpRequestModel {
  String? name;
  String? email;
  String? contactNumber;
  String? password;
  String? countryUuid;

  SignUpRequestModel({
    this.name,
    this.email,
    this.contactNumber,
    this.password,
    this.countryUuid,
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) => SignUpRequestModel(
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    password: json["password"],
    countryUuid: json["countryUuid"],
  );

  Map<String, dynamic> toJson() => {
    "name": name ?? '',
    "email": email ?? '',
    "contactNumber": contactNumber ?? '',
    "password": password ?? '',
    "countryUuid": countryUuid ?? '',
  };
}
