// To parse this JSON data, do
//
//     final storeListRequestModel = storeListRequestModelFromJson(jsonString);

import 'dart:convert';

StoreListRequestModel storeListRequestModelFromJson(String str) => StoreListRequestModel.fromJson(json.decode(str));

String storeListRequestModelToJson(StoreListRequestModel data) => json.encode(data.toJson());

class StoreListRequestModel {
  String? searchKeyword;
  bool? activeRecords;
  String? destinationUuid;
  String? businessCategoryUuid;

  StoreListRequestModel({
    this.searchKeyword,
    this.activeRecords,
    this.destinationUuid,
    this.businessCategoryUuid,
  });

  factory StoreListRequestModel.fromJson(Map<String, dynamic> json) => StoreListRequestModel(
    searchKeyword: json["searchKeyword"],
    activeRecords: json["activeRecords"],
    destinationUuid: json["destinationUuid"],
    businessCategoryUuid: json["businessCategoryUuid"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword ?? '',
    "activeRecords": activeRecords ?? '',
    "destinationUuid": destinationUuid ?? '',
    "businessCategoryUuid": businessCategoryUuid ?? '',
  };
}