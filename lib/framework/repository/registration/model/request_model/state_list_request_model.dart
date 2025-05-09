// To parse this JSON data, do
//
//     final stateListRequestModel = stateListRequestModelFromJson(jsonString);

import 'dart:convert';

StateListRequestModel stateListRequestModelFromJson(String str) => StateListRequestModel.fromJson(json.decode(str));

String stateListRequestModelToJson(StateListRequestModel data) => json.encode(data.toJson());

class StateListRequestModel {
  String? searchKeyword;
  String? countryUuid;
  String? activeRecords;

  StateListRequestModel({
    this.searchKeyword,
    this.countryUuid,
    this.activeRecords,
  });

  factory StateListRequestModel.fromJson(Map<String, dynamic> json) => StateListRequestModel(
    searchKeyword: json["searchKeyword"],
    countryUuid: json["countryUuid"],
    activeRecords: json["activeRecords"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword ?? '',
    "countryUuid": countryUuid ?? '',
    "activeRecords": activeRecords ?? true,
  };
}
