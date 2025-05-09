// To parse this JSON data, do
//
//     final vendorDashboardResponseModel = vendorDashboardResponseModelFromJson(jsonString);

import 'dart:convert';

VendorDashboardResponseModel vendorDashboardResponseModelFromJson(String str) => VendorDashboardResponseModel.fromJson(json.decode(str));

String vendorDashboardResponseModelToJson(VendorDashboardResponseModel data) => json.encode(data.toJson());

class VendorDashboardResponseModel {
  String? message;
  VendorDashboardData? data;
  int? status;

  VendorDashboardResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory VendorDashboardResponseModel.fromJson(Map<String, dynamic> json) => VendorDashboardResponseModel(
        message: json["message"],
        data: json["data"] == null ? null : VendorDashboardData.fromJson(json["data"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data?.toJson(),
        "status": status,
      };
}

class VendorDashboardData {
  int? totalShownAdsTillDate;
  int? totalShownAdsToday;
  int? alreadySpentBudgetForOngoingAds;
  int? remainingBudgetForOngoingAds;
  int? totalOngoingAdsBdget;
  int? totalStore;
  int? activeStore;
  int? deActiveStore;
  int? rejectedStore;
  int? pendingStore;
  dynamic totalClientMaster;
  dynamic activeClientMaster;
  dynamic deActiveClientMaster;

  VendorDashboardData({
    this.totalShownAdsTillDate,
    this.totalShownAdsToday,
    this.alreadySpentBudgetForOngoingAds,
    this.remainingBudgetForOngoingAds,
    this.totalOngoingAdsBdget,
    this.totalStore,
    this.activeStore,
    this.deActiveStore,
    this.rejectedStore,
    this.pendingStore,
    this.totalClientMaster,
    this.activeClientMaster,
    this.deActiveClientMaster,
  });

  factory VendorDashboardData.fromJson(Map<String, dynamic> json) => VendorDashboardData(
        totalShownAdsTillDate: json["totalShownAdsTillDate"],
        totalShownAdsToday: json["totalShownAdsToday"],
        alreadySpentBudgetForOngoingAds: json["alreadySpentBudgetForOngoingAds"],
        remainingBudgetForOngoingAds: json["remainingBudgetForOngoingAds"],
        totalOngoingAdsBdget: json["totalOngoingAdsBdget"],
        totalStore: json["totalStore"],
        activeStore: json["activeStore"],
        deActiveStore: json["deActiveStore"],
        rejectedStore: json["rejectedStore"],
        pendingStore: json["pendingStore"],
        totalClientMaster: json["totalClientMaster"],
        activeClientMaster: json["activeClientMaster"],
        deActiveClientMaster: json["deActiveClientMaster"],
      );

  Map<String, dynamic> toJson() => {
        "totalShownAdsTillDate": totalShownAdsTillDate ?? 0,
        "totalShownAdsToday": totalShownAdsToday ?? 0,
        "alreadySpentBudgetForOngoingAds": alreadySpentBudgetForOngoingAds ?? 0,
        "remainingBudgetForOngoingAds": remainingBudgetForOngoingAds ?? 0,
        "totalOngoingAdsBdget": totalOngoingAdsBdget ?? 0,
        "totalStore": totalStore ?? 0,
        "activeStore": activeStore ?? 0,
        "deActiveStore": deActiveStore ?? 0,
        "rejectedStore": rejectedStore ?? 0,
        "pendingStore": pendingStore ?? 0,
        "totalClientMaster": totalClientMaster ?? 0,
        "activeClientMaster": activeClientMaster ?? 0,
        "deActiveClientMaster": deActiveClientMaster ?? 0,
      };
}
