// To parse this JSON data, do
//
//     final itemCodeGeneration = itemCodeGenerationFromJson(jsonString);

import 'dart:convert';

ItemCodeGeneration itemCodeGenerationFromJson(String str) =>
    ItemCodeGeneration.fromJson(json.decode(str));

String itemCodeGenerationToJson(ItemCodeGeneration data) =>
    json.encode(data.toJson());

class ItemCodeGeneration {
  String itemGroup;
  String codeGenFormat;
  int startWith;
  int incrBy;
  String srNoSeparator;
  bool masterVariantInd;

  ItemCodeGeneration({
    required this.itemGroup,
    required this.codeGenFormat,
    required this.startWith,
    required this.incrBy,
    required this.srNoSeparator,
    required this.masterVariantInd,
  });

  factory ItemCodeGeneration.fromJson(Map<String, dynamic> json) =>
      ItemCodeGeneration(
        itemGroup: json["ItemGroup"],
        codeGenFormat: json["CodeGenFormat"],
        startWith: json["StartWith"],
        incrBy: json["IncrBy"],
        srNoSeparator: json["SrNoSeparator"],
        masterVariantInd: json["MasterVariantInd"],
      );

  Map<String, dynamic> toJson() => {
        "ItemGroup": itemGroup,
        "CodeGenFormat": codeGenFormat,
        "StartWith": startWith,
        "IncrBy": incrBy,
        "SrNoSeparator": srNoSeparator,
        "MasterVariantInd": masterVariantInd,
      };
}
