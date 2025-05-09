// To parse this JSON data, do
//
//     final ticketListResponseModel = ticketListResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_detail_response_model.dart';

TicketListResponseModel ticketListResponseModelFromJson(String str) => TicketListResponseModel.fromJson(json.decode(str));

String ticketListResponseModelToJson(TicketListResponseModel data) => json.encode(data.toJson());

class TicketListResponseModel {
  int? pageNumber;
  List<TicketData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  TicketListResponseModel({
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

  factory TicketListResponseModel.fromJson(Map<String, dynamic> json) => TicketListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<TicketData>.from(json["data"]!.map((x) => TicketData.fromJson(x))),
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
