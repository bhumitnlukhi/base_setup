// To parse this JSON data, do
//
//     final adsListResponseModel = adsListResponseModelFromJson(jsonString);

import 'dart:convert';

AdsListResponseModel adsListResponseModelFromJson(String str) => AdsListResponseModel.fromJson(json.decode(str));

String adsListResponseModelToJson(AdsListResponseModel data) => json.encode(data.toJson());

class AdsListResponseModel {
  int? pageNumber;
  List<AdsListData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  AdsListResponseModel({
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

  factory AdsListResponseModel.fromJson(Map<String, dynamic> json) => AdsListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<AdsListData>.from(json["data"]!.map((x) => AdsListData.fromJson(x))),
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

class AdsListData {
  String? uuid;
  String? status;
  String? adsByUuid;
  String? adsByName;
  String? adsByType;
  String? destinationUuid;
  String? destinationName;
  bool? isDefault;
  int? createdAt;
  bool? active;
  String? rejectReason;
  String? adsMediaType;

  AdsListData({
    this.uuid,
    this.status,
    this.adsByUuid,
    this.adsByName,
    this.adsByType,
    this.destinationUuid,
    this.destinationName,
    this.isDefault,
    this.createdAt,
    this.active,
    this.rejectReason,
    this.adsMediaType,
  });

  factory AdsListData.fromJson(Map<String, dynamic> json) => AdsListData(
    uuid: json["uuid"],
    status: json["status"],
    adsByUuid: json["adsByUuid"],
    adsByName: json["adsByName"],
    adsByType: json["adsByType"],
    destinationUuid: json["destinationUuid"],
    destinationName: json["destinationName"],
    isDefault: json["isDefault"],
    createdAt: json["createdAt"],
    active: json["active"],
    rejectReason: json["rejectReason"],
    adsMediaType:json["adsMediaType"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "status": status,
    "adsByUuid": adsByUuid,
    "adsByName": adsByName,
    "adsByType": adsByType,
    "destinationUuid": destinationUuid,
    "destinationName": destinationName,
    "isDefault": isDefault,
    "createdAt": createdAt,
    "active": active,
    "rejectReason":rejectReason,
    "adsMediaType":adsMediaType,
  };
}