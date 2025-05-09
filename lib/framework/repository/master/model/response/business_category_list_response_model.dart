// To parse this JSON data, do
//
//     final businessCategoryListResponseModel = businessCategoryListResponseModelFromJson(jsonString);

import 'dart:convert';

BusinessCategoryListResponseModel businessCategoryListResponseModelFromJson(String str) => BusinessCategoryListResponseModel.fromJson(json.decode(str));

String businessCategoryListResponseModelToJson(BusinessCategoryListResponseModel data) => json.encode(data.toJson());

class BusinessCategoryListResponseModel {
  int? pageNumber;
  List<BusinessCategoryData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  BusinessCategoryListResponseModel({
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

  factory BusinessCategoryListResponseModel.fromJson(Map<String, dynamic> json) => BusinessCategoryListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<BusinessCategoryData>.from(json["data"]!.map((x) => BusinessCategoryData.fromJson(x))),
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

class BusinessCategoryData {
  String? uuid;
  String? name;
  bool? active;

  BusinessCategoryData({
    this.uuid,
    this.name,
    this.active,
  });

  factory BusinessCategoryData.fromJson(Map<String, dynamic> json) => BusinessCategoryData(
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
