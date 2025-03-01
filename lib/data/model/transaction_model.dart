class TransactionModel {
  final String transType;
  final String subType;
  final String transCategory;
  final String docNo;
  final String transDate;
  final String source;
  final String destination;
  final String customer;
  final String sourceDept;
  final String destinationDept;
  final String exchangeRate;
  final String currency;
  final String salesPerson;
  final String term;
  final String remark;
  final String createdBy;
  final String postingDate;
  final List<Map<String, dynamic>> varients;

  TransactionModel({
    required this.transType,
    required this.subType,
    required this.transCategory,
    required this.docNo,
    required this.transDate,
    required this.source,
    required this.destination,
    required this.customer,
    required this.sourceDept,
    required this.destinationDept,
    required this.exchangeRate,
    required this.currency,
    required this.salesPerson,
    required this.term,
    required this.remark,
    required this.createdBy,
    required this.postingDate,
    required this.varients,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
        transType: json['transType'],
        subType: json['subType'],
        transCategory: json['transCategory'],
        docNo: json['docNo'],
        transDate: json['transDate'],
        source: json['source'],
        destination: json['destination'],
        customer: json['customer'],
        sourceDept: json['sourceDept'],
        destinationDept: json['destinationDept'],
        exchangeRate: json['exchangeRate'],
        currency: json['currency'],
        salesPerson: json['salesPerson'],
        term: json['term'],
        remark: json['remark'],
        createdBy: json['createdBy'],
        postingDate: json['postingDate'],
        varients: (json['varients'] as List<dynamic>)
            .map((item) => covertMap(item as Map<String, dynamic>))
            .toList());
  }

  static Map<String, dynamic> covertMap(Map<String, dynamic> item) {
    return item;
  }

  Map<String, dynamic> toJson() {
    return {
      'transType': transType,
      'subType': subType,
      'transCategory': transCategory,
      'docNo': docNo,
      'transDate': transDate,
      'source': source,
      'destination': destination,
      'customer': customer,
      'sourceDept': sourceDept,
      'destinationDept': destinationDept,
      'exchangeRate': exchangeRate,
      'currency': currency,
      'salesPerson': salesPerson,
      'term': term,
      'remark': remark,
      'createdBy': createdBy,
      'postingDate': postingDate,
      'varients': varients,
    };
  }
}
