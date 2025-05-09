// To parse this JSON data, do
//
//     final destinationListResponseModel = destinationListResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationListResponseModel destinationListResponseModelFromJson(String str) => DestinationListResponseModel.fromJson(json.decode(str));

String destinationListResponseModelToJson(DestinationListResponseModel data) => json.encode(data.toJson());

class DestinationListResponseModel {
  int? pageNumber;
  List<DestinationData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  DestinationListResponseModel({
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

  factory DestinationListResponseModel.fromJson(Map<String, dynamic> json) => DestinationListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<DestinationData>.from(json["data"]!.map((x) => DestinationData.fromJson(x))),
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

class DestinationData {
  String? uuid;
  String? name;
  String? destinationTypeUuid;
  String? destinationTypeName;
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
  String? timeZone;

  DestinationData({
    this.uuid,
    this.name,
    this.destinationTypeUuid,
    this.destinationTypeName,
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
    this.timeZone
  });

  factory DestinationData.fromJson(Map<String, dynamic> json) => DestinationData(
    uuid: json["uuid"],
    name: json["name"],
    destinationTypeUuid: json["destinationTypeUuid"],
    destinationTypeName: json["destinationTypeName"],
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
    timeZone: json["timeZone"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "destinationTypeUuid": destinationTypeUuid,
    "destinationTypeName": destinationTypeName,
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
    "timeZone": timeZone,
  };
}
