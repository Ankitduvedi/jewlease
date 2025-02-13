import 'dart:convert';

import 'package:jewlease/data/model/departments_model.dart';

Employee employeeFromJson(String str) => Employee.fromJson(json.decode(str));

String employeeToJson(Employee data) => json.encode(data.toJson());

class Employee {
  final String employeeCode;
  final String employeeName;
  final String employeeType;
  final String defaultLocation;
  final String defaultDepartment;
  final List<Location> locations;
  final int canChangeGlobalSetting;
  final String loginName;
  final String pfAccountNo;
  final String esicNo;
  final String rowStatus;
  final String remark;
  final String grade;
  final String weighterName;
  final String password;
  final int passwordExpired;
  final int isLocked;
  final int noOfFailedAttempts;
  DateTime passwordExpiresOn;
  final int allowAccessFromMainURL;
  final String emergencyContactName;
  final String emergencyContact;
  final String salaryInstr;
  final String accountName;
  DateTime lastLoginDate;

  Employee({
    required this.employeeCode,
    required this.employeeName,
    required this.employeeType,
    required this.defaultLocation,
    required this.defaultDepartment,
    required this.locations,
    required this.canChangeGlobalSetting,
    required this.loginName,
    required this.pfAccountNo,
    required this.esicNo,
    required this.rowStatus,
    required this.remark,
    required this.grade,
    required this.weighterName,
    required this.password,
    required this.passwordExpired,
    required this.isLocked,
    required this.noOfFailedAttempts,
    required this.passwordExpiresOn,
    required this.allowAccessFromMainURL,
    required this.emergencyContactName,
    required this.emergencyContact,
    required this.salaryInstr,
    required this.accountName,
    required this.lastLoginDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        employeeCode: json["employeeCode"],
        employeeName: json["employeeName"],
        employeeType: json["employeeType"],
        defaultLocation: json["defaultLocation"],
        defaultDepartment: json["defaultDepartment"],
        locations: (json["location"] is String && json["location"] == "{}")
            ? []
            : List<Location>.from((jsonDecode(json["location"]) as List)
                .map((x) => Location.fromJson(x))),
        canChangeGlobalSetting: json["canChangeGlobalSetting"],
        loginName: json["loginName"],
        pfAccountNo: json["pfAccountNo"],
        esicNo: json["esicNo"],
        rowStatus: json["rowStatus"],
        remark: json["remark"],
        grade: json["grade"],
        weighterName: json["weighterName"],
        password: json["password"],
        passwordExpired: json["passwordExpired"],
        isLocked: json["isLocked"],
        noOfFailedAttempts: json["noOfFailedAttempts"],
        passwordExpiresOn: DateTime.parse(json["passwordExpiresOn"]),
        allowAccessFromMainURL: json["allowAccessFromMainURL"],
        emergencyContactName: json["emergencyContactName"],
        emergencyContact: json["emergencyContact"],
        salaryInstr: json["salaryInstr"],
        accountName: json["accountName"],
        lastLoginDate: DateTime.parse(json["lastLoginDate"]),
      );

  Map<String, dynamic> toJson() => {
        "employeeCode": employeeCode,
        "employeeName": employeeName,
        "employeeType": employeeType,
        "defaultLocation": defaultLocation,
        "defaultDepartment": defaultDepartment,
        "location": jsonEncode(locations.map((x) => x.toJson()).toList()),
        "canChangeGlobalSetting": canChangeGlobalSetting,
        "loginName": loginName,
        "pfAccountNo": pfAccountNo,
        "esicNo": esicNo,
        "rowStatus": rowStatus,
        "remark": remark,
        "grade": grade,
        "weighterName": weighterName,
        "password": password,
        "passwordExpired": passwordExpired,
        "isLocked": isLocked,
        "noOfFailedAttempts": noOfFailedAttempts,
        "passwordExpiresOn":
            "${passwordExpiresOn.year.toString().padLeft(4, '0')}-${passwordExpiresOn.month.toString().padLeft(2, '0')}-${passwordExpiresOn.day.toString().padLeft(2, '0')}",
        "allowAccessFromMainURL": allowAccessFromMainURL,
        "emergencyContactName": emergencyContactName,
        "emergencyContact": emergencyContact,
        "salaryInstr": salaryInstr,
        "accountName": accountName,
        "lastLoginDate": lastLoginDate.toIso8601String(),
      };
}

class Location {
  final String locationCode;

  final List<Departments> departments;

  Location({
    required this.locationCode,
    required this.departments,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationCode: json["locationCode"],
        departments: List<Departments>.from(
            json["departments"].map((x) => Departments.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "locationCode": locationCode,
        "departments": departments.map((x) => x.toJson()).toList(),
      };
}
