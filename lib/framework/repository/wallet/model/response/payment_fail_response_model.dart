// To parse this JSON data, do
//
//     final failPaymentResponseModel = failPaymentResponseModelFromJson(jsonString);

import 'dart:convert';

FailPaymentResponseModel failPaymentResponseModelFromJson(String str) => FailPaymentResponseModel.fromJson(json.decode(str));

String failPaymentResponseModelToJson(FailPaymentResponseModel data) => json.encode(data.toJson());

class FailPaymentResponseModel {
  String? message;
  String? type;

  FailPaymentResponseModel({
    this.message,
    this.type,
  });

  factory FailPaymentResponseModel.fromJson(Map<String, dynamic> json) => FailPaymentResponseModel(
    message: json["message"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "type": type,
  };
}