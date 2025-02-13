// To parse this JSON data, do
//
//     final departments = departmentsFromJson(jsonString);

import 'dart:convert';

Departments departmentsFromJson(String str) =>
    Departments.fromJson(json.decode(str));

String departmentsToJson(Departments data) => json.encode(data.toJson());

class Departments {
  String departmentCode;
  String departmentName;
  String departmentDescription;
  String locationName;

  Departments({
    required this.departmentCode,
    required this.departmentName,
    required this.departmentDescription,
    required this.locationName,
  });

  Departments copyWith({
    String? departmentCode,
    String? departmentName,
    String? departmentDescription,
    String? locationName,
  }) =>
      Departments(
        departmentCode: departmentCode ?? this.departmentCode,
        departmentName: departmentName ?? this.departmentName,
        departmentDescription:
            departmentDescription ?? this.departmentDescription,
        locationName: locationName ?? this.locationName,
      );

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
        departmentCode: json["departmentCode"],
        departmentName: json["departmentName"],
        departmentDescription: json["departmentDescription"],
        locationName: json["locationName"],
      );

  Map<String, dynamic> toJson() => {
        "departmentCode": departmentCode,
        "departmentName": departmentName,
        "departmentDescription": departmentDescription,
        "locationName": locationName,
      };
  factory Departments.froomJson(Map<String, dynamic> json) => Departments(
        departmentCode: json["Department Code"],
        departmentName: json["Department Name"],
        departmentDescription: json["Department Discription"],
        locationName: json["Location Name"],
      );
}
