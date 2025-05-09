// To parse this JSON data, do
//
//     final packageLimitResponseModel = packageLimitResponseModelFromJson(jsonString);

import 'dart:convert';

PackageLimitResponseModel packageLimitResponseModelFromJson(String str) => PackageLimitResponseModel.fromJson(json.decode(str));

String packageLimitResponseModelToJson(PackageLimitResponseModel data) => json.encode(data.toJson());

class PackageLimitResponseModel {
  String? message;
  Data? data;
  int? status;

  PackageLimitResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory PackageLimitResponseModel.fromJson(Map<String, dynamic> json) => PackageLimitResponseModel(
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
  int? dailyBudget;
  int? estimatedAdShowCount;

  Data({
    this.dailyBudget,
    this.estimatedAdShowCount,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    dailyBudget: json["dailyBudget"],
    estimatedAdShowCount: json["estimatedAdShowCount"],
  );

  Map<String, dynamic> toJson() => {
    "dailyBudget": dailyBudget,
    "estimatedAdShowCount": estimatedAdShowCount,
  };
}
