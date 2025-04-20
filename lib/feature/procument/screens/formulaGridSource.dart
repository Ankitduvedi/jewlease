import 'package:flutter/material.dart';
import 'package:jewlease/data/model/formula_model.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class formulaGridSource extends DataGridSource {
  formulaGridSource(
      this.dataGridRows,
      this.onDelete,
      this.onEdit,
      this.formulaExcel,
      this.formulaHeaders,
      this.rangeExcel,
      this.varientAttributes)
      : _editingRows = dataGridRows {
    // Call onEdit after initialization
    recalculatedataGridValues();
    onEdit(dataGridRows);
  }

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function(List<DataGridRow>) onEdit;
  final List<FormulaRowModel> formulaExcel;
  final List<dynamic> formulaHeaders;
  final Map<dynamic, dynamic> rangeExcel;
  final Map<String, dynamic> varientAttributes;

  @override
  List<DataGridRow> get rows => dataGridRows;

  double calculateFormulaVaule(String formula) {
    if (formula == '') {
      return 0.0;
    }

    String replacedFormula = formula.replaceAllMapped(
      RegExp(r'\[R(\d+)\]'),
      (match) {
        int rowNo = int.parse(match.group(1)!);

        dynamic value = dataGridRows[rowNo - 1]
            .getCells()
            .firstWhere((cell) => cell.columnName == 'Row Value')
            .value;
        print("formula $formula row no $rowNo value $value");
        return value.toString();
      },
    );
    print("replace formula is $replacedFormula");
    try {
      Parser parser = Parser();
      Expression exp = parser.parse(replacedFormula);
      ContextModel context = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, context);
      print("final calculated value $result");
      return result;
    } catch (e) {
      print('Error evaluating expression: $replacedFormula. Details: $e');
      return 0;
    }
  }

  double findMatchingRowValue(Map<String, dynamic> attributes,
      List<dynamic> rangeHeaderList, List<List<dynamic>> rangeMatrixData) {
    // Copy the matrixData for filtering
    print("range headers $rangeHeaderList  rangeMatrix $rangeMatrixData");
    print("attribute to compare are:  $attributes");
    List<List<dynamic>> filteredRows = List.from(rangeMatrixData);

    // Iterate over each attribute to filter rows
    for (String rangeheader in rangeHeaderList) {
      // Get the index of the column for the current attribute
      if (rangeheader == "Output") continue;
      int columnIndex = rangeHeaderList.indexOf(rangeheader);
      print("headerName is $rangeheader columnIndex $columnIndex");

      // Get the attribute value to match
      dynamic attributeValue = attributes[rangeheader];
      print("attributeValue is $attributeValue ");

      // Filter rows where the value in the current column matches the attribute value
      if (attributeValue != null)
        filteredRows = filteredRows
            .where((row) => row[columnIndex] == attributeValue)
            .toList();

      // If only one row is left, return its first column value
      if (filteredRows.length == 1) {
        return int.parse(filteredRows.first[0]) * 1.0;
      }
    }

    // If no row satisfies the condition, throw an exception or return a default value
    return 0.0;
  }

  double rangeCalculation(String rangeKey) {
    print("range excel is $rangeExcel");
    rangeKey = "15 jan";
    List<dynamic> excelData = rangeExcel[rangeKey]["Details"]["excelData"];
    List<dynamic> excelHeaders = rangeExcel[rangeKey]["Details"]["Headers"];
    List<List<dynamic>> matrixdata = List.from(excelData);
    double rangeOutput =
        findMatchingRowValue(varientAttributes, excelHeaders, matrixdata);
    return rangeOutput;
  }

  double formulaCalulation(String formula) {
    double result = calculateFormulaVaule(formula);
    return result;
  }

  double inputCalculation(int rowIndex, double currentValue) {
    return currentValue;
  }

  void recalculatedataGridValues() {
    for (int i = 0; i < dataGridRows.length; i++) {
      dataGridRows[i] = DataGridRow(cells: [
        for (var cell in dataGridRows[i].getCells())
          if (cell.columnName == 'Row Value')
            if (formulaExcel[i].dataType == "Range")
              DataGridCell<double>(
                columnName: cell.columnName,
                value: rangeCalculation(formulaExcel[i].rowExpression),
              )
            else if (formulaExcel[i].dataType == "Calculation")
              DataGridCell<double>(
                columnName: cell.columnName,
                value: formulaCalulation(formulaExcel[i].rowExpression),
              )
            else
              DataGridCell<double>(
                  columnName: cell.columnName,
                  value: inputCalculation(i, cell.value))
          else
            cell
      ]);
    }
  }

  // Method to calculate column summation for a summary row
  DataGridRow getSummaryRow() {
    final Map<String, double> columnTotals = {};

    for (final row in dataGridRows) {
      for (final cell in row.getCells()) {
        if (cell.value is num) {
          columnTotals[cell.columnName] =
              (columnTotals[cell.columnName] ?? 0) + cell.value;
        }
      }
    }

    return DataGridRow(
      cells: [
        for (var entry in columnTotals.entries)
          DataGridCell<double>(
            columnName: entry.key,
            value: entry.value,
          ),
      ],
    );
  }

  void updateDataGridSource() {
    notifyListeners();
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        int rowFormulaIndex = dataGridRows.indexOf(row);
        return Container(
          alignment: Alignment.center,
          child: TextField(
            style: TextStyle(
                color: formulaExcel[rowFormulaIndex].editableInd == 0 &&
                        dataCell.columnName == "Row Value"
                    ? Colors.grey
                    : Colors.black),
            onSubmitted: (value) {
              double parsedValue = double.tryParse(value) ?? 0;
              int rowIndex = dataGridRows.indexOf(row);
              print("updated row index is $rowIndex");
              dataGridRows[rowFormulaIndex] = DataGridRow(cells: [
                for (var cell in row.getCells())
                  if (cell == dataCell)
                    DataGridCell<double>(
                      columnName: cell.columnName,
                      value: parsedValue,
                    )
                  else
                    cell,
              ]);

              recalculatedataGridValues();
              onEdit(dataGridRows);
            },
            controller: TextEditingController(
              text: dataCell.value.toString(),
            ),
            keyboardType: TextInputType.number,
            readOnly: formulaExcel[rowFormulaIndex].editableInd == 0
                ? true
                : dataCell.columnName != "Row Value"
                    ? true
                    : false,
            decoration: InputDecoration(
              border: InputBorder.none,

              isDense: true,
              // enabled: formulaExcel[rowFormulaIndex].editableInd == 1 &&
              //     ? true
              //     : false,
            ),
          ),
        );
      }).toList(),
    );
  }
}
