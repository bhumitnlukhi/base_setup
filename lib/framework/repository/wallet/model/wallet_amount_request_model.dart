// To parse this JSON data, do
//
//     final walletAmountListRequestModel = walletAmountListRequestModelFromJson(jsonString);

import 'dart:convert';

WalletAmountListRequestModel walletAmountListRequestModelFromJson(String str) => WalletAmountListRequestModel.fromJson(json.decode(str));

String walletAmountListRequestModelToJson(WalletAmountListRequestModel data) => json.encode(data.toJson());

class WalletAmountListRequestModel {
  String? vendorUuid;
  String? agencyUuid;
  String? clientMasterUuid;
  String? transactionType;
  String? fromDate;
  String? toDate;

  WalletAmountListRequestModel({
    this.vendorUuid,
    this.agencyUuid,
    this.clientMasterUuid,
    this.transactionType,
    this.fromDate,
    this.toDate,
  });

  factory WalletAmountListRequestModel.fromJson(Map<String, dynamic> json) => WalletAmountListRequestModel(
    vendorUuid: json["vendorUuid"],
    agencyUuid: json["agencyUuid"],
    clientMasterUuid: json["clientMasterUuid"],
    transactionType: json["transactionType"],
    fromDate: json["fromDate"],
    toDate: json["toDate"],
  );

  Map<String, dynamic> toJson() => {
    "vendorUuid": vendorUuid,
    "agencyUuid": agencyUuid,
    "clientMasterUuid": clientMasterUuid,
    "transactionType": transactionType,
    "fromDate": fromDate,
    "toDate": toDate
  };
}
