// To parse this JSON data, do
//
//     final getAgencyDetailResponseModel = getAgencyDetailResponseModelFromJson(jsonString);

import 'dart:convert';

GetAgencyDetailResponseModel getAgencyDetailResponseModelFromJson(String str) => GetAgencyDetailResponseModel.fromJson(json.decode(str));

String getAgencyDetailResponseModelToJson(GetAgencyDetailResponseModel data) => json.encode(data.toJson());

class GetAgencyDetailResponseModel {
  String? message;
  Data? data;
  int? status;

  GetAgencyDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory GetAgencyDetailResponseModel.fromJson(Map<String, dynamic> json) => GetAgencyDetailResponseModel(
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
  String? ownerName;
  String? email;
  String? contactNumber;
  dynamic password;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? postalCode;
  dynamic userUuid;
  bool? active;
  String? countryName;
  String? stateName;
  String? cityName;
  String? agencyStatus;
  VerificationDetails? verificationDetails;

  Data({
    this.uuid,
    this.name,
    this.ownerName,
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
    this.postalCode,
    this.userUuid,
    this.active,
    this.countryName,
    this.stateName,
    this.cityName,
    this.agencyStatus,
    this.verificationDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json["uuid"],
    name: json["name"],
    ownerName: json["ownerName"],
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
    postalCode: json["postalCode"],
    userUuid: json["userUuid"],
    active: json["active"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    cityName: json["cityName"],
    agencyStatus: json["agencyStatus"],
    verificationDetails: json["verificationDetails"] == null ? null : VerificationDetails.fromJson(json["verificationDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid ?? '',
    "name": name?? '',
    "ownerName": ownerName?? '',
    "email": email?? '',
    "contactNumber": contactNumber?? '',
    "password": password?? '',
    "houseNumber": houseNumber?? '',
    "streetName": streetName?? '',
    "addressLine1": addressLine1?? '',
    "addressLine2": addressLine2?? '',
    "landmark": landmark?? '',
    "cityUuid": cityUuid?? '',
    "stateUuid": stateUuid?? '',
    "countryUuid": countryUuid?? '',
    "postalCode": postalCode?? '',
    "userUuid": userUuid?? '',
    "active": active?? true,
    "countryName": countryName?? '',
    "stateName": stateName?? '',
    "cityName": cityName?? '',
    "agencyStatus": agencyStatus?? true,
    "verificationDetails": verificationDetails?.toJson(),
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
