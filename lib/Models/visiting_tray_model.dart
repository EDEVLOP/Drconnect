// To parse this JSON data, do
//
//     final visitingTrayModel = visitingTrayModelFromJson(jsonString);
import 'dart:convert';

VisitingTrayModel visitingTrayModelFromJson(String str) =>
    VisitingTrayModel.fromJson(json.decode(str));

String visitingTrayModelToJson(VisitingTrayModel data) =>
    json.encode(data.toJson());

class VisitingTrayModel {
  VisitingTrayModel({
    this.startTime = "Start time",
    this.endTime = "End time",
    this.provideRadio = 1,
    this.textFieldTitle,
    this.textFieldValue = 0,
    this.bottomDisplayText = 0,
  });

  String? startTime;
  String? endTime;
  int? provideRadio;
  String? textFieldTitle;
  int? textFieldValue;
  int? bottomDisplayText;

  factory VisitingTrayModel.fromJson(Map<String, dynamic> json) =>
      VisitingTrayModel(
        startTime: json["startTime"] as String? ?? "",
        endTime: json["endTime"] as String? ?? "",
        provideRadio: json["provideRadio"] as int? ?? 1,
        textFieldTitle: json["textFieldTitle"] as String? ?? '',
        textFieldValue: json["textFieldValue"] as int? ?? 0,
        bottomDisplayText: json["bottomDisplayText"] as int? ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
        "provideRadio": provideRadio,
        "textFieldTitle": textFieldTitle,
        "textFieldValue": textFieldValue,
        "bottomDisplayText": bottomDisplayText,
      };
}
