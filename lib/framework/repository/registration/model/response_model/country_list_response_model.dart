// To parse this JSON data, do
//
//     final countryListResponseModel = countryListResponseModelFromJson(jsonString);

import 'dart:convert';

CountryListResponseModel countryListResponseModelFromJson(String str) => CountryListResponseModel.fromJson(json.decode(str));

String countryListResponseModelToJson(CountryListResponseModel data) => json.encode(data.toJson());

class CountryListResponseModel {
  List<CountryDto>? data;
  bool? hasNextPage;
  int? totalPages;
  bool? hasPreviousPage;
  int? pageSize;
  String? message;
  int? totalCount;
  int? status;

  CountryListResponseModel({
    this.data,
    this.hasNextPage,
    this.totalPages,
    this.hasPreviousPage,
    this.pageSize,
    this.message,
    this.totalCount,
    this.status,
  });

  factory CountryListResponseModel.fromJson(Map<String, dynamic> json) => CountryListResponseModel(
    data: json["data"] == null ? [] : List<CountryDto>.from(json["data"]!.map((x) => CountryDto.fromJson(x))),
    hasNextPage: json["hasNextPage"],
    totalPages: json["totalPages"],
    hasPreviousPage: json["hasPreviousPage"],
    pageSize: json["pageSize"],
    message: json["message"],
    totalCount: json["totalCount"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
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

class CountryDto {
  String? uuid;
  String? name;
  bool? active;

  CountryDto({
    this.uuid,
    this.name,
    this.active,
  });

  factory CountryDto.fromJson(Map<String, dynamic> json) => CountryDto(
    uuid: json["uuid"],
    name: json["name"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "active": active,
  };
}
