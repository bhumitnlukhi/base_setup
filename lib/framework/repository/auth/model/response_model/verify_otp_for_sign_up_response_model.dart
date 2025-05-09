// To parse this JSON data, do
//
//     final verifyOtpResponseModel = verifyOtpResponseModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponseModel verifyOtpResponseModelFromJson(String str) => VerifyOtpResponseModel.fromJson(json.decode(str));

String verifyOtpResponseModelToJson(VerifyOtpResponseModel data) => json.encode(data.toJson());

class VerifyOtpResponseModel {
  String? message;
  VerifyOtpData? data;
  int? status;

  VerifyOtpResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) => VerifyOtpResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : VerifyOtpData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class VerifyOtpData {
  dynamic scope;
  String? userUuid;
  int? userId;
  dynamic roleId;
  String? uuid;
  String? name;
  String? message;
  int? status;
  String? entityUuid;
  int? entityId;
  String? entityType;
  String? email;
  String? contactNumber;
  dynamic profileImage;
  String? roleUuid;
  String? roleName;
  bool? canChangePassword;
  bool? emailVerified;
  bool? contactVerified;
  dynamic robotUuid;
  String? destinationUuid;
  bool? isRegistrationCompleted;
  String? entityStatus;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? countryUuid;

  VerifyOtpData({
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
    this.canChangePassword,
    this.emailVerified,
    this.contactVerified,
    this.robotUuid,
    this.destinationUuid,
    this.isRegistrationCompleted,
    this.entityStatus,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.countryUuid
  });

  factory VerifyOtpData.fromJson(Map<String, dynamic> json) => VerifyOtpData(
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
    canChangePassword: json["canChangePassword"],
    emailVerified: json["emailVerified"],
    contactVerified: json["contactVerified"],
    robotUuid: json["robotUuid"],
    destinationUuid: json["destinationUuid"],
    isRegistrationCompleted: json["isRegistrationCompleted"],
    entityStatus: json["entityStatus"],
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    countryUuid: json["countryUuid"],
  );

  Map<String, dynamic> toJson() => {
    "scope": scope ?? '',
    "userUuid": userUuid ?? '',
    "userId": userId ?? 0,
    "roleId": roleId ?? '',
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
    "canChangePassword": canChangePassword ?? true,
    "emailVerified": emailVerified ?? true,
    "contactVerified": contactVerified ?? true,
    "robotUuid": robotUuid ?? '',
    "destinationUuid": destinationUuid ?? '',
    "isRegistrationCompleted": isRegistrationCompleted ?? false,
    "entityStatus": entityStatus ?? '',
    "access_token": accessToken ?? '',
    "token_type": tokenType ?? '',
    "expires_in": expiresIn ?? 0,
    "countryUuid": countryUuid ?? '',
  };
}
