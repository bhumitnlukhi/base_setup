// To parse this JSON data, do
//
//     final vendorDetailResponseModel = vendorDetailResponseModelFromJson(jsonString);

import 'dart:convert';

VendorDetailResponseModel vendorDetailResponseModelFromJson(String str) => VendorDetailResponseModel.fromJson(json.decode(str));

String vendorDetailResponseModelToJson(VendorDetailResponseModel data) => json.encode(data.toJson());

class VendorDetailResponseModel {
  String? message;
  Data? data;
  int? status;

  VendorDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory VendorDetailResponseModel.fromJson(Map<String, dynamic> json) => VendorDetailResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class Data {
  String? uuid;
  String? name;
  String? email;
  String? contactNumber;
  String? status;
  String? countryuuid;
  String? countryName;
  VerificationDetails? verificationDetails;
  bool? active;
  int? wallet;

  Data({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.status,
    this.countryuuid,
    this.countryName,
    this.verificationDetails,
    this.active,
    this.wallet,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json["uuid"],
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    status: json["status"],
    countryuuid: json["countryuuid"],
    countryName: json["countryName"],
    verificationDetails: json["verificationDetails"] == null ? null : VerificationDetails.fromJson(json["verificationDetails"]),
    active: json["active"],
    wallet: json["wallet"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "email": email,
    "contactNumber": contactNumber,
    "status": status,
    "countryuuid": countryuuid,
    "countryName": countryName,
    "verificationDetails": verificationDetails?.toJson(),
    "active": active,
    "wallet": wallet,
  };
}

class VerificationDetails {
  String? status;
  dynamic rejectReason;

  VerificationDetails({
    this.status,
    this.rejectReason,
  });

  factory VerificationDetails.fromJson(Map<String, dynamic> json) => VerificationDetails(
    status: json["status"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "rejectReason": rejectReason,
  };
}