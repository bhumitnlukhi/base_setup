// To parse this JSON data, do
//
//     final clientAddRequestModel = clientAddRequestModelFromJson(jsonString);

import 'dart:convert';

ClientAddRequestModel clientAddRequestModelFromJson(String str) => ClientAddRequestModel.fromJson(json.decode(str));

String clientAddRequestModelToJson(ClientAddRequestModel data) => json.encode(data.toJson());

class ClientAddRequestModel {
  String? name;
  String? email;
  String? contactNumber;
  String? password;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? businessCategoryUuid;
  String? postalCode;

  ClientAddRequestModel({
    this.name,
    this.email,
    this.contactNumber,
    this.password,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.businessCategoryUuid,
    this.postalCode,
  });

  factory ClientAddRequestModel.fromJson(Map<String, dynamic> json) => ClientAddRequestModel(
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    password: json["password"],
    houseNumber: json["houseNumber"],
    streetName: json["streetName"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    landmark: json["landmark"],
    cityUuid: json["cityUuid"],
    stateUuid: json["stateUuid"],
    countryUuid: json["countryUuid"],
    businessCategoryUuid: json["businessCategoryUuid"],
    postalCode: json["postalCode"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "contactNumber": contactNumber,
    "password": password,
    "houseNumber": houseNumber,
    "streetName": streetName,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "landmark": landmark,
    "cityUuid": cityUuid,
    "stateUuid": stateUuid,
    "countryUuid": countryUuid,
    "businessCategoryUuid": businessCategoryUuid,
    "postalCode": postalCode,
  };
}
