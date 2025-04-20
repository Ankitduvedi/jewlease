import 'dart:convert';

class BomModel {
  final List<BomRowModel> bomRows;
  final List<String> headers;

  BomModel({
    required this.bomRows,
    required this.headers,
  });

  factory BomModel.fromJson(Map<String, dynamic> json) {
    return BomModel(
        bomRows: List<BomRowModel>.from(
          json['data'].map((x) => BomRowModel.fromJson(x)) ?? [],
        ),
        headers: List<String>.from(json['headers'] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(bomRows.map((x) => x.toJson())),
      'headers': List<dynamic>.from(headers.map((x) => x)),
    };
  }

  String toJsonString() => json.encode(toJson());

  factory BomModel.fromJsonString(String source) =>
      BomModel.fromJson(json.decode(source));
}

class BomRowModel {
  final int rowNo;
  final String variantName;
  final String itemGroup;
  final double pieces;
  double weight;
  double rate;
  double avgWeight;
  double amount;
  final String spChar;
  final String operation;
  final String type;
  final List<dynamic> actions;
  String? formulaID;

  BomRowModel(
      {required this.rowNo,
      required this.variantName,
      required this.itemGroup,
      required this.pieces,
      required this.weight,
      required this.rate,
      required this.avgWeight,
      required this.amount,
      required this.spChar,
      required this.operation,
      required this.type,
      required this.actions,
      required this.formulaID});

  factory BomRowModel.fromJson(Map<String, dynamic> json) {
    return BomRowModel(
      rowNo: int.tryParse(json['Row No'].toString()) ?? 0,
      variantName: json['Variant Name'] as String? ?? '',
      itemGroup: json['Item Group'] as String? ?? '',
      pieces: double.tryParse(json['Pieces'].toString()) ?? 0.0,
      weight: double.tryParse(json['Weight'].toString()) ?? 0.0,
      rate: double.tryParse(json['Rate'].toString()) ?? 0.0,
      avgWeight: double.tryParse(json['Avg Weight'].toString()) ?? 0.0,
      amount: double.tryParse(json['Amount'].toString()) ?? 0.0,
      spChar: json['SpChar'] as String? ?? '',
      operation: json['Operation'] as String? ?? '',
      type: json['Type'] as String? ?? '',
      actions: List<dynamic>.from(json['Actions'] ?? []),
      formulaID: json['FormulaID'] as String?,
    );
  }

  factory BomRowModel.fromJsonDataRow(List<dynamic> values, int rowNo) {
    print("row $rowNo $values");
    return BomRowModel(
        rowNo: rowNo as int,
        variantName: values[0] as String? ?? '',
        itemGroup: values[1] as String? ?? '',
        pieces: (values[2] as num?)?.toDouble() ?? 0.0,
        weight: (values[3] as num?)?.toDouble() ?? 0.0,
        rate: (values[4] as num?)?.toDouble() ?? 0.0,
        avgWeight: (values[5] as num?)?.toDouble() ?? 0.0,
        amount: (values[6] as num?)?.toDouble() ?? 0.0,
        spChar: values[7] as String? ?? '',
        operation: values[8] as String? ?? '',
        type: values[9] as String? ?? '',
        actions: [],
        formulaID: "");
  }

  Map<String, dynamic> toJson() {
    return {
      'rowNo': rowNo,
      'variantName': variantName,
      'itemGroup': itemGroup,
      'pieces': pieces,
      'weight': weight,
      'rate': rate,
      'avgWeight': avgWeight,
      'amount': amount,
      'spChar': spChar,
      'operation': operation,
      'type': type,
      'actions': List<dynamic>.from(actions.map((x) => x)),
    };
  }

  Map<String, dynamic> toJson2() {
    return {
      'Row No': rowNo,
      'Variant Name': variantName,
      'Item Group': itemGroup,
      'Pieces': pieces,
      'Weight': weight,
      'Rate': rate,
      'Avg Weight': avgWeight,
      'Amount':amount,
      'SpChar': spChar,
      'Operation': operation,
      'Type':type,
      'Actions': actions,
      'FormulaID':formulaID,
    };
  }
}
