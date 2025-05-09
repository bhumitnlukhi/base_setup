// To parse this JSON data, do
//
//     final faqListResponseModel = faqListResponseModelFromJson(jsonString);

import 'dart:convert';

FaqListResponseModel faqListResponseModelFromJson(String str) => FaqListResponseModel.fromJson(json.decode(str));

String faqListResponseModelToJson(FaqListResponseModel data) => json.encode(data.toJson());

class FaqListResponseModel {
  int? pageNumber;
  List<FaqModel>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  FaqListResponseModel({
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

  factory FaqListResponseModel.fromJson(Map<String, dynamic> json) => FaqListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<FaqModel>.from(json["data"]!.map((x) => FaqModel.fromJson(x))),
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

class FaqModel {
  String? uuid;
  String? platformType;
  String? question;
  String? answer;
  bool? active;

  FaqModel({
    this.uuid,
    this.platformType,
    this.question,
    this.answer,
    this.active,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
    uuid: json["uuid"],
    platformType: json["platformType"],
    question: json["question"],
    answer: json["answer"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "platformType": platformType,
    "question": question,
    "answer": answer,
    "active": active,
  };
}
