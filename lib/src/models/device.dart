// To parse this JSON data, do
//
//     final device = deviceFromMap(jsonString);

import 'dart:convert';

List<Device> deviceFromMap(String str) =>
    List<Device>.from(json.decode(str).map((x) => Device.fromMap(x)));

String deviceToMap(List<Device> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Device {
  Device({
    required this.markerText,
    required this.description,
    required this.deviceId,
    required this.dateTime,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.distanceKm,
    required this.odometerKm,
    required this.city,
    required this.heading,
    required this.speedKph,
    required this.index,
    required this.colorR,
    required this.colorG,
    required this.colorB,
    required this.statut,
    required this.markerPng,
    required this.phone1,
    required this.phone2,
    required this.markerTextPng,
    required this.deviceIcon,
  });

  final String description;
  final String deviceId;
  final DateTime dateTime;
  final double latitude;
  final double longitude;
   String address;
  final double distanceKm;
  final double odometerKm;
  final String city;
  final int heading;
  final int speedKph;
  final int index;
  final int colorR;
  final int colorG;
  final int colorB;
  final String statut;
  final String markerPng;
  final String markerText;
  final String phone1;
  final String phone2;
  final String markerTextPng;
  final String deviceIcon;

  factory Device.fromMap(Map<String, dynamic> json) {
    return Device(
      description: json["description"],
      deviceId: json["DeviceID"],
      dateTime: DateTime.fromMillisecondsSinceEpoch(json["timestamp"] * 1000),
      latitude: json["latitude"].toDouble(),
      longitude: json["longitude"].toDouble(),
      address: json["address"],
      distanceKm: json["distanceKM"],
      odometerKm: json["odometerKM"],
      city: json["city"],
      heading: json["heading"],
      speedKph: json["speedKPH"],
      index: json["index"],
      colorR: json["colorR"],
      colorG: json["colorG"],
      colorB: json["colorB"],
      statut: json["statut"],
      markerPng: json["marker_png"],
      markerText: json["marker_text"] ?? '',
      phone1: json["phone1"] ?? '',
      phone2: json["phone2"] ?? '',
      markerTextPng: json["marker_text_png"],
      deviceIcon: json["deviceIcon"] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        "description": description,
        "DeviceID": deviceId,
        "timestamp": dateTime,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "distanceKM": distanceKm,
        "odometerKM": odometerKm,
        "city": city,
        "heading": heading,
        "speedKPH": speedKph,
        "index": index,
        "colorR": colorR,
        "colorG": colorG,
        "colorB": colorB,
        "statut": statut,
        "marker_png": markerPng,
      };

      // copy with
  Device copyWith({ 
    String? description,
    String? deviceId,
    DateTime? dateTime,
    double? latitude,
    double? longitude,
    String? address,
    double? distanceKm,
    double? odometerKm,
    String? city,
    int? heading,
    int? speedKph,
    int? index,
    int? colorR,
    int? colorG,
    int? colorB,
    String? statut,
    String? markerPng,
    String? markerText,
    String? phone1,
    String? phone2,
    String? markerTextPng,
    String? deviceIcon,
  }) {
    return Device(
      description: description ?? this.description,
      deviceId: deviceId ?? this.deviceId,
      dateTime: dateTime ?? this.dateTime,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      distanceKm: distanceKm ?? this.distanceKm,
      odometerKm: odometerKm ?? this.odometerKm,
      city: city ?? this.city,
      heading: heading ?? this.heading,
      speedKph: speedKph ?? this.speedKph,
      index: index ?? this.index,
      colorR: colorR ?? this.colorR,
      colorG: colorG ?? this.colorG,
      colorB: colorB ?? this.colorB,
      statut: statut ?? this.statut,
      markerPng: markerPng ?? this.markerPng,
      markerText: markerText ?? this.markerText,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      markerTextPng: markerTextPng ?? this.markerTextPng,
      deviceIcon: deviceIcon ?? this.deviceIcon,
    );
  }

/*   static String _getPhoneNumber(String data, [int index = 0]) {
    try {
      return data.split(',')[index];
    } catch (e) {
      return '';
    }
  } */
}
