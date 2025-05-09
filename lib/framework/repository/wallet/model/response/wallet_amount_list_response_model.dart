// To parse this JSON data, do
//
//     final walletAmountListResponseModel = walletAmountListResponseModelFromJson(jsonString);

import 'dart:convert';

WalletAmountListResponseModel walletAmountListResponseModelFromJson(String str) => WalletAmountListResponseModel.fromJson(json.decode(str));

String walletAmountListResponseModelToJson(WalletAmountListResponseModel data) => json.encode(data.toJson());

class WalletAmountListResponseModel {
  int? pageNumber;
  List<WalletListData>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  WalletAmountListResponseModel({
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

  factory WalletAmountListResponseModel.fromJson(Map<String, dynamic> json) => WalletAmountListResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? [] : List<WalletListData>.from(json["data"]!.map((x) => WalletListData.fromJson(x))),
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

class WalletListData {
  String? uuid;
  int? amount;
  int? currentBalance;
  String? transactionType;
  int? transactionDateTime;
  String? status;

  WalletListData({
    this.uuid,
    this.amount,
    this.currentBalance,
    this.transactionType,
    this.transactionDateTime,
    this.status
  });

  factory WalletListData.fromJson(Map<String, dynamic> json) => WalletListData(
    uuid: json["uuid"],
    amount: json["amount"],
    currentBalance: json["currentBalance"],
    transactionType: json["transactionType"],
    transactionDateTime: json["transactionDateTime"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "amount": amount,
    "currentBalance": currentBalance,
    "transactionType": transactionType,
    "transactionDateTime": transactionDateTime,
    "status": status,
  };
}
