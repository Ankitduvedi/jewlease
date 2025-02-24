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
        employeeCode: json["Employee Code"],
        employeeName: json["Employee Name"],
        employeeType: json["Employee Type"],
        defaultLocation: json["Default Location"],
        defaultDepartment: json["Default Department"],
        locations: (json["Location"] is String && json["Location"] == "{}")
            ? []
            : List<Location>.from((jsonDecode(json["Location"]) as List)
                .map((x) => Location.fromJson(x))),
        canChangeGlobalSetting: json["Can Change Global Setting"],
        loginName: json["Login Name"],
        pfAccountNo: json["PF Account No"],
        esicNo: json["ESIC No"],
        rowStatus: json["Row Status"],
        remark: json["Remark"],
        grade: json["Grade"],
        weighterName: json["Weighter Name"],
        password: json["Password"],
        passwordExpired: json["Password Expired"],
        isLocked: json["Is Locked"],
        noOfFailedAttempts: json["No of Failed Attempts"],
        passwordExpiresOn: DateTime.parse(json["Password Expires on"]),
        allowAccessFromMainURL: json["Allow Access From Main URL"],
        emergencyContactName: json["Emergency Contact Name"],
        emergencyContact: json["Emergency Contact"],
        salaryInstr: json["Salary Instr"],
        accountName: json["Account Name"],
        lastLoginDate: DateTime.parse(json["Last Login Date"]),
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
        "lastLoginDate":
            "${lastLoginDate.year.toString().padLeft(4, '0')}-${lastLoginDate.month.toString().padLeft(2, '0')}-${lastLoginDate.day.toString().padLeft(2, '0')}",
      };

  // Factory method for creating a default Employee instance
  factory Employee.defaultEmployee() {
    return Employee(
      employeeCode: '',
      employeeName: '',
      employeeType: '',
      defaultLocation: '',
      defaultDepartment: '',
      locations: [],
      canChangeGlobalSetting: 0,
      loginName: '',
      pfAccountNo: '',
      esicNo: '',
      rowStatus: '',
      remark: '',
      grade: '',
      weighterName: '',
      password: '',
      passwordExpired: 0,
      isLocked: 0,
      noOfFailedAttempts: 0,
      passwordExpiresOn: DateTime(2000, 1, 1),
      allowAccessFromMainURL: 0,
      emergencyContactName: '',
      emergencyContact: '',
      salaryInstr: '',
      accountName: '',
      lastLoginDate: DateTime(2000, 1, 1),
    );
  }
}

class Location {
  final String locationName;

  final List<Departments> departments;

  Location({
    required this.locationName,
    required this.departments,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationName: json["locationName"],
        departments: List<Departments>.from(
            json["departments"].map((x) => Departments.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "locationName": locationName,
        "departments": departments.map((x) => x.toJson()).toList(),
      };
}
