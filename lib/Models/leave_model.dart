// To parse this JSON data, do
//
//     final leaveModel = leaveModelFromJson(jsonString);

import 'dart:convert';

List<LeaveModel> leaveModelFromJson(String str) => List<LeaveModel>.from(json.decode(str).map((x) => LeaveModel.fromJson(x)));

String leaveModelToJson(List<LeaveModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveModel {
    LeaveModel({
        this.id,
        this.startDateTime,
        this.endDateTime,
        this.reason,
    });

    String? id;
    DateTime? startDateTime;
    DateTime? endDateTime;
    String? reason;

    factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        id: json["id"] as String? ?? "",
        startDateTime: DateTime.parse(json["startDateTime"] as String? ?? ""),
        endDateTime: DateTime.parse(json["endDateTime"] as String? ?? ""),
        reason: json["reason"] as String? ?? "",
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "startDateTime": startDateTime!.toIso8601String(),
        "endDateTime": endDateTime!.toIso8601String(),
        "reason": reason,
    };
}