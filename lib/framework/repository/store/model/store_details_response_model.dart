// To parse this JSON data, do
//
//     final storeDetailsResponseModel = storeDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:odigo_vendor/framework/repository/store/model/store_list_response_model.dart';

StoreDetailsResponseModel storeDetailsResponseModelFromJson(String str) => StoreDetailsResponseModel.fromJson(json.decode(str));

String storeDetailsResponseModelToJson(StoreDetailsResponseModel data) => json.encode(data.toJson());

class StoreDetailsResponseModel {
  final String? message;
  final OdigoStoreData? data;
  final int? status;

  StoreDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory StoreDetailsResponseModel.fromJson(Map<String, dynamic> json) => StoreDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : OdigoStoreData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class OdigoStoreData {
  final String? uuid;
  final String? odigoStoreUuid;
  final String? odigoStoreName;
  // final String? businessCategoryUuid;
  // final String? businessCategoryName;
  List<BusinessCategoryLanguageResponseDto>? businessCategoryLanguageResponseDtOs;

  final Destination? destination;
  final VerificationResultResponseDto? verificationResultResponseDto;
  final bool? active;

  OdigoStoreData({
    this.uuid,
    this.odigoStoreUuid,
    this.odigoStoreName,
    // this.businessCategoryUuid,
    // this.businessCategoryName,
    this.businessCategoryLanguageResponseDtOs,
    this.destination,
    this.verificationResultResponseDto,
    this.active,
  });

  factory OdigoStoreData.fromJson(Map<String, dynamic> json) => OdigoStoreData(
    uuid: json["uuid"],
    odigoStoreUuid: json["odigoStoreUuid"],
    odigoStoreName: json["odigoStoreName"],
    // businessCategoryUuid: json["businessCategoryUuid"],
    // businessCategoryName: json["businessCategoryName"],
    businessCategoryLanguageResponseDtOs: json["businessCategoryLanguageResponseDTOs"] == null ? [] : List<BusinessCategoryLanguageResponseDto>.from(json["businessCategoryLanguageResponseDTOs"]!.map((x) => BusinessCategoryLanguageResponseDto.fromJson(x))),
    destination: json["destination"] == null ? null : Destination.fromJson(json["destination"]),
    verificationResultResponseDto: json["verificationResultResponseDTO"] == null ? null : VerificationResultResponseDto.fromJson(json["verificationResultResponseDTO"]),
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "odigoStoreUuid": odigoStoreUuid,
    "odigoStoreName": odigoStoreName,
    // "businessCategoryUuid": businessCategoryUuid,
    // "businessCategoryName": businessCategoryName,
    "businessCategoryLanguageResponseDTOs": businessCategoryLanguageResponseDtOs == null ? [] : List<dynamic>.from(businessCategoryLanguageResponseDtOs!.map((x) => x.toJson())),
    "destination": destination?.toJson(),
    "verificationResultResponseDTO": verificationResultResponseDto?.toJson(),
    "active": active,
  };
}

class Destination {
  final String? uuid;
  final String? name;
  final String? destinationTypeUuid;
  final String? destinationTypeName;
  final int? startHour;
  final int? endHour;
  final int? totalFloor;
  final String? houseNumber;
  final String? streetName;
  final String? addressLine1;
  final String? addressLine2;
  final String? landmark;
  final String? cityUuid;
  final String? stateUuid;
  final String? countryUuid;
  final String? countryName;
  final String? stateName;
  final String? cityName;
  final String? postalCode;
  final String? imageUrl;
  final String? email;
  final String? contactNumber;
  final bool? active;
  final String? ownerName;

  Destination({
    this.uuid,
    this.name,
    this.destinationTypeUuid,
    this.destinationTypeName,
    this.startHour,
    this.endHour,
    this.totalFloor,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.countryName,
    this.stateName,
    this.cityName,
    this.postalCode,
    this.imageUrl,
    this.email,
    this.contactNumber,
    this.active,
    this.ownerName,
  });

  factory Destination.fromJson(Map<String, dynamic> json) => Destination(
    uuid: json["uuid"],
    name: json["name"],
    destinationTypeUuid: json["destinationTypeUuid"],
    destinationTypeName: json["destinationTypeName"],
    startHour: json["startHour"],
    endHour: json["endHour"],
    totalFloor: json["totalFloor"],
    houseNumber: json["houseNumber"],
    streetName: json["streetName"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    landmark: json["landmark"],
    cityUuid: json["cityUuid"],
    stateUuid: json["stateUuid"],
    countryUuid: json["countryUuid"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    cityName: json["cityName"],
    postalCode: json["postalCode"],
    imageUrl: json["imageUrl"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    active: json["active"],
    ownerName: json["ownerName"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "name": name,
    "destinationTypeUuid": destinationTypeUuid,
    "destinationTypeName": destinationTypeName,
    "startHour": startHour,
    "endHour": endHour,
    "totalFloor": totalFloor,
    "houseNumber": houseNumber,
    "streetName": streetName,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "landmark": landmark,
    "cityUuid": cityUuid,
    "stateUuid": stateUuid,
    "countryUuid": countryUuid,
    "countryName": countryName,
    "stateName": stateName,
    "cityName": cityName,
    "postalCode": postalCode,
    "imageUrl": imageUrl,
    "email": email,
    "contactNumber": contactNumber,
    "active": active,
    "ownerName": ownerName,
  };
}

class VerificationResultResponseDto {
  final String? status;
  final dynamic rejectReason;

  VerificationResultResponseDto({
    this.status,
    this.rejectReason,
  });

  factory VerificationResultResponseDto.fromJson(Map<String, dynamic> json) => VerificationResultResponseDto(
    status: json["status"],
    rejectReason: json["rejectReason"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "rejectReason": rejectReason,
  };
}
