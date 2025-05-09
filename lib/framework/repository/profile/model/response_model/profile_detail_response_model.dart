// To parse this JSON data, do
//
//     final profileDetailResponseModel = profileDetailResponseModelFromJson(jsonString);

import 'dart:convert';

ProfileDetailResponseModel profileDetailResponseModelFromJson(String str) => ProfileDetailResponseModel.fromJson(json.decode(str));

String profileDetailResponseModelToJson(ProfileDetailResponseModel data) => json.encode(data.toJson());

class ProfileDetailResponseModel {
  String? message;
  ProfileData? data;
  int? status;

  ProfileDetailResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory ProfileDetailResponseModel.fromJson(Map<String, dynamic> json) => ProfileDetailResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class ProfileData {
  dynamic scope;
  String? userUuid;
  int? userId;
  int? roleId;
  String? uuid;
  String? name;
  dynamic message;
  int? status;
  String? entityUuid;
  int? entityId;
  String? entityType;
  String? email;
  String? contactNumber;
  dynamic profileImage;
  dynamic roleUuid;
  String? roleName;
  String? countryUuid;
  bool? canChangePassword;
  bool? emailVerified;
  bool? contactVerified;
  dynamic robotUuid;
  dynamic accessToken;
  dynamic tokenType;
  int? expiresIn;

  ProfileData({
    this.scope,
    this.userUuid,
    this.userId,
    this.roleId,
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
    this.roleUuid,
    this.roleName,
    this.countryUuid,
    this.canChangePassword,
    this.emailVerified,
    this.contactVerified,
    this.robotUuid,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    scope: json["scope"],
    userUuid: json["userUuid"],
    userId: json["userId"],
    roleId: json["roleId"],
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
    roleUuid: json["roleUuid"],
    roleName: json["roleName"],
    countryUuid: json["countryUuid"],
    canChangePassword: json["canChangePassword"],
    emailVerified: json["emailVerified"],
    contactVerified: json["contactVerified"],
    robotUuid: json["robotUuid"],
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
  );

  Map<String, dynamic> toJson() => {
    "scope": scope,
    "userUuid": userUuid ?? '',
    "userId": userId ?? 0,
    "roleId": roleId ?? 0,
    "uuid": uuid ?? '',
    "name": name ?? '',
    "message": message ?? '',
    "status": status ?? 200,
    "entityUuid": entityUuid ?? '',
    "entityId": entityId ?? 0,
    "entityType": entityType ?? '',
    "email": email ?? '',
    "contactNumber": contactNumber ?? '',
    "profileImage": profileImage ?? '',
    "roleUuid": roleUuid ?? '',
    "roleName": roleName ?? '',
    "countryUuid": countryUuid ?? '',
    "canChangePassword": canChangePassword ?? false,
    "emailVerified": emailVerified ?? true,
    "contactVerified": contactVerified ?? true,
    "robotUuid": robotUuid ?? '',
    "access_token": accessToken ?? '',
    "token_type": tokenType ?? '',
    "expires_in": expiresIn ?? 0,
  };
}
