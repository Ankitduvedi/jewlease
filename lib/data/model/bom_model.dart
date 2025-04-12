import 'dart:convert';

class BomModel {
  final List<BomRowModel> data;
  final List<String> headers;

  BomModel({
    required this.data,
    required this.headers,
  });

  factory BomModel.fromJson(Map<String, dynamic> json) {
    return BomModel(
        data: List<BomRowModel>.from(
          json['data'].map((x) => BomRowModel.fromJson(x)) ?? [],
        ),
        headers: List<String>.from(json['headers'] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
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
  final double weight;
  final double rate;
  final double avgWeight;
  final double amount;
  final String spChar;
  final String operation;
  final String type;
  final List<dynamic> actions;

  BomRowModel({
    required this.rowNo,
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
  });

  factory BomRowModel.fromJson(Map<String, dynamic> json) {
    return BomRowModel(
      rowNo: json['rowNo'] as int,
      variantName: json['variantName'] as String? ?? '',
      itemGroup: json['itemGroup'] as String? ?? '',
      pieces: (json['pieces'] as num?)?.toDouble() ?? 0.0,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      avgWeight: (json['avgWeight'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      spChar: json['spChar'] as String? ?? '',
      operation: json['operation'] as String? ?? '',
      type: json['type'] as String? ?? '',
      actions: List<dynamic>.from(json['actions'] ?? []),
    );
  }

  factory BomRowModel.fromJsonDataRow(List<dynamic> values,int rowNo) {
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
    );
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
}
