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
  String locationCode;

  Departments({
    required this.departmentCode,
    required this.departmentName,
    required this.departmentDescription,
    required this.locationCode,
  });

  Departments copyWith({
    String? departmentCode,
    String? departmentName,
    String? departmentDescription,
    String? locationCode,
  }) =>
      Departments(
        departmentCode: departmentCode ?? this.departmentCode,
        departmentName: departmentName ?? this.departmentName,
        departmentDescription:
            departmentDescription ?? this.departmentDescription,
        locationCode: locationCode ?? this.locationCode,
      );

  factory Departments.fromJson(Map<String, dynamic> json) => Departments(
        departmentCode: json["departmentCode"],
        departmentName: json["departmentName"],
        departmentDescription: json["departmentDescription"],
        locationCode: json["locationCode"],
      );

  Map<String, dynamic> toJson() => {
        "departmentCode": departmentCode,
        "departmentName": departmentName,
        "departmentDescription": departmentDescription,
        "locationCode": locationCode,
      };
}
