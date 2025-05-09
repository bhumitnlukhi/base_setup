// To parse this JSON data, do
//
//     final getAgencyDocumentResponseModel = getAgencyDocumentResponseModelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

GetAgencyDocumentResponseModel getAgencyDocumentResponseModelFromJson(String str) => GetAgencyDocumentResponseModel.fromJson(json.decode(str));

String getAgencyDocumentResponseModelToJson(GetAgencyDocumentResponseModel data) => json.encode(data.toJson());

class GetAgencyDocumentResponseModel {
  String? message;
  AgencyDocumentData? data;
  int? status;

  GetAgencyDocumentResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory GetAgencyDocumentResponseModel.fromJson(Map<String, dynamic> json) => GetAgencyDocumentResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : AgencyDocumentData.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
        "status": status,
      };
}

class AgencyDocumentData {
  List<AgencyDocument>? agencyDocuments;
  String? agencyUuid;

  AgencyDocumentData({
    this.agencyDocuments,
    this.agencyUuid,
  });

  factory AgencyDocumentData.fromJson(Map<String, dynamic> json) => AgencyDocumentData(
        agencyDocuments: json["agencyDocuments"] == null ? [] : List<AgencyDocument>.from(json["agencyDocuments"]!.map((x) => AgencyDocument.fromJson(x))),
        agencyUuid: json["agencyUuid"],
      );

  Map<String, dynamic> toJson() => {
        "agencyDocuments": agencyDocuments == null ? [] : List<dynamic>.from(agencyDocuments!.map((x) => x.toJson())),
        "agencyUuid": agencyUuid,
      };
}

class AgencyDocument {
  String? uuid;
  String? url;
  Uint8List? bytes;

  AgencyDocument({
    this.uuid,
    this.url,
    this.bytes,
  });

  factory AgencyDocument.fromJson(Map<String, dynamic> json) => AgencyDocument(
        uuid: json["uuid"],
        url: json["url"],
        bytes: json["bytes"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "url": url,
        "bytes": bytes,
      };
}
