// To parse this JSON data, do
//
//     final storeLanguageDetailResponseModel = storeLanguageDetailResponseModelFromJson(jsonString);

import 'dart:convert';

StoreLanguageDetailResponseModel storeLanguageDetailResponseModelFromJson(String str) => StoreLanguageDetailResponseModel.fromJson(json.decode(str));

String storeLanguageDetailResponseModelToJson(StoreLanguageDetailResponseModel data) => json.encode(data.toJson());

class StoreLanguageDetailResponseModel {
  String? message;
  Data? data;
  int? status;

  StoreLanguageDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory StoreLanguageDetailResponseModel.fromJson(Map<String, dynamic> json) => StoreLanguageDetailResponseModel(
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
  String? name;
  List<BusinessCategory>? businessCategories;
  dynamic floorNumber;
  bool? active;
  String? storeImageUrl;

  Data({
    this.uuid,
    this.name,
    this.businessCategories,
    this.floorNumber,
    this.active,
    this.storeImageUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json["uuid"],
    name: json["name"],
    businessCategories: json["businessCategories"] == null ? [] : List<BusinessCategory>.from(json["businessCategories"]!.map((x) => BusinessCategory.fromJson(x))),
    floorNumber: json["floorNumber"],
    active: json["active"],
    storeImageUrl: json["storeImageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "businessCategories": businessCategories == null ? [] : List<dynamic>.from(businessCategories!.map((x) => x.toJson())),
    "floorNumber": floorNumber,
    "active": active,
    "storeImageUrl": storeImageUrl,
  };
}

class BusinessCategory {
  String? uuid;
  String? name;
  bool? active;
  String? categoryImageUrl;
  String? businessCategoryImage;
  String? originalBusinessCategoryImage;

  BusinessCategory({
    this.uuid,
    this.name,
    this.active,
    this.categoryImageUrl,
    this.businessCategoryImage,
    this.originalBusinessCategoryImage,
  });

  factory BusinessCategory.fromJson(Map<String, dynamic> json) => BusinessCategory(
    uuid: json["uuid"],
    name: json["name"],
    active: json["active"],
    categoryImageUrl: json["categoryImageUrl"],
    businessCategoryImage: json["businessCategoryImage"],
    originalBusinessCategoryImage: json["originalBusinessCategoryImage"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "active": active,
    "categoryImageUrl": categoryImageUrl,
    "businessCategoryImage": businessCategoryImage,
    "originalBusinessCategoryImage": originalBusinessCategoryImage,
  };
}
