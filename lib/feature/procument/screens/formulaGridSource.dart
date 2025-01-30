import 'package:flutter/material.dart';
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
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function(List<DataGridRow>) onEdit;
  final List<dynamic> formulaExcel;
  final List<dynamic> formulaHeaders;
  final Map<dynamic, dynamic> rangeExcel;
  final Map<String, dynamic> varientAttributes;

  @override
  List<DataGridRow> get rows => dataGridRows;

  double calculateFormulaVaule(int index, dynamic cellValue) {
    int formulaColumIndex = formulaHeaders.indexOf('Formula');
    print("cellValue is ${cellValue.runtimeType} $cellValue");

    if (cellValue.runtimeType == String) cellValue = double.parse(cellValue);

    String formula = formulaExcel[index][formulaColumIndex];

    print("current row is $index formula is $formula");
    if (formula == '') return cellValue * 1.0;

    String replacedFormula = formula.replaceAllMapped(
      RegExp(r'\[R(\d+)\]'),
      (match) {
        int rowNo = int.parse(match.group(1)!);
        // Fetch value for the row number
        dynamic value = dataGridRows[rowNo - 1]
            .getCells()
            .firstWhere((cell) => cell.columnName == 'Row Value')
            .value;
        return value.toString();
      },
    );
    print("replace formula is $replacedFormula");

    try {
      Parser parser = Parser();
      Expression exp = parser.parse(replacedFormula);
      ContextModel context = ContextModel();
      print(
          "final calculated value ${exp.evaluate(EvaluationType.REAL, context)}");
      return exp.evaluate(EvaluationType.REAL, context);
    } catch (e) {
      throw Exception(
          'Error evaluating expression: $replacedFormula. Details: $e');
    }
  }

  double? findOutput(String accessory, double weight) {
    List<dynamic> rows = rangeExcel["Details"]["excelData"];
    print("range excel is$rangeExcel");
    print("rows are $rows");

    for (var row in rows) {
      double output = double.parse(row[0]);
      double start = double.parse(row[1]);
      double end = double.parse(row[2]);
      String acc = row[3];

      if (acc == accessory && weight >= start && weight <= end) {
        return output;
      }
    }

    // If no match is found
    return null;
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

  void recalculatedataGridValues(int updatedRowIndex, cellNewValue) {
    print(
        "updated rowIndex $updatedRowIndex updated Cell value is $cellNewValue");
    for (int i = 0; i < dataGridRows.length; i++) {
      print(
          "<----------------------row $i update start------------------------->");
      dataGridRows[i] = DataGridRow(cells: [
        //<----------------Code to update formula grid all value based on formula----------------->
        for (var cell in dataGridRows[i].getCells())
          if (cell.columnName == 'Row Value')
            DataGridCell<double>(
                columnName: cell.columnName,
                value: calculateFormulaVaule(
                    i, updatedRowIndex == i ? cellNewValue : cell.value))
          else
            cell
      ]);

      //<----------------Code to update formula grid range value based on formula----------------->
      if (i == 2) {
        String? rangeHierarchyName =
            formulaExcel[i][formulaHeaders.indexOf('Range Value')];
        print(
            " ${formulaHeaders.indexOf('Range Value')}rangehierarchyName  $rangeHierarchyName currentIndex $updatedRowIndex $formulaExcel");
        if (rangeHierarchyName != null && rangeHierarchyName != "") {
          List<dynamic> excelData = rangeExcel["Details"]["excelData"];
          List<List<dynamic>> matrixdata = List.from(excelData);

          double? rangeOutput = findMatchingRowValue(
              varientAttributes, rangeExcel["Details"]["Headers"], matrixdata);
          // findOutput("18", metalWeight);

          dataGridRows[i] = DataGridRow(cells: [
            for (var cell in dataGridRows[i].getCells())
              if (cell.columnName == 'Row Value')
                DataGridCell<double>(
                    columnName: cell.columnName, value: rangeOutput)
              else
                cell
          ]);
          for (var cell in dataGridRows[i].getCells()) {
            print("3rd row values is ${cell.columnName} ${cell.value}");
          }
        }
      }
      print(
          "<----------------------row $i update end------------------------->");
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

        List<dynamic> formulaRow =
            formulaExcel[rowFormulaIndex] as List<dynamic>;
        // print("formula row is $formulaRow");
        bool isEditable = formulaExcel[rowFormulaIndex]
                [formulaHeaders.indexOf('Editable')] ==
            '1';
        if (dataCell.columnName == 'Row Value' &&
            !isEditable &&
            dataCell.value == "0") {
          return Text("0");
        }

        return Container(
          alignment: Alignment.center,
          child: TextField(
            onSubmitted: (value) {
              int parsedValue = int.tryParse(value) ?? 0;

              int rowIndex = dataGridRows.indexOf(row);
              print("updated row index is $rowIndex");
              dataGridRows[rowFormulaIndex] = DataGridRow(cells: [
                for (var cell in row.getCells())
                  if (cell == dataCell)
                    DataGridCell<int>(
                      columnName: cell.columnName,
                      value: parsedValue,
                    )
                  else
                    cell,
              ]);

              recalculatedataGridValues(rowIndex, parsedValue);

              onEdit(dataGridRows);
            },
            controller: TextEditingController(
              text: dataCell.value.toString(),
            ),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        );
      }).toList(),
    );
  }
}
