// To parse this JSON data, do
//
//     final clinicModel = clinicModelFromJson(jsonString);

import 'dart:convert';

List<ClinicModel> clinicModelFromJson(String str) => List<ClinicModel>.from(json.decode(str).map((x) => ClinicModel.fromJson(x)));

String clinicModelToJson(List<ClinicModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClinicModel {
    ClinicModel({
        this.id,
        this.name,
        this.fees,
        this.address,
    });

    String? id;
    String? name;
    int? fees;
    Address? address;

    factory ClinicModel.fromJson(Map<String, dynamic> json) => ClinicModel(
        id: json["id"] as String? ?? '',
        name: json["name"] as String? ?? '',
        fees: json["fees"] as int? ?? 0,
        address: Address.fromJson(json["address"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fees": fees,
        "address": address!.toJson(),
    };
}

class Address {
    Address({
        this.line1,
        this.city,
        this.state,
        this.country,
        this.phoneNumber,
        this.postalCode,
    });

    String? line1;
    String? city;
    String? state;
    String? country;
    String? phoneNumber;
    String? postalCode;

    factory Address.fromJson(Map<String, dynamic> json) => Address(
        line1: json["line1"] as String? ?? '',
        city: json["city"] as String? ?? '',
        state: json["state"] as String? ?? '',
        country: json["country"] as String? ?? '',
        phoneNumber: json["phoneNumber"] as String? ?? '',
        postalCode: json["postalCode"] as String? ?? '',
    );

    Map<String, dynamic> toJson() => {
        "line1": line1,
        "city": city,
        "state": state,
        "country": country,
        "phoneNumber": phoneNumber,
        "postalCode": postalCode,
    };
}
