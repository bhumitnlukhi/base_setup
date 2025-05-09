// To parse this JSON data, do
//
//     final destinationListRequestModel = destinationListRequestModelFromJson(jsonString);

import 'dart:convert';

DestinationListRequestModel destinationListRequestModelFromJson(String str) => DestinationListRequestModel.fromJson(json.decode(str));

String destinationListRequestModelToJson(DestinationListRequestModel data) => json.encode(data.toJson());

class DestinationListRequestModel {
  String? searchKeyword;
  String? destinationTypeUuid;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  bool? activeRecords;
  String? odigoStoreUuid;
  bool? hasPurchased;
  bool? hasAds;
  bool? hasAdsForClient;
  bool? hasPurchasedForClient;
  String? vendorUuid;
  bool? isStoreAvailable;
  bool? firstOfflineSync;

  DestinationListRequestModel({
    this.searchKeyword,
    this.destinationTypeUuid,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.activeRecords,
    this.odigoStoreUuid,
    this.hasPurchased,
    this.hasAds,
    this.hasAdsForClient,
    this.hasPurchasedForClient,
    this.vendorUuid,
    this.isStoreAvailable,
    this.firstOfflineSync,
  });

  factory DestinationListRequestModel.fromJson(Map<String, dynamic> json) => DestinationListRequestModel(
        searchKeyword: json["searchKeyword"],
        destinationTypeUuid: json["destinationTypeUuid"],
        cityUuid: json["cityUuid"],
        stateUuid: json["stateUuid"],
        countryUuid: json["countryUuid"],
        activeRecords: json["activeRecords"],
        odigoStoreUuid: json["odigoStoreUuid"],
        hasPurchased: json["hasPurchased"],
        hasAds: json["hasAds"],
        hasAdsForClient: json["hasAdsForClient"],
        hasPurchasedForClient: json["hasPurchasedForClient"],
        vendorUuid: json["vendorUuid"],
        isStoreAvailable: json["isStoreAvailable"],
        firstOfflineSync: json["firstOfflineSync"],
      );

  Map<String, dynamic> toJson() => {
        "searchKeyword": searchKeyword,
        "destinationTypeUuid": destinationTypeUuid,
        "cityUuid": cityUuid,
        "stateUuid": stateUuid,
        "countryUuid": countryUuid,
        "activeRecords": activeRecords,
        "odigoStoreUuid": odigoStoreUuid,
        "hasPurchased": hasPurchased,
        "hasAds": hasAds,
        "hasAdsForClient": hasAdsForClient,
        "hasPurchasedForClient": hasPurchasedForClient,
        "vendorUuid": vendorUuid,
        "isStoreAvailable": isStoreAvailable,
        "firstOfflineSync": firstOfflineSync,
      };
}
