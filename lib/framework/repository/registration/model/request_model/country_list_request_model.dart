// To parse this JSON data, do
//
//     final countryListRequestModel = countryListRequestModelFromJson(jsonString);

import 'dart:convert';

CountryListRequestModel countryListRequestModelFromJson(String str) => CountryListRequestModel.fromJson(json.decode(str));

String countryListRequestModelToJson(CountryListRequestModel data) => json.encode(data.toJson());

class CountryListRequestModel {
  String? searchKeyword;
  String? activeRecords;

  CountryListRequestModel({
    this.searchKeyword,
    this.activeRecords,
  });

  factory CountryListRequestModel.fromJson(Map<String, dynamic> json) => CountryListRequestModel(
    searchKeyword: json["searchKeyword"],
    activeRecords: json["activeRecords"],
  );

  Map<String, dynamic> toJson() => {
    "searchKeyword": searchKeyword ?? '',
    "activeRecords": activeRecords ?? true,
  };
}
