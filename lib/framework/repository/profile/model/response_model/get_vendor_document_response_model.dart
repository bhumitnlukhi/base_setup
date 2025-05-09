// To parse this JSON data, do
//
//     final getVendorDocumentResponseModel = getVendorDocumentResponseModelFromJson(jsonString);

import 'dart:convert';
import 'dart:typed_data';

GetVendorDocumentResponseModel getVendorDocumentResponseModelFromJson(String str) => GetVendorDocumentResponseModel.fromJson(json.decode(str));

String getVendorDocumentResponseModelToJson(GetVendorDocumentResponseModel data) => json.encode(data.toJson());

class GetVendorDocumentResponseModel {
  String? message;
  Data? data;
  int? status;

  GetVendorDocumentResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory GetVendorDocumentResponseModel.fromJson(Map<String, dynamic> json) => GetVendorDocumentResponseModel(
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
  List<VendorDocument>? vendorDocuments;
  String? vendorUuid;

  Data({
    this.vendorDocuments,
    this.vendorUuid,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        vendorDocuments: json["vendorDocuments"] == null ? [] : List<VendorDocument>.from(json["vendorDocuments"]!.map((x) => VendorDocument.fromJson(x))),
        vendorUuid: json["vendorUuid"],
      );

  Map<String, dynamic> toJson() => {
        "vendorDocuments": vendorDocuments == null ? [] : List<dynamic>.from(vendorDocuments!.map((x) => x.toJson())),
        "vendorUuid": vendorUuid,
      };
}

class VendorDocument {
  String? uuid;
  String? url;
  Uint8List? bytes;

  VendorDocument({
    this.uuid,
    this.url,
    this.bytes,
  });

  factory VendorDocument.fromJson(Map<String, dynamic> json) => VendorDocument(
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
