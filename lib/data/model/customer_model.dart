import 'dart:convert';

CustomerModel customerFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
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

  CustomerModel({
    DateTime? creationDate,
    this.firstName = '',
    this.lastName = '',
    this.mobileNo = '',
    this.emailId = '',
    this.partyCode = '',
    this.customerGroup = '',
    this.title = '',
    DateTime? birthDate,
    this.parentCustomer = '',
    DateTime? anniversaryDate,
    this.schemeCustomer = '',
    this.aadharNo = '',
    this.panNo = '',
    this.panNoUrl = '',
    this.gstNo = '',
    this.defaultCurrency = '',
    this.remarks = '',
    this.status = '',
    this.giftApplicable = false,
    this.reverseCharges = '',
    this.billingAdd1 = '',
    this.salesNature = '',
    this.subCategorySales = '',
    this.billingAdd2 = '',
    this.billingPincode = '',
    this.billingCountry = '',
    this.billingState = '',
    this.otherNo = '',
    this.billingCity = '',
    this.billingPanNo = '',
    this.billingGstNo = '',
    this.copyBillingAddress = '',
    this.shippingAdd1 = '',
    this.shippingAdd2 = '',
    this.shippingPincode = '',
    this.shippingCountry = '',
    this.shippingState = '',
    this.shippingCity = '',
    this.shipMobileNo = '',
    this.cardType = '',
    this.cardNo = '',
    this.terms = '',
    this.religion = '',
    this.terms2 = '',
    DateTime? motherBirthday,
    DateTime? fatherBirthday,
    DateTime? spouseBirthday,
    DateTime? partyAnniversary,
    this.nriCustomer = false,
  })  : creationDate = creationDate ?? DateTime.now(),
        birthDate = birthDate ?? DateTime.now(),
        anniversaryDate = anniversaryDate ?? DateTime.now(),
        motherBirthday = motherBirthday ?? DateTime.now(),
        fatherBirthday = fatherBirthday ?? DateTime.now(),
        spouseBirthday = spouseBirthday ?? DateTime.now(),
        partyAnniversary = partyAnniversary ?? DateTime.now();

  CustomerModel copyWith({
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
      CustomerModel(
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

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        creationDate: _parseDateTime(json["Creation Date"]),
        firstName: json["First Name"] ?? '',
        lastName: json["Last Name"] ?? '',
        mobileNo: json["Mobile No"] ?? '',
        emailId: json["Email ID"] ?? '',
        partyCode: json["Party Code"] ?? '',
        customerGroup: json["Customer Group"] ?? '',
        title: json["Title"] ?? '',
        birthDate: _parseDateTime(json["Birth Date"]),
        parentCustomer: json["Parent Customer"] ?? '',
        anniversaryDate: _parseDateTime(json["Anniversary Date"]),
        schemeCustomer: json["Scheme Customer"] ?? '',
        aadharNo: json["Aadhar No"] ?? '',
        panNo: json["Pan No"] ?? '',
        panNoUrl: json["Pan No Url"] ?? '',
        gstNo: json["Gst No"] ?? '',
        defaultCurrency: json["Default Currency"] ?? '',
        remarks: json["Remarks"] ?? '',
        status: json["Status"] ?? '',
        giftApplicable: json["Gift Applicable"] == 1,
        reverseCharges: json["Reverse Charges"] ?? '',
        billingAdd1: json["Billing Add 1"] ?? '',
        salesNature: json["Sales Nature"] ?? '',
        subCategorySales: json["Sub Category Sales"] ?? '',
        billingAdd2: json["Billing Add 2"] ?? '',
        billingPincode: json["Billing Pincode"] ?? '',
        billingCountry: json["Billing Country"] ?? '',
        billingState: json["Billing State"] ?? '',
        otherNo: json["Other No"] ?? '',
        billingCity: json["Billing City"] ?? '',
        billingPanNo: json["Billing Pan No"] ?? '',
        billingGstNo: json["Billing Gst No"] ?? '',
        copyBillingAddress: json["Copy Billing Address"],
        shippingAdd1: json["Shipping Add 1"] ?? '',
        shippingAdd2: json["Shipping Add 2"] ?? '',
        shippingPincode: json["Shipping Pincode"] ?? '',
        shippingCountry: json["Shipping Country"] ?? '',
        shippingState: json["Shipping State"] ?? '',
        shippingCity: json["Shipping City"] ?? '',
        shipMobileNo: json["Ship Mobile No"] ?? '',
        cardType: json["Card Type"] ?? '',
        cardNo: json["Card No"] ?? '',
        terms: json["Terms"] ?? '',
        religion: json["Religion"] ?? '',
        terms2: json["Terms 2"] ?? '',
        motherBirthday: _parseDateTime(json["Mother Birthday"]),
        fatherBirthday: _parseDateTime(json["Father Birthday"]),
        spouseBirthday: _parseDateTime(json["Spouse Birthday"]),
        partyAnniversary: _parseDateTime(json["Party Anniversary"]),
        nriCustomer: json["NRI Customer"] == 1,
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

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return DateTime.now();
    }
    return DateTime.tryParse(value.toString());
  }

// Helper function to format DateTime to JSON
}
