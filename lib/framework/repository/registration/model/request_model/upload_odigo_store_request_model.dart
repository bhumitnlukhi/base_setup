// To parse this JSON data, do
//
//     final uploadOdigoStoreRequestModel = uploadOdigoStoreRequestModelFromJson(jsonString);

import 'dart:convert';

UploadOdigoStoreRequestModel uploadOdigoStoreRequestModelFromJson(String str) => UploadOdigoStoreRequestModel.fromJson(json.decode(str));

String uploadOdigoStoreRequestModelToJson(UploadOdigoStoreRequestModel data) => json.encode(data.toJson());

class UploadOdigoStoreRequestModel {
  String? vendorUuid;
  List<DestinationOdigoStoreMappingDto>? destinationOdigoStoreMappingDtOs;

  UploadOdigoStoreRequestModel({
    this.vendorUuid,
    this.destinationOdigoStoreMappingDtOs,
  });

  factory UploadOdigoStoreRequestModel.fromJson(Map<String, dynamic> json) => UploadOdigoStoreRequestModel(
    vendorUuid: json["vendorUuid"],
    destinationOdigoStoreMappingDtOs: json["destinationOdigoStoreMappingDTOs"] == null ? [] : List<DestinationOdigoStoreMappingDto>.from(json["destinationOdigoStoreMappingDTOs"]!.map((x) => DestinationOdigoStoreMappingDto.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorUuid": vendorUuid,
    "destinationOdigoStoreMappingDTOs": destinationOdigoStoreMappingDtOs == null ? [] : List<dynamic>.from(destinationOdigoStoreMappingDtOs!.map((x) => x.toJson())),
  };
}

class DestinationOdigoStoreMappingDto {
  String? destinationUuid;
  String? odigoStoreUuid;

  DestinationOdigoStoreMappingDto({
    this.destinationUuid,
    this.odigoStoreUuid,
  });

  factory DestinationOdigoStoreMappingDto.fromJson(Map<String, dynamic> json) => DestinationOdigoStoreMappingDto(
    destinationUuid: json["destinationUuid"],
    odigoStoreUuid: json["odigoStoreUuid"],
  );

  Map<String, dynamic> toJson() => {
    "destinationUuid": destinationUuid ?? '',
    "odigoStoreUuid": odigoStoreUuid ?? '',
  };
}
