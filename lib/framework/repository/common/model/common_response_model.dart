// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) =>
    CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) =>
    json.encode(data.toJson());

class CommonResponseModel {
  bool? success;
  int? status;
  String? message;
  dynamic data;

  CommonResponseModel({
    this.success,
    this.status,
    this.message,
    this.data,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) =>
      CommonResponseModel(
        success: json['success'],
        status: json['status'],
        message: json['message'],
        data: json['data'],
      );

  Map<String, dynamic> toJson() => {
        'success': success,
        'status': status,
        'message': message,
        'data': data,
      };
}
