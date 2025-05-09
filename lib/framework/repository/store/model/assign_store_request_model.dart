// To parse this JSON data, do
//
//     final assignStoreRequestModel = assignStoreRequestModelFromJson(jsonString);

import 'dart:convert';

AssignStoreRequestModel assignStoreRequestModelFromJson(String str) => AssignStoreRequestModel.fromJson(json.decode(str));

String assignStoreRequestModelToJson(AssignStoreRequestModel data) => json.encode(data.toJson());

class AssignStoreRequestModel {
  final String? vendorUuid;
  final List<DestinationOdigoStoreMappingDto>? destinationOdigoStoreMappingDtOs;

  AssignStoreRequestModel({
    this.vendorUuid,
    this.destinationOdigoStoreMappingDtOs,
  });

  factory AssignStoreRequestModel.fromJson(Map<String, dynamic> json) => AssignStoreRequestModel(
        vendorUuid: json["vendorUuid"],
        destinationOdigoStoreMappingDtOs:
            json["destinationOdigoStoreMappingDTOs"] == null ? [] : List<DestinationOdigoStoreMappingDto>.from(json["destinationOdigoStoreMappingDTOs"]!.map((x) => DestinationOdigoStoreMappingDto.fromJson(x))),
      );

  String toJson() => jsonEncode({
        "vendorUuid": vendorUuid,
        "destinationOdigoStoreMappingDTOs": destinationOdigoStoreMappingDtOs == null ? [] : List<dynamic>.from(destinationOdigoStoreMappingDtOs!.map((x) => x.toJson())),
      });
}

class DestinationOdigoStoreMappingDto {
  final String? destinationUuid;
  final String? odigoStoreUuid;

  DestinationOdigoStoreMappingDto({
    this.destinationUuid,
    this.odigoStoreUuid,
  });

  factory DestinationOdigoStoreMappingDto.fromJson(Map<String, dynamic> json) => DestinationOdigoStoreMappingDto(
        destinationUuid: json["destinationUuid"],
        odigoStoreUuid: json["odigoStoreUuid"],
      );

  Map<String, dynamic> toJson() => {
        "destinationUuid": destinationUuid,
        "odigoStoreUuid": odigoStoreUuid,
      };
}
