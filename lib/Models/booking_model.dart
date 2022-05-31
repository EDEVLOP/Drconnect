// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

List<BookingModel> bookingModelFromJson(String str) => List<BookingModel>.from(json.decode(str).map((x) => BookingModel.fromJson(x)));

String bookingModelToJson(List<BookingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookingModel {
    BookingModel({
        this.clinicId,
        this.clinicName,
        this.slots,
    });

    String? clinicId;
    String? clinicName;
    List<Slot>? slots;

    factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        clinicId: json["clinicId"],
        clinicName: json["clinicName"],
        slots: List<Slot>.from(json["slots"].map((x) => Slot.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "clinicId": clinicId,
        "clinicName": clinicName,
        "slots": List<dynamic>.from(slots!.map((x) => x.toJson())),
    };
}

class Slot {
    Slot({
        this.id,
        this.startDate,
        this.startTime,
        this.endDate,
        this.endTime,
        this.slot,
        this.slotSelector,
        this.intervalSelector,
        this.byDays,
        this.numberOfPatients,
    });

    String? id;
    String? startDate;
    String? startTime;
    String? endDate;
    String? endTime;
    int? slot;
    String? slotSelector;
    String? intervalSelector;
    List<String>? byDays;
    int? numberOfPatients;

    factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        startDate: json["startDate"],
        startTime: json["startTime"],
        endDate: json["endDate"],
        endTime: json["endTime"],
        slot: json["slot"],
        slotSelector: json["slotSelector"],
        intervalSelector: json["intervalSelector"],
        byDays: List<String>.from(json["byDays"].map((x) => x)),
        numberOfPatients: json["numberOfPatients"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "startDate": startDate,
        "startTime": startTime,
        "endDate": endDate,
        "endTime": endTime,
        "slot": slot,
        "slotSelector": slotSelector,
        "intervalSelector": intervalSelector,
        "byDays": List<dynamic>.from(byDays!.map((x) => x)),
        "numberOfPatients": numberOfPatients,
    };
}
