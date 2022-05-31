// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
    LocationModel({
        this.page,
        this.pageSize,
        this.totalPages,
        this.data,
    });

    int? page;
    int? pageSize;
    int? totalPages;
    List<Datum>? data;

    factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        page: json["page"],
        pageSize: json["pageSize"],
        totalPages: json["totalPages"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "totalPages": totalPages,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
        this.id,
        this.area,
        this.district,
        this.state,
        this.pincode,
        this.latitude,
        this.longitude,
    });

    String? id;
    String? area;
    String? district;
    String? state;
    String? pincode;
    String? latitude;
    String? longitude;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        area: json["area"],
        district: json["district"],
        state: json["state"],
        pincode: json["pincode"],
        latitude: json["latitude"],
        longitude: json["longitude"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "area": area,
        "district": district,
        "state": state,
        "pincode": pincode,
        "latitude": latitude,
        "longitude": longitude,
    };
}

// enum District { KHORDHA, PURI }

// final districtValues = EnumValues({
//     "KHORDHA": District.KHORDHA,
//     "PURI": District.PURI
// });

// enum State { ODISHA }

// final stateValues = EnumValues({
//     "ODISHA": State.ODISHA
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String>? reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap ??= map.map((k, v) => new MapEntry(v, k));
//         return reverseMap!;
//     }
// }
