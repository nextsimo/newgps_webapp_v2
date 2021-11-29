// To parse this JSON data, do
//
//     final tripsRepportModel = tripsRepportModelFromJson(jsonString);

import 'dart:convert';

List<TripsRepportModel> tripsRepportModelFromJson(String str) =>
    List<TripsRepportModel>.from(
        json.decode(str).map((x) => TripsRepportModel.fromJson(x)));

String tripsRepportModelToJson(List<TripsRepportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TripsRepportModel {
  TripsRepportModel({
    required this.startDate,
    required this.endDate,
    required this.drivingTime,
    required this.distance,
    required this.odometer,
    required this.startAddress,
    required this.endAddress,
    required this.stopedTime,
    required this.drivingTimeBySeconds,
    required this.stopedTimeBySeconds,
  });

  DateTime startDate;
  DateTime endDate;
  String drivingTime;
  double distance;
  double odometer;
  String startAddress;
  String endAddress;
  String stopedTime;
  int stopedTimeBySeconds;
  int drivingTimeBySeconds;

  factory TripsRepportModel.fromJson(Map<String, dynamic> json) =>
      TripsRepportModel(
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        drivingTime: json["driving_time"],
        distance: json["distance"].toDouble(),
        odometer: json["odometer"].toDouble(),
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        stopedTime: json["stoped_time"],
        stopedTimeBySeconds: json["stoped_time_by_seconds"],
        drivingTimeBySeconds: json["driving_time_by_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "start_date": startDate.toIso8601String(),
        "end_date": endDate.toIso8601String(),
        "driving_time": drivingTime,
        "distance": distance,
        "odometer": odometer,
        "start_address": startAddress,
        "end_address": endAddress,
        "stoped_time": stopedTime,
      };
}
