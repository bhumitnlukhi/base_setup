// To parse this JSON data, do
//
//     final updateVendorRequestModel = updateVendorRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateVendorRequestModel updateVendorRequestModelFromJson(String str) => UpdateVendorRequestModel.fromJson(json.decode(str));

String updateVendorRequestModelToJson(UpdateVendorRequestModel data) => json.encode(data.toJson());

class UpdateVendorRequestModel {
  String? uuid;
  String? name;

  UpdateVendorRequestModel({
    this.uuid,
    this.name,
  });

  factory UpdateVendorRequestModel.fromJson(Map<String, dynamic> json) => UpdateVendorRequestModel(
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
  };
}
