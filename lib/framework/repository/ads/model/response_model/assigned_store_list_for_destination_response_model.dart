// To parse this JSON data, do
//
//     final assignedStoreListForDestinationResponseModel = assignedStoreListForDestinationResponseModelFromJson(jsonString);

import 'dart:convert';

AssignedStoreListForDestinationResponseModel assignedStoreListForDestinationResponseModelFromJson(String str) => AssignedStoreListForDestinationResponseModel.fromJson(json.decode(str));

String assignedStoreListForDestinationResponseModelToJson(AssignedStoreListForDestinationResponseModel data) => json.encode(data.toJson());

class AssignedStoreListForDestinationResponseModel {
  int? pageNumber;
  List<AssignedStoreList>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  AssignedStoreListForDestinationResponseModel({
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

  factory AssignedStoreListForDestinationResponseModel.fromJson(Map<String, dynamic> json) => AssignedStoreListForDestinationResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<AssignedStoreList>.from(json["data"]!.map((x) => AssignedStoreList.fromJson(x))),
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

class AssignedStoreList {
  String? uuid;
  String? name;
  String? businessCategoryUuid;
  String? businessCategoryName;
  int? floorNumber;
  bool? active;

  AssignedStoreList({
    this.uuid,
    this.name,
    this.businessCategoryUuid,
    this.businessCategoryName,
    this.floorNumber,
    this.active,
  });

  factory AssignedStoreList.fromJson(Map<String, dynamic> json) => AssignedStoreList(
    uuid: json["uuid"],
    name: json["name"],
    businessCategoryUuid: json["businessCategoryUuid"],
    businessCategoryName: json["businessCategoryName"],
    floorNumber: json["floorNumber"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "businessCategoryUuid": businessCategoryUuid,
    "businessCategoryName": businessCategoryName,
    "floorNumber": floorNumber,
    "active": active,
  };
}