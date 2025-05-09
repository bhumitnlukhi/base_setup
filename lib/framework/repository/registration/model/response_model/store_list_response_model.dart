// To parse this JSON data, do
//
//     final storeListResponseModel = storeListResponseModelFromJson(jsonString);

import 'dart:convert';

AssignStoreListResponseModel storeListResponseModelFromJson(String str) => AssignStoreListResponseModel.fromJson(json.decode(str));

String assignStoreListResponseModelToJson(AssignStoreListResponseModel data) => json.encode(data.toJson());

class AssignStoreListResponseModel {
  List<StoreData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  AssignStoreListResponseModel({
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory AssignStoreListResponseModel.fromJson(Map<String, dynamic> json) => AssignStoreListResponseModel(
    data: json["data"] == null ? [] : List<StoreData>.from(json["data"]!.map((x) => StoreData.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
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

class StoreData {
  String? uuid;
  String? name;
  String? businessCategoryUuid;
  String? businessCategoryName;
  bool? active;
  bool? isValidate;

  StoreData({
    this.uuid,
    this.name,
    this.businessCategoryUuid,
    this.businessCategoryName,
    this.active,
    this.isValidate
  });

  factory StoreData.fromJson(Map<String, dynamic> json) => StoreData(
    uuid: json["uuid"],
    name: json["name"],
    businessCategoryUuid: json["businessCategoryUuid"],
    businessCategoryName: json["businessCategoryName"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "businessCategoryUuid": businessCategoryUuid,
    "businessCategoryName": businessCategoryName,
    "active": active,
  };
}