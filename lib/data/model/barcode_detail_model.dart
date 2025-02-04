class BarcodeDetailModel {
  final String stockId;
  final String date;
  final String transNo;
  final String transType;
  final String source;
  final String destination;
  final String customer;
  final String vendor;
  final String sourceDept;
  final String destinationDept;
  final double exchangeRate;
  final String currency;
  final String salesPerson;
  final String term;
  final String remark;
  final String createdBy;
  final String varient;
  final String postingDate;

  BarcodeDetailModel({
    required this.stockId,
    required this.date,
    required this.transNo,
    required this.transType,
    required this.source,
    required this.destination,
    required this.customer,
    required this.vendor,
    required this.sourceDept,
    required this.destinationDept,
    required this.exchangeRate,
    required this.currency,
    required this.salesPerson,
    required this.term,
    required this.remark,
    required this.createdBy,
    required this.varient,
    required this.postingDate,
  });

  // Serialization: Convert the BarcodeDetail object to JSON
  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'date': date,
      'transNo': transNo,
      'transType': transType,
      'source': source,
      'destination': destination,
      'customer': customer,
      'vendor': vendor,
      'sourceDept': sourceDept,
      'destinationDept': destinationDept,
      'exchangeRate': exchangeRate,
      'currency': currency,
      'salesPerson': salesPerson,
      'term': term,
      'remark': remark,
      'createdBy': createdBy,
      'varient': varient,
      'postingDate': postingDate,
    };
  }

  // Deserialization: Convert JSON to BarcodeDetail object
  factory BarcodeDetailModel.fromJson(Map<String, dynamic> json) {
    print("detail json $json");
    return BarcodeDetailModel(
      stockId: json['Stock ID'] ?? '',
      date: json['Date'],
      transNo: json['Trans No'].toString(),
      transType: json['Trans Type'],
      source: json['Source'],
      destination: json['Destination'],
      customer: json['Customer'],
      vendor: json['Vendor'],
      sourceDept: json['Source Dept'],
      destinationDept: json['Destination Dept'],
      exchangeRate: double.parse(json['Exchange rate'].toString()),
      currency: json['Currency'],
      salesPerson: json['Sales Person'],
      term: json['Term'],
      remark: json['Remark'],
      createdBy: json['Created By'],
      varient: json['Varient'],
      postingDate: json['Posting Date'],
    );
  }
}
