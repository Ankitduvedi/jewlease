class BarcodeHistoryModel {
  final String stockId;
  final String attribute;
  final String varient;
  final String transactionNumber;
  final String date;
  final Map<String, dynamic> bom;
  final Map<String, dynamic> operation;
  final Map<String, dynamic> formula;

  BarcodeHistoryModel({
    required this.stockId,
    required this.attribute,
    required this.varient,
    required this.transactionNumber,
    required this.date,
    required this.bom,
    required this.operation,
    required this.formula,
  });

  // Serialization: Convert the HistoryModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'stockId': stockId,
      'attribute': attribute,
      'varient': varient,
      'transactionNumber': transactionNumber,
      'date': date,
      'bom': bom,
      'operation': operation,
      'formula': formula,
    };
  }

  // Deserialization: Convert JSON to HistoryModel object
  factory BarcodeHistoryModel.fromJson(Map<String, dynamic> json) {
    print("json $json");
    return BarcodeHistoryModel(
      stockId: json['Stock ID'],
      attribute: json['Attribute'],
      varient: json['Varient'],
      transactionNumber: json['Transaction Number'],
      date: json['Date'],
      bom: json['BOM'],
      operation: json['Operation'],
      formula: json['Formula'],
    );
  }
}
