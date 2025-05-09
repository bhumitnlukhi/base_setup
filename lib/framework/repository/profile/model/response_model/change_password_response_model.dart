// To parse this JSON data, do
//
//     final changePasswordResponseModel = changePasswordResponseModelFromJson(jsonString);

import 'dart:convert';

ChangePasswordResponseModel changePasswordResponseModelFromJson(String str) => ChangePasswordResponseModel.fromJson(json.decode(str));

String changePasswordResponseModelToJson(ChangePasswordResponseModel data) => json.encode(data.toJson());

class ChangePasswordResponseModel {
  String? message;
  ChangePasswordData? data;
  int? status;

  ChangePasswordResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) => ChangePasswordResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : ChangePasswordData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class ChangePasswordData {
  dynamic scope;
  int? userId;
  String? uuid;
  String? name;
  String? message;
  int? status;
  dynamic entityUuid;
  dynamic entityId;
  dynamic entityType;
  String? email;
  String? contactNumber;
  dynamic profileImage;
  int? roleId;
  String? roleName;
  bool? canChangePassword;
  bool? emailVerified;
  bool? contactVerified;
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  ChangePasswordData({
    this.scope,
    this.userId,
    this.uuid,
    this.name,
    this.message,
    this.status,
    this.entityUuid,
    this.entityId,
    this.entityType,
    this.email,
    this.contactNumber,
    this.profileImage,
    this.roleId,
    this.roleName,
    this.canChangePassword,
    this.emailVerified,
    this.contactVerified,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  factory ChangePasswordData.fromJson(Map<String, dynamic> json) => ChangePasswordData(
    scope: json["scope"],
    userId: json["userId"],
    uuid: json["uuid"],
    name: json["name"],
    message: json["message"],
    status: json["status"],
    entityUuid: json["entityUuid"],
    entityId: json["entityId"],
    entityType: json["entityType"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    profileImage: json["profileImage"],
    roleId: json["roleId"],
    roleName: json["roleName"],
    canChangePassword: json["canChangePassword"],
    emailVerified: json["emailVerified"],
    contactVerified: json["contactVerified"],
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
  );

  Map<String, dynamic> toJson() => {
    "scope": scope,
    "userId": userId,
    "uuid": uuid,
    "name": name,
    "message": message,
    "status": status,
    "entityUuid": entityUuid,
    "entityId": entityId,
    "entityType": entityType,
    "email": email,
    "contactNumber": contactNumber,
    "profileImage": profileImage,
    "roleId": roleId,
    "roleName": roleName,
    "canChangePassword": canChangePassword,
    "emailVerified": emailVerified,
    "contactVerified": contactVerified,
    "access_token": accessToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
  };
}
