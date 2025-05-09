// To parse this JSON data, do
//
//     final adsDetailResponseModel = adsDetailResponseModelFromJson(jsonString);

import 'dart:convert';

AdsDetailResponseModel adsDetailResponseModelFromJson(String str) => AdsDetailResponseModel.fromJson(json.decode(str));

String adsDetailResponseModelToJson(AdsDetailResponseModel data) => json.encode(data.toJson());

class AdsDetailResponseModel {
  String? message;
  Data? data;
  int? status;

  AdsDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory AdsDetailResponseModel.fromJson(Map<String, dynamic> json) => AdsDetailResponseModel(
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
  String? adsByUuid;
  String? adsByName;
  String? adsByType;
  dynamic agencyUuid;
  dynamic agencyName;
  Destination? destination;
  bool? isDefault;
  int? createdAt;
  bool? active;
  bool? isArchive;
  String? adsMediaType;
  int? contentLength;
  String? status;
  dynamic rejectReason;

  Data({
    this.uuid,
    this.adsByUuid,
    this.adsByName,
    this.adsByType,
    this.agencyUuid,
    this.agencyName,
    this.destination,
    this.isDefault,
    this.createdAt,
    this.active,
    this.isArchive,
    this.adsMediaType,
    this.contentLength,
    this.status,
    this.rejectReason,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json["uuid"],
    adsByUuid: json["adsByUuid"],
    adsByName: json["adsByName"],
    adsByType: json["adsByType"],
    agencyUuid: json["agencyUuid"],
    agencyName: json["agencyName"],
    destination: json["destination"] == null ? null : Destination.fromJson(json["destination"]),
    isDefault: json["isDefault"],
    createdAt: json["createdAt"],
    active: json["active"],
    isArchive: json["isArchive"],
    adsMediaType: json["adsMediaType"],
    contentLength: json["contentLength"],
    status: json["status"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "adsByUuid": adsByUuid,
    "adsByName": adsByName,
    "adsByType": adsByType,
    "agencyUuid": agencyUuid,
    "agencyName": agencyName,
    "destination": destination?.toJson(),
    "isDefault": isDefault,
    "createdAt": createdAt,
    "active": active,
    "isArchive": isArchive,
    "adsMediaType": adsMediaType,
    "contentLength": contentLength,
    "status": status,
    "rejectReason": rejectReason,
  };
}

class Destination {
  String? uuid;
  String? name;
  String? destinationTypeUuid;
  String? destinationTypeName;
  int? startHour;
  int? endHour;
  int? totalFloor;
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
  String? imageUrl;
  String? email;
  String? contactNumber;
  bool? active;
  String? ownerName;

  Destination({
    this.uuid,
    this.name,
    this.destinationTypeUuid,
    this.destinationTypeName,
    this.startHour,
    this.endHour,
    this.totalFloor,
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
    this.imageUrl,
    this.email,
    this.contactNumber,
    this.active,
    this.ownerName,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
    uuid: json["uuid"],
    name: json["name"],
    destinationTypeUuid: json["destinationTypeUuid"],
    destinationTypeName: json["destinationTypeName"],
    startHour: json["startHour"],
    endHour: json["endHour"],
    totalFloor: json["totalFloor"],
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
    imageUrl: json["imageUrl"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    active: json["active"],
    ownerName: json["ownerName"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "destinationTypeUuid": destinationTypeUuid,
    "destinationTypeName": destinationTypeName,
    "startHour": startHour,
    "endHour": endHour,
    "totalFloor": totalFloor,
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
    "imageUrl": imageUrl,
    "email": email,
    "contactNumber": contactNumber,
    "active": active,
    "ownerName": ownerName,
  };
}
