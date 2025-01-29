// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

Location locationFromJson(String str) => Location.fromJson(json.decode(str));

String locationToJson(Location data) => json.encode(data.toJson());

class Location {
  String locationCode;
  String locationName;
  String locationDiscription;

  Location({
    required this.locationCode,
    required this.locationName,
    required this.locationDiscription,
  });

  Location copyWith({
    String? locationCode,
    String? locationName,
    String? locationDiscription,
  }) =>
      Location(
        locationCode: locationCode ?? this.locationCode,
        locationName: locationName ?? this.locationName,
        locationDiscription: locationDiscription ?? this.locationDiscription,
      );

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationCode: json["Location Code"],
        locationName: json["Location Name"],
        locationDiscription: json["Location Discription"],
      );

  Map<String, dynamic> toJson() => {
        "Location Code": locationCode,
        "Location Name": locationName,
        "Location Discription": locationDiscription,
      };
}
