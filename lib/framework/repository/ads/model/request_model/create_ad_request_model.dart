// To parse this JSON data, do
//
//     final createAdRequestModel = createAdRequestModelFromJson(jsonString);

import 'dart:convert';

CreateAdRequestModel createAdRequestModelFromJson(String str) => CreateAdRequestModel.fromJson(json.decode(str));

String createAdRequestModelToJson(CreateAdRequestModel data) => json.encode(data.toJson());

class CreateAdRequestModel {
  String? destinationUuid;
  String? vendorUuid;
  String? storeUuid;
  String? agencyUuid;
  String? clientMasterUuid;
  String? adsMediaType;
  int? contentLength;
  bool? isDefault;

  CreateAdRequestModel({
    this.destinationUuid,
    this.vendorUuid,
    this.storeUuid,
    this.agencyUuid,
    this.clientMasterUuid,
    this.adsMediaType,
    this.contentLength,
    this.isDefault,
  });

  factory CreateAdRequestModel.fromJson(Map<String, dynamic> json) => CreateAdRequestModel(
    destinationUuid: json["destinationUuid"],
    vendorUuid: json["vendorUuid"],
    storeUuid: json["storeUuid"],
    agencyUuid: json["agencyUuid"],
    clientMasterUuid: json["clientMasterUuid"],
    adsMediaType: json["adsMediaType"],
    contentLength: json["contentLength"],
    isDefault: json["isDefault"],
  );

  Map<String, dynamic> toJson() => {
    "destinationUuid": destinationUuid,
    "vendorUuid": vendorUuid,
    "storeUuid": storeUuid,
    "agencyUuid": agencyUuid,
    "clientMasterUuid": clientMasterUuid,
    "adsMediaType": adsMediaType,
    "contentLength": contentLength,
    "isDefault": isDefault,
  };
}