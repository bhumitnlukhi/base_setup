// To parse this JSON data, do
//
//     final packageWalletHistoryResponseModel = packageWalletHistoryResponseModelFromJson(jsonString);

import 'dart:convert';

PackageWalletHistoryResponseModel packageWalletHistoryResponseModelFromJson(String str) => PackageWalletHistoryResponseModel.fromJson(json.decode(str));

String packageWalletHistoryResponseModelToJson(PackageWalletHistoryResponseModel data) => json.encode(data.toJson());

class PackageWalletHistoryResponseModel {
  int? pageNumber;
  Data? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  PackageWalletHistoryResponseModel({
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

  factory PackageWalletHistoryResponseModel.fromJson(Map<String, dynamic> json) => PackageWalletHistoryResponseModel(
    pageNumber: json["pageNumber"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
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
    "data": data?.toJson(),
    "hasNextPage": hasNextPage,
    "totalPages": totalPages,
    "hasPreviousPage": hasPreviousPage,
    "pageSize": pageSize,
    "message": message,
    "totalCount": totalCount,
    "status": status,
  };
}

class Data {
  int? currentBalance;
  List<PackageWalletTransactionResponseDto>? packageWalletTransactionResponseDtOs;

  Data({
    this.currentBalance,
    this.packageWalletTransactionResponseDtOs,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentBalance: json["currentBalance"],
    packageWalletTransactionResponseDtOs: json["packageWalletTransactionResponseDTOs"] == null ? [] : List<PackageWalletTransactionResponseDto>.from(json["packageWalletTransactionResponseDTOs"]!.map((x) => PackageWalletTransactionResponseDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "currentBalance": currentBalance,
    "packageWalletTransactionResponseDTOs": packageWalletTransactionResponseDtOs == null ? [] : List<dynamic>.from(packageWalletTransactionResponseDtOs!.map((x) => x.toJson())),
  };
}

class PackageWalletTransactionResponseDto {
  String? uuid;
  int? adsShowTime;
  int? transactionTime;
  int? amount;
  String? transactionType;
  String? destinationTimeZone;
  String? transactionMessage;
  String? currency;

  PackageWalletTransactionResponseDto({
    this.uuid,
    this.adsShowTime,
    this.transactionTime,
    this.amount,
    this.transactionType,
    this.destinationTimeZone,
    this.transactionMessage,
    this.currency,
  });

  factory PackageWalletTransactionResponseDto.fromJson(Map<String, dynamic> json) => PackageWalletTransactionResponseDto(
    uuid: json["uuid"],
    adsShowTime: json["adsShowTime"],
    transactionTime: json["transactionTime"],
    amount: json["amount"],
    transactionType: json["transactionType"],
    destinationTimeZone: json["destinationTimeZone"],
    transactionMessage: json["transactionMessage"],
    currency: json["currency"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "adsShowTime": adsShowTime,
    "transactionTime": transactionTime,
    "amount": amount,
    "transactionType": transactionType,
    "destinationTimeZone": destinationTimeZone,
    "transactionMessage": transactionMessage,
    "currency": currency,
  };
}
