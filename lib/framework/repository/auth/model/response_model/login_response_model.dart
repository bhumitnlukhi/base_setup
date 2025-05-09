// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) => LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) => json.encode(data.toJson());

class LoginResponseModel {
  String? message;
  LoginResponseData? data;
  int? status;

  LoginResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : LoginResponseData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class LoginResponseData {
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
  String? countryUuid;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  String? currencyName;

  LoginResponseData({
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
    this.countryUuid,
    this.accessToken,
    this.tokenType,
    this.expiresIn,
    this.currencyName,

  });

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => LoginResponseData(
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
    countryUuid: json["countryUuid"],
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    currencyName: json["currencyName"],
  );

  Map<String, dynamic> toJson() => {
    "scope": scope ?? '',
    "userUuid": userUuid ?? '',
    "userId": userId ?? 0,
    "roleId": roleId ?? '',
    "uuid": uuid ?? '',
    "name": name ?? '',
    "message": message ?? '',
    "status": status ?? 0,
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
    "countryUuid": countryUuid ?? '',
    "access_token": accessToken ?? '',
    "token_type": tokenType ?? '',
    "expires_in": expiresIn ?? 0,
    "currencyName": currencyName ?? 0,
  };
}
