import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../main.dart';
import '../formula/controller/formula_prtocedure_controller.dart';

class FormulaDataGrid extends ConsumerStatefulWidget {
  const FormulaDataGrid({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return FormulaDataGridState();
  }
}

class FormulaDataGridState extends ConsumerState<FormulaDataGrid> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _rows = [];
  late formulaGridSource _dataGridSource;
  List<String> formulas = [];
  List<dynamic> formulaExcel = [];
  Map<dynamic, dynamic> rangeExcelData = {};

  @override
  void initState() {
    super.initState();
    _dataGridSource = formulaGridSource(
        _rows, _removeRow, _updateSummaryRow, formulaExcel, [], rangeExcelData);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _initializeRows();

      // executes after build
    });
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _rows.remove(row);
      _dataGridSource.updateDataGridSource();
      _updateSummaryRow(_rows);
    });
  }

  void _updateSummaryRow(List<DataGridRow> newRows) {
    print("updating summary row");
    setState(() {
      _rows = newRows;
    });
  }

  void _initializeRows() async {
    List<List<dynamic>> excelData = [];
    Map<String, dynamic> data = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchFormulaExcel('a', context);

    rangeExcelData = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchRangeMasterExcel('a', context);
    print("range master excel is $rangeExcelData");

    // List<dynamic> headers = data["Excel Detail"]["headers"];
    // excelData.add(headers);
    formulaExcel = data["Excel Detail"]["data"];
    List<dynamic> formulaHeaders = data["Excel Detail"]["headers"];
    for (int i = 0; i < formulaExcel.length; i++) {
      excelData.add(formulaExcel[i]);
    }
    print("excel data is $excelData");
    List<dynamic> excelHeader = data["Excel Detail"]["headers"];
    for (int i = 0; i < formulaExcel.length; i++) {
      formulas.add(excelData[i][excelHeader.indexOf("Formula")]);
      _rows.add(DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Row No',
            value: excelData[i][excelHeader.indexOf("Row")]),
        DataGridCell<String>(
            columnName: 'Description ',
            value: excelData[i][excelHeader.indexOf("Description")]),
        DataGridCell<String>(
          columnName: 'Row Type',
          value: excelData[i][excelHeader.indexOf("Row Type")],
        ),
        DataGridCell<String>(
            columnName: 'Row Value', value: (i == 1 ? "0.9175" : "0")),
        DataGridCell<double>(columnName: 'Range', value: 0),
      ]));
    }
    _dataGridSource = formulaGridSource(_rows, _removeRow, _updateSummaryRow,
        formulaExcel, formulaHeaders, rangeExcelData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    return Container(
      width: screenWidth * 0.45,
      height: screenHeight * 0.4,
      margin: EdgeInsets.only(top: 20, left: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      // height: screenHeight * 0.5,
      // width: screenWidth * 0.,
      child: Column(
        children: [
          // Header Row

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Metal Exchange',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      10), // Adjust this for desired roundness
                  child: Container(
                      width: screenWidth * 0.42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.grey)),
                      ),
                      child: SfDataGrid(
                        rowHeight: 40,
                        headerRowHeight: 40,
                        source: _dataGridSource,
                        controller: _dataGridController,
                        footerFrozenColumnsCount: 1,
                        // Freeze the last column
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'Row No',
                            width: gridWidth /
                                5, // Adjust column width to fit 4-5 columns
                            label: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF003450),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10))),
                              alignment: Alignment.center,
                              child: Text(
                                'Row No',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Description',
                            width: gridWidth / 5,
                            label: Container(
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
                                'Description',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Row Type',
                            width: gridWidth / 5,
                            label: Container(
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
                                'Row Type',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Row Value',
                            width: gridWidth / 5,
                            label: Container(
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
                                'Row Value',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Range',
                            width: gridWidth / 5,
                            label: Container(
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
                                'Range',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                      ))),
            ),
          ),
        ],
      ),
    );
  }
}

class formulaGridSource extends DataGridSource {
  formulaGridSource(this.dataGridRows, this.onDelete, this.onEdit,
      this.formulaExcel, this.formulaHeaders, this.rangeExcel)
      : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function(List<DataGridRow>) onEdit;
  final List<dynamic> formulaExcel;
  final List<dynamic> formulaHeaders;
  final Map<dynamic, dynamic> rangeExcel;

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

  void recalculatedataGridValues(int updatedRowIndex, cellNewValue) {
    print(
        "updated rowIndex $updatedRowIndex updated Cell value is $cellNewValue");
    for (int i = 0; i < dataGridRows.length; i++) {
      print(
          "<----------------------row $i update start------------------------->");
      dataGridRows[i] = DataGridRow(cells: [
        for (var cell in dataGridRows[i].getCells())
          if (cell.columnName == 'Row Value')
            DataGridCell<double>(
                columnName: cell.columnName,
                value: calculateFormulaVaule(
                    i, updatedRowIndex == i ? cellNewValue : cell.value))
          else
            cell
      ]);

      if (i == 3) {
        String? rangeHierarchyName =
            formulaExcel[i][formulaHeaders.indexOf('Range Value') - 1];
        print(
            " ${formulaHeaders.indexOf('Range Value')}rangehierarchyName  $rangeHierarchyName currentIndex $updatedRowIndex $formulaExcel");
        if (rangeHierarchyName != null && rangeHierarchyName != "") {
          double metalWeight = dataGridRows[0]
                  .getCells()
                  .firstWhere((cell) => cell.columnName == 'Row Value')
                  .value *
              1.0;
          double? rangeOutput = findOutput("18", metalWeight);

          dataGridRows[i] = DataGridRow(cells: [
            for (var cell in dataGridRows[updatedRowIndex].getCells())
              if (cell.columnName == 'Range')
                DataGridCell<double>(
                    columnName: cell.columnName, value: rangeOutput)
              else
                cell
          ]);
          for (var cell in dataGridRows[updatedRowIndex].getCells()) {
            print("updated value is ${cell.value} ${cell.columnName}");
          }
          print("range output is $rangeOutput ");
        }

        for (var cell in dataGridRows[i].getCells())
          if (cell.columnName == 'Range')
            print("updated cell value ${cell.value}");
          else
            print("persist value ${cell.value}");
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
