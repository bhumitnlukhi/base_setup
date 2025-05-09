// To parse this JSON data, do
//
//     final contactUsRequestModel = contactUsRequestModelFromJson(jsonString);

import 'dart:convert';

ContactUsRequestModel contactUsRequestModelFromJson(String str) => ContactUsRequestModel.fromJson(json.decode(str));

String contactUsRequestModelToJson(ContactUsRequestModel data) => json.encode(data.toJson());

class ContactUsRequestModel {
  String? name;
  String? email;
  String? contactNumber;
  String? description;

  ContactUsRequestModel({
    this.name,
    this.email,
    this.contactNumber,
    this.description,
  });

  factory ContactUsRequestModel.fromJson(Map<String, dynamic> json) => ContactUsRequestModel(
    name: json["name"],
    email: json["email"],
    contactNumber: json["contactNumber"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "contactNumber": contactNumber,
    "description": description,
  };
}
