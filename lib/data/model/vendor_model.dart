// To parse this JSON data, do
//
//     final vendor = vendorFromJson(jsonString);

import 'dart:convert';

Vendor vendorFromJson(String str) => Vendor.fromJson(json.decode(str));

String vendorToJson(Vendor data) => json.encode(data.toJson());

class Vendor {
    String gstRegistrationType;
    String initials;
    String vendorCode;
    String vendorName;
    String defaultCurrency;
    String agentName;
    String defaultTerms;
    String rowStatus;
    String logoFileName;
    String localSalesTaxNo;
    String salesTaxNo;
    String panNo;
    String aadharNo;
    String msmeCertificateNo;
    String vendorType;
    String tanNo;
    String vanNo;
    String gstNo;
    String msmeRegistered;
    String allowWastage;
    String allowLabour;
    String correspondingLocation;
    bool nominatedAgency;
    String exchangePercent;
    String returnsTerm;
    String udyogAdharNo;
    String exchangeTerms;
    String tds194Q;

    Vendor({
        required this.gstRegistrationType,
        required this.initials,
        required this.vendorCode,
        required this.vendorName,
        required this.defaultCurrency,
        required this.agentName,
        required this.defaultTerms,
        required this.rowStatus,
        required this.logoFileName,
        required this.localSalesTaxNo,
        required this.salesTaxNo,
        required this.panNo,
        required this.aadharNo,
        required this.msmeCertificateNo,
        required this.vendorType,
        required this.tanNo,
        required this.vanNo,
        required this.gstNo,
        required this.msmeRegistered,
        required this.allowWastage,
        required this.allowLabour,
        required this.correspondingLocation,
        required this.nominatedAgency,
        required this.exchangePercent,
        required this.returnsTerm,
        required this.udyogAdharNo,
        required this.exchangeTerms,
        required this.tds194Q,
    });

    Vendor copyWith({
        String? gstRegistrationType,
        String? initials,
        String? vendorCode,
        String? vendorName,
        String? defaultCurrency,
        String? agentName,
        String? defaultTerms,
        String? rowStatus,
        String? logoFileName,
        String? localSalesTaxNo,
        String? salesTaxNo,
        String? panNo,
        String? aadharNo,
        String? msmeCertificateNo,
        String? vendorType,
        String? tanNo,
        String? vanNo,
        String? gstNo,
        String? msmeRegistered,
        String? allowWastage,
        String? allowLabour,
        String? correspondingLocation,
        bool? nominatedAgency,
        String? exchangePercent,
        String? returnsTerm,
        String? udyogAdharNo,
        String? exchangeTerms,
        String? tds194Q,
    }) => 
        Vendor(
            gstRegistrationType: gstRegistrationType ?? this.gstRegistrationType,
            initials: initials ?? this.initials,
            vendorCode: vendorCode ?? this.vendorCode,
            vendorName: vendorName ?? this.vendorName,
            defaultCurrency: defaultCurrency ?? this.defaultCurrency,
            agentName: agentName ?? this.agentName,
            defaultTerms: defaultTerms ?? this.defaultTerms,
            rowStatus: rowStatus ?? this.rowStatus,
            logoFileName: logoFileName ?? this.logoFileName,
            localSalesTaxNo: localSalesTaxNo ?? this.localSalesTaxNo,
            salesTaxNo: salesTaxNo ?? this.salesTaxNo,
            panNo: panNo ?? this.panNo,
            aadharNo: aadharNo ?? this.aadharNo,
            msmeCertificateNo: msmeCertificateNo ?? this.msmeCertificateNo,
            vendorType: vendorType ?? this.vendorType,
            tanNo: tanNo ?? this.tanNo,
            vanNo: vanNo ?? this.vanNo,
            gstNo: gstNo ?? this.gstNo,
            msmeRegistered: msmeRegistered ?? this.msmeRegistered,
            allowWastage: allowWastage ?? this.allowWastage,
            allowLabour: allowLabour ?? this.allowLabour,
            correspondingLocation: correspondingLocation ?? this.correspondingLocation,
            nominatedAgency: nominatedAgency ?? this.nominatedAgency,
            exchangePercent: exchangePercent ?? this.exchangePercent,
            returnsTerm: returnsTerm ?? this.returnsTerm,
            udyogAdharNo: udyogAdharNo ?? this.udyogAdharNo,
            exchangeTerms: exchangeTerms ?? this.exchangeTerms,
            tds194Q: tds194Q ?? this.tds194Q,
        );

    factory Vendor.fromJson(Map<String, dynamic> json) => Vendor(
        gstRegistrationType: json["GstRegistrationType"],
        initials: json["Initials"],
        vendorCode: json["VendorCode"],
        vendorName: json["VendorName"],
        defaultCurrency: json["DefaultCurrency"],
        agentName: json["AgentName"],
        defaultTerms: json["DefaultTerms"],
        rowStatus: json["RowStatus"],
        logoFileName: json["LogoFileName"],
        localSalesTaxNo: json["LocalSalesTAXNo"],
        salesTaxNo: json["SalesTAXNo"],
        panNo: json["PANNo"],
        aadharNo: json["AadharNo"],
        msmeCertificateNo: json["MSMECertificateNo"],
        vendorType: json["VendorType"],
        tanNo: json["TANNo"],
        vanNo: json["VANNo"],
        gstNo: json["GSTNo"],
        msmeRegistered: json["MSMERegistered"],
        allowWastage: json["AllowWastage"],
        allowLabour: json["AllowLabour"],
        correspondingLocation: json["CorrespondingLocation"],
        nominatedAgency: json["NominatedAgency"],
        exchangePercent: json["ExchangePercent"],
        returnsTerm: json["ReturnsTerm"],
        udyogAdharNo: json["UdyogAdharNo"],
        exchangeTerms: json["ExchangeTerms"],
        tds194Q: json["TDS194Q"],
    );

    Map<String, dynamic> toJson() => {
        "GstRegistrationType": gstRegistrationType,
        "Initials": initials,
        "VendorCode": vendorCode,
        "VendorName": vendorName,
        "DefaultCurrency": defaultCurrency,
        "AgentName": agentName,
        "DefaultTerms": defaultTerms,
        "RowStatus": rowStatus,
        "LogoFileName": logoFileName,
        "LocalSalesTAXNo": localSalesTaxNo,
        "SalesTAXNo": salesTaxNo,
        "PANNo": panNo,
        "AadharNo": aadharNo,
        "MSMECertificateNo": msmeCertificateNo,
        "VendorType": vendorType,
        "TANNo": tanNo,
        "VANNo": vanNo,
        "GSTNo": gstNo,
        "MSMERegistered": msmeRegistered,
        "AllowWastage": allowWastage,
        "AllowLabour": allowLabour,
        "CorrespondingLocation": correspondingLocation,
        "NominatedAgency": nominatedAgency,
        "ExchangePercent": exchangePercent,
        "ReturnsTerm": returnsTerm,
        "UdyogAdharNo": udyogAdharNo,
        "ExchangeTerms": exchangeTerms,
        "TDS194Q": tds194Q,
    };
}
