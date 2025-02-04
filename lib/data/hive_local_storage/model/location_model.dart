import 'package:hive/hive.dart';

part 'location_model.g.dart'; // This file will be auto-generated

@HiveType(typeId: 0) // Unique ID for this model
class Location extends HiveObject {
  @HiveField(0)
  String locationCode;

  @HiveField(1)
  String locationName;

  @HiveField(2)
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

  // JSON Serialization
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
