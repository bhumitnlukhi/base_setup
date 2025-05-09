// To parse this JSON data, do
//
//     final clientListResponseModel = clientListResponseModelFromJson(jsonString);

import 'dart:convert';

ClientListResponseModel clientListResponseModelFromJson(String str) => ClientListResponseModel.fromJson(json.decode(str));

String clientListResponseModelToJson(ClientListResponseModel data) => json.encode(data.toJson());

class ClientListResponseModel {
  int? pageNumber;
  List<Datum>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  ClientListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory ClientListResponseModel.fromJson(Map<String, dynamic> json) => ClientListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class Datum {
  String? uuid;
  String? name;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? countryName;
  String? stateName;
  String? cityName;
  String? postalCode;
  Agency? agency;
  BusinessCategory? businessCategory;
  bool? active;

  Datum({
    this.uuid,
    this.name,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.countryName,
    this.stateName,
    this.cityName,
    this.postalCode,
    this.agency,
    this.businessCategory,
    this.active,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    uuid: json["uuid"],
    name: json["name"],
    houseNumber: json["houseNumber"],
    streetName: json["streetName"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    landmark: json["landmark"],
    cityUuid: json["cityUuid"],
    stateUuid: json["stateUuid"],
    countryUuid: json["countryUuid"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    cityName: json["cityName"],
    postalCode: json["postalCode"],
    agency: json["agency"] == null ? null : Agency.fromJson(json["agency"]),
    businessCategory: json["businessCategory"] == null ? null : BusinessCategory.fromJson(json["businessCategory"]),
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "houseNumber": houseNumber,
    "streetName": streetName,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "landmark": landmark,
    "cityUuid": cityUuid,
    "stateUuid": stateUuid,
    "countryUuid": countryUuid,
    "countryName": countryName,
    "stateName": stateName,
    "cityName": cityName,
    "postalCode": postalCode,
    "agency": agency?.toJson(),
    "businessCategory": businessCategory?.toJson(),
    "active": active,
  };
}

class Agency {
  String? uuid;
  String? name;
  String? email;
  String? contactNumber;
  dynamic password;
  dynamic ownerName;
  dynamic houseNumber;
  dynamic streetName;
  dynamic addressLine1;
  dynamic addressLine2;
  dynamic landmark;
  dynamic cityUuid;
  dynamic stateUuid;
  dynamic countryUuid;
  dynamic postalCode;
  dynamic countryName;
  dynamic stateName;
  dynamic cityName;
  String? agencyStatus;
  dynamic verificationDetails;

  Agency({
    this.uuid,
    this.name,
    this.email,
    this.contactNumber,
    this.password,
    this.ownerName,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.postalCode,
    this.countryName,
    this.stateName,
    this.cityName,
    this.agencyStatus,
    this.verificationDetails,
  });

  factory Agency.fromJson(Map<String, dynamic> json) => Agency(
    uuid: json["uuid"],
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    password: json["password"],
    ownerName: json["ownerName"],
    houseNumber: json["houseNumber"],
    streetName: json["streetName"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    landmark: json["landmark"],
    cityUuid: json["cityUuid"],
    stateUuid: json["stateUuid"],
    countryUuid: json["countryUuid"],
    postalCode: json["postalCode"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    cityName: json["cityName"],
    agencyStatus: json["agencyStatus"],
    verificationDetails: json["verificationDetails"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "email": email,
    "contactNumber": contactNumber,
    "password": password,
    "ownerName": ownerName,
    "houseNumber": houseNumber,
    "streetName": streetName,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "landmark": landmark,
    "cityUuid": cityUuid,
    "stateUuid": stateUuid,
    "countryUuid": countryUuid,
    "postalCode": postalCode,
    "countryName": countryName,
    "stateName": stateName,
    "cityName": cityName,
    "agencyStatus": agencyStatus,
    "verificationDetails": verificationDetails,
  };
}

class BusinessCategory {
  String? uuid;
  String? name;
  bool? active;

  BusinessCategory({
    this.uuid,
    this.name,
    this.active,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) => BusinessCategory(
    uuid: json["uuid"],
    name: json["name"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "active": active,
  };
}
