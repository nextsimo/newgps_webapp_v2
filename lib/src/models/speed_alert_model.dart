// To parse this JSON data, do
//
//     final notificationSetting = notificationSettingFromJson(jsonString);

import 'dart:convert';

List<SpeedAlertModel> notificationSettingFromJson(String str) =>
    List<SpeedAlertModel>.from(
        json.decode(str).map((x) => SpeedAlertModel.fromJson(x)));

String notificationSettingToJson(List<SpeedAlertModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SpeedAlertModel {
  SpeedAlertModel({
    required this.id,
    required this.description,
    required this.isActive,
    required this.speedLimit,
    required this.accountId,
  });

  final int id;
  final String description;
  final bool isActive;
  final double speedLimit;
  final String accountId;

  factory SpeedAlertModel.fromJson(Map<String, dynamic> json) =>
      SpeedAlertModel(
        id: json["id"],
        description: json["description"],
        isActive: json["is_active"] == 1 ? true : false,
        speedLimit: json["speed_limit"].toDouble(),
        accountId: json["account_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "is_active": isActive,
        "speed_limit": speedLimit,
        "account_id": accountId,
      };
}
