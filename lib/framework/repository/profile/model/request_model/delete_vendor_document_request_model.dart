// To parse this JSON data, do
//
//     final deleteVendorDocumentRequestModel = deleteVendorDocumentRequestModelFromJson(jsonString);

import 'dart:convert';

DeleteVendorDocumentRequestModel deleteVendorDocumentRequestModelFromJson(String str) => DeleteVendorDocumentRequestModel.fromJson(json.decode(str));

String deleteVendorDocumentRequestModelToJson(DeleteVendorDocumentRequestModel data) => json.encode(data.toJson());

class DeleteVendorDocumentRequestModel {
  List<String>? uuidList;

  DeleteVendorDocumentRequestModel({
    this.uuidList,
  });

  factory DeleteVendorDocumentRequestModel.fromJson(Map<String, dynamic> json) => DeleteVendorDocumentRequestModel(
    uuidList: json["uuidList"] == null ? [] : List<String>.from(json["uuidList"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "uuidList": uuidList == null ? [] : List<dynamic>.from(uuidList!.map((x) => x)),
  };
}
