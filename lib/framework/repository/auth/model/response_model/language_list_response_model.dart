// To parse this JSON data, do
//
//     final languageListResponseModel = languageListResponseModelFromJson(jsonString);

import 'dart:convert';

LanguageListResponseModel languageListResponseModelFromJson(String str) => LanguageListResponseModel.fromJson(json.decode(str));

String languageListResponseModelToJson(LanguageListResponseModel data) => json.encode(data.toJson());

class LanguageListResponseModel {
  int? pageNumber;
  List<LanguageData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  LanguageListResponseModel({
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

  factory LanguageListResponseModel.fromJson(Map<String, dynamic> json) => LanguageListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<LanguageData>.from(json["data"]!.map((x) => LanguageData.fromJson(x))),
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

class LanguageData {
  String? uuid;
  String? name;
  String? code;
  bool? isRtl;
  bool? isDefault;
  bool? active;

  LanguageData({
    this.uuid,
    this.name,
    this.code,
    this.isRtl,
    this.isDefault,
    this.active,
  });

  factory LanguageData.fromJson(Map<String, dynamic> json) => LanguageData(
    uuid: json["uuid"],
    name: json["name"],
    code: json["code"],
    isRtl: json["isRTL"],
    isDefault: json["isDefault"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "code": code,
    "isRTL": isRtl,
    "isDefault": isDefault,
    "active": active,
  };
}
