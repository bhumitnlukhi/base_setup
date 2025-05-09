// To parse this JSON data, do
//
//     final adListRequestModel = adListRequestModelFromJson(jsonString);

import 'dart:convert';

AdListRequestModel adListRequestModelFromJson(String str) => AdListRequestModel.fromJson(json.decode(str));

String adListRequestModelToJson(AdListRequestModel data) => json.encode(data.toJson());

class AdListRequestModel {
  String? searchKeyword;
  int? createdAt;
  String? vendorUuid;
  String? storeUuid;
  String? agencyUuid;
  bool? isGetOnlyClient;
  String? cilentMasterUuid;
  String? destinationUuid;
  bool? activeRecords;
  bool? isDefault;
  bool? isArchive;

  AdListRequestModel({
    this.searchKeyword,
    this.createdAt,
    this.vendorUuid,
    this.storeUuid,
    this.agencyUuid,
    this.isGetOnlyClient,
    this.cilentMasterUuid,
    this.activeRecords,
    this.isDefault,
    this.destinationUuid,
    this.isArchive
  });

  factory AdListRequestModel.fromJson(Map<String, dynamic> json) => AdListRequestModel(
    searchKeyword: json["searchKeyword"],
    createdAt: json["createdAt"],
    vendorUuid: json["vendorUuid"],
    storeUuid: json["storeUuid"],
    agencyUuid: json["agencyUuid"],
    isGetOnlyClient: json["isGetOnlyClient"],
    cilentMasterUuid: json["cilentMasterUuid"],
    activeRecords: json["activeRecords"],
    isDefault: json["isDefault"],
    isArchive: json["isArchive"],
    destinationUuid: json["destinationUuid"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword,
    "createdAt": createdAt,
    "vendorUuid": vendorUuid,
    "storeUuid": storeUuid,
    "agencyUuid": agencyUuid,
    "isGetOnlyClient": isGetOnlyClient,
    "cilentMasterUuid": cilentMasterUuid,
    "activeRecords": activeRecords,
    "isDefault": isDefault,
    "isArchive": isArchive,
    "destinationUuid": destinationUuid
  };
}