// To parse this JSON data, do
//
//     final adContentResponseModel = adContentResponseModelFromJson(jsonString);

import 'dart:convert';

AdContentResponseModel adContentResponseModelFromJson(String str) => AdContentResponseModel.fromJson(json.decode(str));

String adContentResponseModelToJson(AdContentResponseModel data) => json.encode(data.toJson());

class AdContentResponseModel {
  int? pageNumber;
  List<AdsContentData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  AdContentResponseModel({
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

  factory AdContentResponseModel.fromJson(Map<String, dynamic> json) => AdContentResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<AdsContentData>.from(json["data"]!.map((x) => AdsContentData.fromJson(x))),
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

class AdsContentData {
  String? uuid;
  String? adsUuid;
  String? adsFileUrl;
  String? originalAdsFile;
  int? createdAt;
  String? adsContentStatus;
  bool? active;
  String? thumbnailFile;
  VerificationDetails? verificationDetails;

  AdsContentData({
    this.uuid,
    this.adsUuid,
    this.adsFileUrl,
    this.originalAdsFile,
    this.createdAt,
    this.adsContentStatus,
    this.active,
    this.thumbnailFile,
    this.verificationDetails,
  });

  factory AdsContentData.fromJson(Map<String, dynamic> json) => AdsContentData(
    uuid: json["uuid"],
    adsUuid: json["adsUuid"],
    adsFileUrl: json["adsFileUrl"],
    originalAdsFile: json["originalAdsFile"],
    createdAt: json["createdAt"],
    adsContentStatus: json["adsContentStatus"],
    active: json["active"],
    thumbnailFile: json["thumbnailFile"],
    verificationDetails: json["verificationDetails"] == null ? null : VerificationDetails.fromJson(json["verificationDetails"]),
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "adsUuid": adsUuid,
    "adsFileUrl": adsFileUrl,
    "originalAdsFile": originalAdsFile,
    "createdAt": createdAt,
    "adsContentStatus": adsContentStatus,
    "active": active,
    "thumbnailFile":thumbnailFile,
    "verificationDetails": verificationDetails?.toJson(),
  };
}

class VerificationDetails {
  String? status;
  String? rejectReason;

  VerificationDetails({
    this.status,
    this.rejectReason,
  });

  factory VerificationDetails.fromJson(Map<String, dynamic> json) => VerificationDetails(
    status: json["status"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "rejectReason": rejectReason,
  };
}