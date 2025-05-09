// To parse this JSON data, do
//
//     final adContentListRequestModel = adContentListRequestModelFromJson(jsonString);

import 'dart:convert';

AdContentListRequestModel adContentListRequestModelFromJson(String str) => AdContentListRequestModel.fromJson(json.decode(str));

String adContentListRequestModelToJson(AdContentListRequestModel data) => json.encode(data.toJson());

class AdContentListRequestModel {
  bool? activeRecords;
  String? adsUuid;
  String? status;

  AdContentListRequestModel({
    this.activeRecords,
    this.adsUuid,
    this.status,
  });

  factory AdContentListRequestModel.fromJson(Map<String, dynamic> json) => AdContentListRequestModel(
    activeRecords: json["activeRecords"],
    adsUuid: json["adsUuid"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "activeRecords": activeRecords,
    "adsUuid": adsUuid,
    "status": status,
  };
}
