// To parse this JSON data, do
//
//     final packageListResponseModel = packageListResponseModelFromJson(jsonString);

import 'dart:convert';

PackageListResponseModel packageListResponseModelFromJson(String str) => PackageListResponseModel.fromJson(json.decode(str));

String packageListResponseModelToJson(PackageListResponseModel data) => json.encode(data.toJson());

class PackageListResponseModel {
  int? pageNumber;
  List<PackageData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  PackageListResponseModel({
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

  factory PackageListResponseModel.fromJson(Map<String, dynamic> json) => PackageListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<PackageData>.from(json["data"]!.map((x) => PackageData.fromJson(x))),
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

class PackageData {
  String? uuid;
  String? destinationUuid;
  String? destinationName;
  String? purchaseByUuid;
  String? purchaseByName;
  String? purchaseByType;
  String? agencyUuid;
  String? agencyName;
  int? startDate;
  int? endDate;
  double? budget;
  double? dailyBudget;
  int? createdAt;
  bool? active;
  String? status;
  String? currency;

  PackageData({
    this.uuid,
    this.destinationUuid,
    this.destinationName,
    this.purchaseByUuid,
    this.purchaseByName,
    this.purchaseByType,
    this.agencyUuid,
    this.agencyName,
    this.startDate,
    this.endDate,
    this.budget,
    this.dailyBudget,
    this.createdAt,
    this.active,
    this.status,
    this.currency,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) => PackageData(
    uuid: json["uuid"],
    destinationUuid: json["destinationUuid"],
    destinationName: json["destinationName"],
    purchaseByUuid: json["purchaseByUuid"],
    purchaseByName: json["purchaseByName"],
    purchaseByType: json["purchaseByType"],
    agencyUuid: json["agencyUuid"],
    agencyName: json["agencyName"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    budget: json["budget"]?.toDouble(),
    dailyBudget: json["dailyBudget"]?.toDouble(),
    createdAt: json["createdAt"],
    active: json["active"],
    status: json["status"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "destinationUuid": destinationUuid,
    "destinationName": destinationName,
    "purchaseByUuid": purchaseByUuid,
    "purchaseByName": purchaseByName,
    "purchaseByType": purchaseByType,
    "agencyUuid": agencyUuid,
    "agencyName": agencyName,
    "startDate": startDate,
    "endDate": endDate,
    "budget": budget,
    "dailyBudget": dailyBudget,
    "createdAt": createdAt,
    "active": active,
    "status": status,
    "currency": currency,
  };
}
