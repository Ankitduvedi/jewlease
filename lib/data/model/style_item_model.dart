// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ItemMasterStyle itemMasterStyleFromJson(String str) => ItemMasterStyle.fromJson(json.decode(str));

String itemMasterStyleToJson(ItemMasterStyle data) => json.encode(data.toJson());

class ItemMasterStyle {
    String styleName;
    bool exclusiveIndicator;
    bool holdIndicator;
    bool reworkIndicator;
    bool rejectIndicator;
    bool protoRequiredIndicator;
    bool autoVarientCodeGenIndicator;
    String remark;
    String rowStatus;
    List<ImageDetail> imageDetails;

    ItemMasterStyle({
        required this.styleName,
        required this.exclusiveIndicator,
        required this.holdIndicator,
        required this.reworkIndicator,
        required this.rejectIndicator,
        required this.protoRequiredIndicator,
        required this.autoVarientCodeGenIndicator,
        required this.remark,
        required this.rowStatus,
        required this.imageDetails,
    });

    ItemMasterStyle copyWith({
        String? styleName,
        bool? exclusiveIndicator,
        bool? holdIndicator,
        bool? reworkIndicator,
        bool? rejectIndicator,
        bool? protoRequiredIndicator,
        bool? autoVarientCodeGenIndicator,
        String? remark,
        String? rowStatus,
        List<ImageDetail>? imageDetails,
    }) => 
        ItemMasterStyle(
            styleName: styleName ?? this.styleName,
            exclusiveIndicator: exclusiveIndicator ?? this.exclusiveIndicator,
            holdIndicator: holdIndicator ?? this.holdIndicator,
            reworkIndicator: reworkIndicator ?? this.reworkIndicator,
            rejectIndicator: rejectIndicator ?? this.rejectIndicator,
            protoRequiredIndicator: protoRequiredIndicator ?? this.protoRequiredIndicator,
            autoVarientCodeGenIndicator: autoVarientCodeGenIndicator ?? this.autoVarientCodeGenIndicator,
            remark: remark ?? this.remark,
            rowStatus: rowStatus ?? this.rowStatus,
            imageDetails: imageDetails ?? this.imageDetails,
        );

    factory ItemMasterStyle.fromJson(Map<String, dynamic> json) => ItemMasterStyle(
        styleName: json["styleName"],
        exclusiveIndicator: json["exclusiveIndicator"],
        holdIndicator: json["holdIndicator"],
        reworkIndicator: json["reworkIndicator"],
        rejectIndicator: json["rejectIndicator"],
        protoRequiredIndicator: json["protoRequiredIndicator"],
        autoVarientCodeGenIndicator: json["autoVarientCodeGenIndicator"],
        remark: json["remark"],
        rowStatus: json["rowStatus"],
        imageDetails: List<ImageDetail>.from(json["imageDetails"].map((x) => ImageDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "styleName": styleName,
        "exclusiveIndicator": exclusiveIndicator,
        "holdIndicator": holdIndicator,
        "reworkIndicator": reworkIndicator,
        "rejectIndicator": rejectIndicator,
        "protoRequiredIndicator": protoRequiredIndicator,
        "autoVarientCodeGenIndicator": autoVarientCodeGenIndicator,
        "remark": remark,
        "rowStatus": rowStatus,
        "imageDetails": List<dynamic>.from(imageDetails.map((x) => x.toJson())),
    };
}



class ImageDetail {
  String url;
  String type;
  String description;
  bool isDefault;

  ImageDetail(
      {required this.url,
      required this.type,
      required this.isDefault,
      required this.description});

  ImageDetail copyWith({
    String? url,
    String? altText,
  }) =>
      ImageDetail(
        url: url ?? this.url,
        type: type ,
        isDefault: isDefault ,
        description: description ,
      );

    

    factory ImageDetail.fromJson(Map<String, dynamic> json) => ImageDetail(
        url: json["url"],
        type: json["type"],
        isDefault: json["isDefault"],
        description: json["description"],


    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
        "isDefault": isDefault,
        "description": description,

    };
}
