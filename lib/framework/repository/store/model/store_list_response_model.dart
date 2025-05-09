// To parse this JSON data, do
//
//     final storeListResponseModel = storeListResponseModelFromJson(jsonString);

import 'dart:convert';

StoreListResponseModel storeListResponseModelFromJson(String str) => StoreListResponseModel.fromJson(json.decode(str));

String storeListResponseModelToJson(StoreListResponseModel data) => json.encode(data.toJson());

class StoreListResponseModel {
  int? pageNumber;
  List<StoreListData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  StoreListResponseModel({
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

  factory StoreListResponseModel.fromJson(Map<String, dynamic> json) => StoreListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<StoreListData>.from(json["data"]!.map((x) => StoreListData.fromJson(x))),
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

class StoreListData {
  String? uuid;
  String? odigoStoreUuid;
  String? odigoStoreName;
  List<BusinessCategoryLanguageResponseDto>? businessCategoryLanguageResponseDtOs;
  String? destinationUuid;
  String? destinationName;
  String? status;
  String? rejectReason;
  bool? active;
  int? adsCount;
  String? name;
  String? odigoStoreImageUrl;

  StoreListData({
    this.uuid,
    this.odigoStoreUuid,
    this.odigoStoreName,
    this.businessCategoryLanguageResponseDtOs,
    this.destinationUuid,
    this.destinationName,
    this.status,
    this.rejectReason,
    this.active,
    this.adsCount,
    this.name,
    this.odigoStoreImageUrl,
  });

  factory StoreListData.fromJson(Map<String, dynamic> json) => StoreListData(
    uuid: json["uuid"],
    odigoStoreUuid: json["odigoStoreUuid"],
    odigoStoreName: json["odigoStoreName"],
    businessCategoryLanguageResponseDtOs: json["businessCategoryLanguageResponseDTOs"] == null ? [] : List<BusinessCategoryLanguageResponseDto>.from(json["businessCategoryLanguageResponseDTOs"]!.map((x) => BusinessCategoryLanguageResponseDto.fromJson(x))),
    destinationUuid: json["destinationUuid"],
    destinationName: json["destinationName"],
    status: json["status"],
    rejectReason: json["rejectReason"],
    active: json["active"],
    adsCount: json["adsCount"],
    name: json["name"],
    odigoStoreImageUrl: json["odigoStoreImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "odigoStoreUuid": odigoStoreUuid,
    "odigoStoreName": odigoStoreName,
    "businessCategoryLanguageResponseDTOs": businessCategoryLanguageResponseDtOs == null ? [] : List<dynamic>.from(businessCategoryLanguageResponseDtOs!.map((x) => x.toJson())),
    "destinationUuid": destinationUuid,
    "destinationName": destinationName,
    "status": status,
    "rejectReason": rejectReason,
    "active": active,
    "adsCount": adsCount,
    "name":name,
    "odigoStoreImageUrl": odigoStoreImageUrl,
  };
}

class BusinessCategoryLanguageResponseDto {
  String? uuid;
  String? name;
  bool? active;
  String? categoryImageUrl;

  BusinessCategoryLanguageResponseDto({
    this.uuid,
    this.name,
    this.active,
    this.categoryImageUrl,
  });

  factory BusinessCategoryLanguageResponseDto.fromJson(Map<String, dynamic> json) => BusinessCategoryLanguageResponseDto(
    uuid: json["uuid"],
    name: json["name"],
    active: json["active"],
    categoryImageUrl: json["categoryImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "active": active,
    "categoryImageUrl": categoryImageUrl,
  };
}