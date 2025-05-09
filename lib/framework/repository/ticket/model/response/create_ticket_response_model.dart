// To parse this JSON data, do
//
//     final createTicketResponseModel = createTicketResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigo_vendor/framework/repository/ticket/model/response/ticket_detail_response_model.dart';

CreateTicketResponseModel createTicketResponseModelFromJson(String str) => CreateTicketResponseModel.fromJson(json.decode(str));

String createTicketResponseModelToJson(CreateTicketResponseModel data) => json.encode(data.toJson());

class CreateTicketResponseModel {
  String? message;
  TicketData? data;
  int? status;

  CreateTicketResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory CreateTicketResponseModel.fromJson(Map<String, dynamic> json) => CreateTicketResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : TicketData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}
