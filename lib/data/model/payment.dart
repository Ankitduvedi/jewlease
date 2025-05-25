import 'dart:convert';

class PaymentModel {
  int faRecPayHdrId;
  int locationId;
  String location;
  int yearId;
  String payMode;
  double transAmount;
  double localAmount;
  String particulars;
  double drAmount;
  double crAmount;
  double runningBal;
  int payerAccountNo;
  String voucherNo;
  String transDate;
  String issuingParty;
  int partyId;
  String partyName;
  String remarks;
  int rowStatus;
  double oldTransAmount;
  int refTransId;
  int currencyId;
  String currencyCode;
  String ifscCode;
  String cardNumber;
  int expiryMonth;
  int expiryYear;
  String panNo;
  int id;

  PaymentModel({
    required this.faRecPayHdrId,
    required this.locationId,
    required this.location,
    required this.yearId,
    required this.payMode,
    required this.transAmount,
    required this.localAmount,
    required this.particulars,
    required this.drAmount,
    required this.crAmount,
    required this.runningBal,
    required this.payerAccountNo,
    required this.voucherNo,
    required this.transDate,
    required this.issuingParty,
    required this.partyId,
    required this.partyName,
    required this.remarks,
    required this.rowStatus,
    required this.oldTransAmount,
    required this.refTransId,
    required this.currencyId,
    required this.currencyCode,
    required this.ifscCode,
    required this.cardNumber,
    required this.expiryMonth,
    required this.expiryYear,
    required this.panNo,
    required this.id,
  });

  // Convert Payment object to JSON
  Map<String, dynamic> toJson() => {
    'faRecPayHdrId': faRecPayHdrId,
    'locationId': locationId,
    'location': location,
    'yearId': yearId,
    'payMode': payMode,
    'transAmount': transAmount,
    'localAmount': localAmount,
    'particulars': particulars,
    'drAmount': drAmount,
    'crAmount': crAmount,
    'runningBal': runningBal,
    'payerAccountNo': payerAccountNo,
    'voucherNo': voucherNo,
    'transDate': transDate,
    'issuingParty': issuingParty,
    'partyId': partyId,
    'partyName': partyName,
    'remarks': remarks,
    'rowStatus': rowStatus,
    'oldTransAmount': oldTransAmount,
    'refTransId': refTransId,
    'currencyId': currencyId,
    'currencyCode': currencyCode,
    'ifscCode': ifscCode,
    'cardNumber': cardNumber,
    'expiryMonth': expiryMonth,
    'expiryYear': expiryYear,
    'panNo': panNo,
    'id': id,
  };

  // Create Payment object from JSON
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      faRecPayHdrId: json['faRecPayHdrId'] as int,
      locationId: json['locationId'] as int,
      location: json['location'] as String,
      yearId: json['yearId'] as int,
      payMode: json['payMode'] as String,
      transAmount: double.parse(json['transAmount']),
      localAmount: double.parse(json['localAmount']),
      particulars: json['particulars'] as String,
      drAmount: double.parse(json['drAmount']??"0"),
      crAmount: double.parse(json['crAmount'] ??"0") ,
      runningBal: double.parse(json['runningBal']??"0"),
      payerAccountNo: json['payerAccountNo'] as int,
      voucherNo: json['voucherNo'] as String,
      transDate: json['transDate'] as String,
      issuingParty: json['issuingParty'] as String,
      partyId: json['partyID']??0,
      partyName: json['partyName'] as String,
      remarks: json['remarks'] as String,
      rowStatus: json['rowStatus'] as int,
      oldTransAmount: double.parse(json['rldTransAmount']),
      refTransId: json['refTransID'] as int,
      currencyId: json['currencyID'] as int,
      currencyCode: json['currencyCode'] as String,
      ifscCode: json['ifscCode'] as String,
      cardNumber: json['cardNumber'] as String,
      expiryMonth: json['expiryMonth'] as int,
      expiryYear: json['expiryYear'] as int,
      panNo: json['panNo'] as String,
      id: json['id']??0 ,
    );
  }

  // Helper method to encode to JSON string
  String toJsonString() => json.encode(toJson());

  // Helper method to decode from JSON string
  factory PaymentModel.fromJsonString(String jsonString) =>
      PaymentModel.fromJson(json.decode(jsonString));
}