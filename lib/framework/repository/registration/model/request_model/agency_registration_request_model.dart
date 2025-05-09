// To parse this JSON data, do
//
//     final agencyRegistrationRequestModel = agencyRegistrationRequestModelFromJson(jsonString);

import 'dart:convert';

AgencyRegistrationRequestModel agencyRegistrationRequestModelFromJson(String str) => AgencyRegistrationRequestModel.fromJson(json.decode(str));

String agencyRegistrationRequestModelToJson(AgencyRegistrationRequestModel data) => json.encode(data.toJson());

class AgencyRegistrationRequestModel {
  String? uuid;
  String? ownerName;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? countryUuid;
  String? stateUuid;
  String? cityUuid;
  String? postalCode;
  String? name;

  AgencyRegistrationRequestModel({
    this.uuid,
    this.ownerName,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.countryUuid,
    this.stateUuid,
    this.cityUuid,
    this.postalCode,
    this.name,
  });

  factory AgencyRegistrationRequestModel.fromJson(Map<String, dynamic> json) => AgencyRegistrationRequestModel(uuid: json["uuid"], ownerName: json["ownerName"], houseNumber: json["houseNumber"], streetName: json["streetName"], addressLine1: json["addressLine1"], addressLine2: json["addressLine2"], countryUuid: json["countryUuid"], stateUuid: json["stateUuid"], cityUuid: json["cityUuid"], postalCode: json["postalCode"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "uuid": uuid ?? '',
        "ownerName": ownerName ?? '',
        "houseNumber": houseNumber ?? '',
        "streetName": streetName ?? '',
        "addressLine1": addressLine1 ?? '',
        "addressLine2": addressLine2 ?? '',
        "countryUuid": countryUuid ?? '',
        "stateUuid": stateUuid ?? '',
        "cityUuid": cityUuid ?? '',
        "postalCode": postalCode ?? '',
        "name": name ?? '',
      };
}
