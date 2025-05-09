// To parse this JSON data, do
//
//     final signUpResponseModel = signUpResponseModelFromJson(jsonString);

import 'dart:convert';

SignUpResponseModel signUpResponseModelFromJson(String str) => SignUpResponseModel.fromJson(json.decode(str));

String signUpResponseModelToJson(SignUpResponseModel data) => json.encode(data.toJson());

class SignUpResponseModel {
  String? message;
  SignUpResponseData? data;
  int? status;

  SignUpResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) => SignUpResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : SignUpResponseData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class SignUpResponseData {
  String? uuid;
  String? name;
  String? email;
  String? contactNumber;
  String? countryUuid;
  String? password;
  bool? active;
  String? userUuid;

  SignUpResponseData({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.countryUuid,
    this.password,
    this.active,
    this.userUuid,
  });

  factory SignUpResponseData.fromJson(Map<String, dynamic> json) => SignUpResponseData(
    uuid: json["uuid"],
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    countryUuid: json["countryUuid"],
    password: json["password"],
    active: json["active"],
    userUuid: json["userUuid"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid ?? '',
    "name": name ?? '',
    "email": email ?? '',
    "contactNumber": contactNumber ?? '',
    "countryUuid": countryUuid ?? '',
    "password": password ?? ''  ,
    "active": active ?? true,
    "userUuid": userUuid ?? '',
  };
}
