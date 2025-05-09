// To parse this JSON data, do
//
//     final ticketReasonListRequestModel = ticketReasonListRequestModelFromJson(jsonString);

import 'dart:convert';

TicketReasonListRequestModel ticketReasonListRequestModelFromJson(String str) => TicketReasonListRequestModel.fromJson(json.decode(str));

String ticketReasonListRequestModelToJson(TicketReasonListRequestModel data) => json.encode(data.toJson());

class TicketReasonListRequestModel {
  bool? activeRecords;
  String? platformType;

  TicketReasonListRequestModel({
    this.activeRecords,
    this.platformType,
  });

  factory TicketReasonListRequestModel.fromJson(Map<String, dynamic> json) => TicketReasonListRequestModel(
    activeRecords: json["activeRecords"],
    platformType: json["platformType"],
  );

  Map<String, dynamic> toJson() => {
    "activeRecords": activeRecords,
    "platformType": platformType,
  };
}