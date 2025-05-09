// To parse this JSON data, do
//
//     final addWalletAmountRequestModel = addWalletAmountRequestModelFromJson(jsonString);

import 'dart:convert';

AddWalletAmountRequestModel addWalletAmountRequestModelFromJson(String str) => AddWalletAmountRequestModel.fromJson(json.decode(str));

String addWalletAmountRequestModelToJson(AddWalletAmountRequestModel data) => json.encode(data.toJson());

class AddWalletAmountRequestModel {
  String? vendorUuid;
  String? agencyUuid;
  String? clientMasterUuid;
  int? amount;

  AddWalletAmountRequestModel({
    this.vendorUuid,
    this.agencyUuid,
    this.clientMasterUuid,
    this.amount,
  });

  factory AddWalletAmountRequestModel.fromJson(Map<String, dynamic> json) => AddWalletAmountRequestModel(
    vendorUuid: json["vendorUuid"],
    agencyUuid: json["agencyUuid"],
    clientMasterUuid: json["clientMasterUuid"],
    amount: json["amount"],
  );

  Map<String, dynamic> toJson() => {
    "vendorUuid": vendorUuid,
    "agencyUuid": agencyUuid,
    "clientMasterUuid": clientMasterUuid,
    "amount": amount,
  };
}