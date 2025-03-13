// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  DateTime creationDate;
  String firstName;
  String lastName;
  String mobileNo;
  String emailId;
  String partyCode;
  String customerGroup;
  String title;
  DateTime birthDate;
  String parentCustomer;
  DateTime anniversaryDate;
  String schemeCustomer;
  String aadharNo;
  String panNo;
  String panNoUrl;
  String gstNo;
  String defaultCurrency;
  String remarks;
  String status;
  bool giftApplicable;
  String reverseCharges;
  String billingAdd1;
  String salesNature;
  String subCategorySales;
  String billingAdd2;
  String billingPincode;
  String billingCountry;
  String billingState;
  String otherNo;
  String billingCity;
  String billingPanNo;
  String billingGstNo;
  String copyBillingAddress;
  String shippingAdd1;
  String shippingAdd2;
  String shippingPincode;
  String shippingCountry;
  String shippingState;
  String shippingCity;
  String shipMobileNo;
  String cardType;
  String cardNo;
  String terms;
  String religion;
  String terms2;
  DateTime motherBirthday;
  DateTime fatherBirthday;
  DateTime spouseBirthday;
  DateTime partyAnniversary;
  bool nriCustomer;

  Customer({
    required this.creationDate,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.emailId,
    required this.partyCode,
    required this.customerGroup,
    required this.title,
    required this.birthDate,
    required this.parentCustomer,
    required this.anniversaryDate,
    required this.schemeCustomer,
    required this.aadharNo,
    required this.panNo,
    required this.panNoUrl,
    required this.gstNo,
    required this.defaultCurrency,
    required this.remarks,
    required this.status,
    required this.giftApplicable,
    required this.reverseCharges,
    required this.billingAdd1,
    required this.salesNature,
    required this.subCategorySales,
    required this.billingAdd2,
    required this.billingPincode,
    required this.billingCountry,
    required this.billingState,
    required this.otherNo,
    required this.billingCity,
    required this.billingPanNo,
    required this.billingGstNo,
    required this.copyBillingAddress,
    required this.shippingAdd1,
    required this.shippingAdd2,
    required this.shippingPincode,
    required this.shippingCountry,
    required this.shippingState,
    required this.shippingCity,
    required this.shipMobileNo,
    required this.cardType,
    required this.cardNo,
    required this.terms,
    required this.religion,
    required this.terms2,
    required this.motherBirthday,
    required this.fatherBirthday,
    required this.spouseBirthday,
    required this.partyAnniversary,
    required this.nriCustomer,
  });

  Customer copyWith({
    DateTime? creationDate,
    String? firstName,
    String? lastName,
    String? mobileNo,
    String? emailId,
    String? partyCode,
    String? customerGroup,
    String? title,
    DateTime? birthDate,
    String? parentCustomer,
    DateTime? anniversaryDate,
    String? schemeCustomer,
    String? aadharNo,
    String? panNo,
    String? panNoUrl,
    String? gstNo,
    String? defaultCurrency,
    String? remarks,
    String? status,
    bool? giftApplicable,
    String? reverseCharges,
    String? billingAdd1,
    String? salesNature,
    String? subCategorySales,
    String? billingAdd2,
    String? billingPincode,
    String? billingCountry,
    String? billingState,
    String? otherNo,
    String? billingCity,
    String? billingPanNo,
    String? billingGstNo,
    String? copyBillingAddress,
    String? shippingAdd1,
    String? shippingAdd2,
    String? shippingPincode,
    String? shippingCountry,
    String? shippingState,
    String? shippingCity,
    String? shipMobileNo,
    String? cardType,
    String? cardNo,
    String? terms,
    String? religion,
    String? terms2,
    DateTime? motherBirthday,
    DateTime? fatherBirthday,
    DateTime? spouseBirthday,
    DateTime? partyAnniversary,
    bool? nriCustomer,
  }) =>
      Customer(
        creationDate: creationDate ?? this.creationDate,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobileNo: mobileNo ?? this.mobileNo,
        emailId: emailId ?? this.emailId,
        partyCode: partyCode ?? this.partyCode,
        customerGroup: customerGroup ?? this.customerGroup,
        title: title ?? this.title,
        birthDate: birthDate ?? this.birthDate,
        parentCustomer: parentCustomer ?? this.parentCustomer,
        anniversaryDate: anniversaryDate ?? this.anniversaryDate,
        schemeCustomer: schemeCustomer ?? this.schemeCustomer,
        aadharNo: aadharNo ?? this.aadharNo,
        panNo: panNo ?? this.panNo,
        panNoUrl: panNoUrl ?? this.panNoUrl,
        gstNo: gstNo ?? this.gstNo,
        defaultCurrency: defaultCurrency ?? this.defaultCurrency,
        remarks: remarks ?? this.remarks,
        status: status ?? this.status,
        giftApplicable: giftApplicable ?? this.giftApplicable,
        reverseCharges: reverseCharges ?? this.reverseCharges,
        billingAdd1: billingAdd1 ?? this.billingAdd1,
        salesNature: salesNature ?? this.salesNature,
        subCategorySales: subCategorySales ?? this.subCategorySales,
        billingAdd2: billingAdd2 ?? this.billingAdd2,
        billingPincode: billingPincode ?? this.billingPincode,
        billingCountry: billingCountry ?? this.billingCountry,
        billingState: billingState ?? this.billingState,
        otherNo: otherNo ?? this.otherNo,
        billingCity: billingCity ?? this.billingCity,
        billingPanNo: billingPanNo ?? this.billingPanNo,
        billingGstNo: billingGstNo ?? this.billingGstNo,
        copyBillingAddress: copyBillingAddress ?? this.copyBillingAddress,
        shippingAdd1: shippingAdd1 ?? this.shippingAdd1,
        shippingAdd2: shippingAdd2 ?? this.shippingAdd2,
        shippingPincode: shippingPincode ?? this.shippingPincode,
        shippingCountry: shippingCountry ?? this.shippingCountry,
        shippingState: shippingState ?? this.shippingState,
        shippingCity: shippingCity ?? this.shippingCity,
        shipMobileNo: shipMobileNo ?? this.shipMobileNo,
        cardType: cardType ?? this.cardType,
        cardNo: cardNo ?? this.cardNo,
        terms: terms ?? this.terms,
        religion: religion ?? this.religion,
        terms2: terms2 ?? this.terms2,
        motherBirthday: motherBirthday ?? this.motherBirthday,
        fatherBirthday: fatherBirthday ?? this.fatherBirthday,
        spouseBirthday: spouseBirthday ?? this.spouseBirthday,
        partyAnniversary: partyAnniversary ?? this.partyAnniversary,
        nriCustomer: nriCustomer ?? this.nriCustomer,
      );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        creationDate: DateTime.parse(json["creationDate"]),
        firstName: json["firstName"],
        lastName: json["lastName"],
        mobileNo: json["mobileNo"],
        emailId: json["emailId"],
        partyCode: json["partyCode"],
        customerGroup: json["customerGroup"],
        title: json["title"],
        birthDate: DateTime.parse(json["birthDate"]),
        parentCustomer: json["parentCustomer"],
        anniversaryDate: DateTime.parse(json["anniversaryDate"]),
        schemeCustomer: json["schemeCustomer"],
        aadharNo: json["aadharNo"],
        panNo: json["panNo"],
        panNoUrl: json["panNoUrl"],
        gstNo: json["gstNo"],
        defaultCurrency: json["defaultCurrency"],
        remarks: json["remarks"],
        status: json["status"],
        giftApplicable: json["giftApplicable"],
        reverseCharges: json["reverseCharges"],
        billingAdd1: json["billingAdd1"],
        salesNature: json["salesNature"],
        subCategorySales: json["subCategorySales"],
        billingAdd2: json["billingAdd2"],
        billingPincode: json["billingPincode"],
        billingCountry: json["billingCountry"],
        billingState: json["billingState"],
        otherNo: json["otherNo"],
        billingCity: json["billingCity"],
        billingPanNo: json["billingPanNo"],
        billingGstNo: json["billingGstNo"],
        copyBillingAddress: json["copyBillingAddress"],
        shippingAdd1: json["shippingAdd1"],
        shippingAdd2: json["shippingAdd2"],
        shippingPincode: json["shippingPincode"],
        shippingCountry: json["shippingCountry"],
        shippingState: json["shippingState"],
        shippingCity: json["shippingCity"],
        shipMobileNo: json["shipMobileNo"],
        cardType: json["cardType"],
        cardNo: json["cardNo"],
        terms: json["terms"],
        religion: json["religion"],
        terms2: json["terms2"],
        motherBirthday: DateTime.parse(json["motherBirthday"]),
        fatherBirthday: DateTime.parse(json["fatherBirthday"]),
        spouseBirthday: DateTime.parse(json["spouseBirthday"]),
        partyAnniversary: DateTime.parse(json["partyAnniversary"]),
        nriCustomer: json["nriCustomer"],
      );

  Map<String, dynamic> toJson() => {
        "creationDate":
            "${creationDate.year.toString().padLeft(4, '0')}-${creationDate.month.toString().padLeft(2, '0')}-${creationDate.day.toString().padLeft(2, '0')}",
        "firstName": firstName,
        "lastName": lastName,
        "mobileNo": mobileNo,
        "emailId": emailId,
        "partyCode": partyCode,
        "customerGroup": customerGroup,
        "title": title,
        "birthDate":
            "${birthDate.year.toString().padLeft(4, '0')}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}",
        "parentCustomer": parentCustomer,
        "anniversaryDate":
            "${anniversaryDate.year.toString().padLeft(4, '0')}-${anniversaryDate.month.toString().padLeft(2, '0')}-${anniversaryDate.day.toString().padLeft(2, '0')}",
        "schemeCustomer": schemeCustomer,
        "aadharNo": aadharNo,
        "panNo": panNo,
        "panNoUrl": panNoUrl,
        "gstNo": gstNo,
        "defaultCurrency": defaultCurrency,
        "remarks": remarks,
        "status": status,
        "giftApplicable": giftApplicable,
        "reverseCharges": reverseCharges,
        "billingAdd1": billingAdd1,
        "salesNature": salesNature,
        "subCategorySales": subCategorySales,
        "billingAdd2": billingAdd2,
        "billingPincode": billingPincode,
        "billingCountry": billingCountry,
        "billingState": billingState,
        "otherNo": otherNo,
        "billingCity": billingCity,
        "billingPanNo": billingPanNo,
        "billingGstNo": billingGstNo,
        "copyBillingAddress": copyBillingAddress,
        "shippingAdd1": shippingAdd1,
        "shippingAdd2": shippingAdd2,
        "shippingPincode": shippingPincode,
        "shippingCountry": shippingCountry,
        "shippingState": shippingState,
        "shippingCity": shippingCity,
        "shipMobileNo": shipMobileNo,
        "cardType": cardType,
        "cardNo": cardNo,
        "terms": terms,
        "religion": religion,
        "terms2": terms2,
        "motherBirthday":
            "${motherBirthday.year.toString().padLeft(4, '0')}-${motherBirthday.month.toString().padLeft(2, '0')}-${motherBirthday.day.toString().padLeft(2, '0')}",
        "fatherBirthday":
            "${fatherBirthday.year.toString().padLeft(4, '0')}-${fatherBirthday.month.toString().padLeft(2, '0')}-${fatherBirthday.day.toString().padLeft(2, '0')}",
        "spouseBirthday":
            "${spouseBirthday.year.toString().padLeft(4, '0')}-${spouseBirthday.month.toString().padLeft(2, '0')}-${spouseBirthday.day.toString().padLeft(2, '0')}",
        "partyAnniversary":
            "${partyAnniversary.year.toString().padLeft(4, '0')}-${partyAnniversary.month.toString().padLeft(2, '0')}-${partyAnniversary.day.toString().padLeft(2, '0')}",
        "nriCustomer": nriCustomer,
      };
}
