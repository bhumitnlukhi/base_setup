// To parse this JSON data, do
//
//     final destinationDetailsResponseModel = destinationDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

DestinationDetailsResponseModel destinationDetailsResponseModelFromJson(String str) => DestinationDetailsResponseModel.fromJson(json.decode(str));

String destinationDetailsResponseModelToJson(DestinationDetailsResponseModel data) => json.encode(data.toJson());

class DestinationDetailsResponseModel {
  String? message;
  Data? data;
  int? status;

  DestinationDetailsResponseModel({
    this.message,
    this.data,
    this.status,
  });

  factory DestinationDetailsResponseModel.fromJson(Map<String, dynamic> json) => DestinationDetailsResponseModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "data": data?.toJson(),
    "status": status,
  };
}

class Data {
  String? uuid;
  List<DestinationValue>? destinationValues;
  String? destinationTypeUuid;
  int? totalFloor;
  String? houseNumber;
  String? streetName;
  String? addressLine1;
  String? addressLine2;
  String? landmark;
  String? cityUuid;
  String? stateUuid;
  String? countryUuid;
  String? postalCode;
  dynamic imageUrl;
  String? email;
  String? contactNumber;
  String? password;
  bool? active;
  String? ownerName;
  String? destinationTypeName;
  String? countryName;
  String? stateName;
  String? cityName;

  Data({
    this.uuid,
    this.destinationValues,
    this.destinationTypeUuid,
    this.totalFloor,
    this.houseNumber,
    this.streetName,
    this.addressLine1,
    this.addressLine2,
    this.landmark,
    this.cityUuid,
    this.stateUuid,
    this.countryUuid,
    this.postalCode,
    this.imageUrl,
    this.email,
    this.contactNumber,
    this.password,
    this.active,
    this.ownerName,
    this.destinationTypeName,
    this.countryName,
    this.stateName,
    this.cityName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uuid: json["uuid"],
    destinationValues: json["destinationValues"] == null ? [] : List<DestinationValue>.from(json["destinationValues"]!.map((x) => DestinationValue.fromJson(x))),
    destinationTypeUuid: json["destinationTypeUuid"],
    totalFloor: json["totalFloor"],
    houseNumber: json["houseNumber"],
    streetName: json["streetName"],
    addressLine1: json["addressLine1"],
    addressLine2: json["addressLine2"],
    landmark: json["landmark"],
    cityUuid: json["cityUuid"],
    stateUuid: json["stateUuid"],
    countryUuid: json["countryUuid"],
    postalCode: json["postalCode"],
    imageUrl: json["imageUrl"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    password: json["password"],
    active: json["active"],
    ownerName: json["ownerName"],
    destinationTypeName: json["destinationTypeName"],
    countryName: json["countryName"],
    stateName: json["stateName"],
    cityName: json["cityName"],
  );

  Map<String, dynamic> toJson() => {
    "uuid": uuid,
    "destinationValues": destinationValues == null ? [] : List<dynamic>.from(destinationValues!.map((x) => x.toJson())),
    "destinationTypeUuid": destinationTypeUuid,
    "totalFloor": totalFloor,
    "houseNumber": houseNumber,
    "streetName": streetName,
    "addressLine1": addressLine1,
    "addressLine2": addressLine2,
    "landmark": landmark,
    "cityUuid": cityUuid,
    "stateUuid": stateUuid,
    "countryUuid": countryUuid,
    "postalCode": postalCode,
    "imageUrl": imageUrl,
    "email": email,
    "contactNumber": contactNumber,
    "password": password,
    "active": active,
    "ownerName": ownerName,
    "destinationTypeName": destinationTypeName,
    "countryName": countryName,
    "stateName": stateName,
    "cityName": cityName,
  };
}

class DestinationValue {
  String? languageUuid;
  String? languageName;
  String? uuid;
  String? name;

  DestinationValue({
    this.languageUuid,
    this.languageName,
    this.uuid,
    this.name,
  });

  factory DestinationValue.fromJson(Map<String, dynamic> json) => DestinationValue(
    languageUuid: json["languageUuid"],
    languageName: json["languageName"],
    uuid: json["uuid"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "languageUuid": languageUuid,
    "languageName": languageName,
    "uuid": uuid,
    "name": name,
  };
}
