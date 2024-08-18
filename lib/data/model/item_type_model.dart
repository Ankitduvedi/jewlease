// // To parse this JSON data, do
// //
// //     final itemType = itemTypeFromJson(jsonString);

// import 'dart:convert';

// ItemType itemTypeFromJson(String str) => ItemType.fromJson(json.decode(str));

// String itemTypeToJson(ItemType data) => json.encode(data.toJson());

// class ItemType {
//   String configId;
//   String configType;
//   String configCode;
//   String configValue;
//   String configRemark1;
//   String configRemark2;
//   String depdConfigCode;
//   String depdConfigId;
//   String depdConfigValue;
//   String keywords;
//   String rowStatus;

//   ItemType({
//     required this.configId,
//     required this.configType,
//     required this.configCode,
//     required this.configValue,
//     required this.configRemark1,
//     required this.configRemark2,
//     required this.depdConfigCode,
//     required this.depdConfigId,
//     required this.depdConfigValue,
//     required this.keywords,
//     required this.rowStatus,
//   });

//   factory ItemType.fromJson(Map<String, dynamic> json) => ItemType(
//         configId: json["ConfigID"],
//         configType: json["ConfigType"],
//         configCode: json["ConfigCode"],
//         configValue: json["ConfigValue"],
//         configRemark1: json["ConfigRemark1"],
//         configRemark2: json["ConfigRemark2"],
//         depdConfigCode: json["DepdConfigCode"],
//         depdConfigId: json["DepdConfigID"],
//         depdConfigValue: json["DepdConfigValue"],
//         keywords: json["Keywords"],
//         rowStatus: json["RowStatus"],
//       );

//   Map<String, dynamic> toJson() => {
//         "ConfigID": configId,
//         "ConfigType": configType,
//         "ConfigCode": configCode,
//         "ConfigValue": configValue,
//         "ConfigRemark1": configRemark1,
//         "ConfigRemark2": configRemark2,
//         "DepdConfigCode": depdConfigCode,
//         "DepdConfigID": depdConfigId,
//         "DepdConfigValue": depdConfigValue,
//         "Keywords": keywords,
//         "RowStatus": rowStatus,
//       };
// }
