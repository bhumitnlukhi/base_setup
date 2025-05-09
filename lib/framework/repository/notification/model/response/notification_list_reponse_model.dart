// To parse this JSON data, do
//
//     final notificationListResponseModel = notificationListResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationListResponseModel notificationListResponseModelFromJson(String str) => NotificationListResponseModel.fromJson(json.decode(str));

String notificationListResponseModelToJson(NotificationListResponseModel data) => json.encode(data.toJson());

class NotificationListResponseModel {
  int? pageNumber;
  List<NotificationData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  NotificationListResponseModel({
    this.pageNumber,
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory NotificationListResponseModel.fromJson(Map<String, dynamic> json) => NotificationListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<NotificationData>.from(json["data"]!.map((x) => NotificationData.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class NotificationData {
  String? uuid;
  String? message;
  int? createdAt;
  String? module;
  int? moduleId;
  String? moduleUuid;
  String? pushNotificationReceiverUuid;
  bool? isRead;
  String? entityUuid;
  String? entityType;
  String? subEntityUuid;
  String? subEntityType;

  NotificationData({
    this.uuid,
    this.message,
    this.createdAt,
    this.module,
    this.moduleId,
    this.moduleUuid,
    this.pushNotificationReceiverUuid,
    this.isRead,
    this.entityUuid,
    this.entityType,
    this.subEntityUuid,
    this.subEntityType,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => NotificationData(
    uuid: json["uuid"],
    message: json["message"],
    createdAt: json["createdAt"],
    module: json["module"],
    moduleId: json["moduleId"],
    moduleUuid: json["moduleUuid"],
    pushNotificationReceiverUuid: json["pushNotificationReceiverUuid"],
    isRead: json["isRead"],
    entityUuid: json["entityUuid"],
    entityType: json["entityType"],
    subEntityUuid: json["subEntityUuid"],
    subEntityType: json["subEntityType"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "message": message,
    "createdAt": createdAt,
    "module": module,
    "moduleId": moduleId,
    "moduleUuid": moduleUuid,
    "pushNotificationReceiverUuid": pushNotificationReceiverUuid,
    "isRead": isRead,
    "entityUuid": entityUuid,
    "entityType": entityType,
    "subEntityUuid": subEntityUuid,
    "subEntityType": subEntityType,
  };
}
