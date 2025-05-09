// To parse this JSON data, do
//
//     final cityListRequestModel = cityListRequestModelFromJson(jsonString);

import 'dart:convert';

CityListRequestModel cityListRequestModelFromJson(String str) => CityListRequestModel.fromJson(json.decode(str));

String cityListRequestModelToJson(CityListRequestModel data) => json.encode(data.toJson());

class CityListRequestModel {
  String? searchKeyword;
  String? stateUuid;
  String? countryUuid;
  bool? activeRecords;

  CityListRequestModel({
    this.searchKeyword,
    this.stateUuid,
    this.countryUuid,
    this.activeRecords,
  });

  factory CityListRequestModel.fromJson(Map<String, dynamic> json) => CityListRequestModel(
    searchKeyword: json["searchKeyword"],
    stateUuid: json["stateUuid"],
    countryUuid: json["countryUuid"],
    activeRecords: json["activeRecords"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword ?? '',
    "stateUuid": stateUuid ?? '',
    "countryUuid": countryUuid ?? '',
    "activeRecords": activeRecords ?? true,
  };
}
