class OperationRow {
  final String calcBom;
  final String operation;
  final int calcQty;
  final int type;
  final int calcMethod;

  const OperationRow({
    required this.calcBom,
    required this.operation,
    this.calcQty = 0,
    this.type = 0,
    this.calcMethod = 0,
  });

  factory OperationRow.fromMap(Map<String, dynamic> data) {
    return OperationRow(
      calcBom: data['Calc Bom'] ?? '',
      operation: data['Operation'] ?? '',
      calcQty: data['Calc Qty'] ?? 0,
      type: data['Type'] ?? 0,
      calcMethod: data['Calc Method'] ?? 0,
    );
  }
}