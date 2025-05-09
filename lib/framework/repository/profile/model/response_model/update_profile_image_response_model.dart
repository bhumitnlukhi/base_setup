// To parse this JSON data, do
//
//     final updateProfileImageResponseModel = updateProfileImageResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateProfileImageResponseModel updateProfileImageResponseModelFromJson(String str) => UpdateProfileImageResponseModel.fromJson(json.decode(str));

String updateProfileImageResponseModelToJson(UpdateProfileImageResponseModel data) => json.encode(data.toJson());

class UpdateProfileImageResponseModel {
  String? message;
  int? status;

  UpdateProfileImageResponseModel({
    this.message,
    this.status,
  });

  factory UpdateProfileImageResponseModel.fromJson(Map<String, dynamic> json) => UpdateProfileImageResponseModel(
    message: json['message'],
    status: json['status'],
  );

  Map<String, dynamic> toJson() => {
    'message': message,
    'status': status,
  };
}
