import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/procument/controller/procumentBomProcController.dart';
import 'package:jewlease/feature/procument/screens/procumentFloatingBar.dart';
import 'package:jewlease/feature/procument/screens/procumentSummeryGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../../widgets/data_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../vendor/controller/procumentVendor_controller.dart';

class ProcumentSummaryScreen extends ConsumerStatefulWidget {
  const ProcumentSummaryScreen({
    super.key,
  });

  @override
  ProcumentDataGridState createState() => ProcumentDataGridState();
}

class ProcumentDataGridState extends ConsumerState<ProcumentSummaryScreen> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _Procumentrows = [];
  late ProcumentDataGridSource _procumentdataGridSource;
  Map<String, dynamic> procumentSummery = {
    "Pieces": 0,
    "Wt": 0.0,
    "Metal Wt": 0.0,
    "Metal Amt": 0.0,
    "Stone Wt": 0.0,
    "Stone Amt": 0.0,
    "Labour Amt": 0.0,
    "Wastage": 0.0,
    "Wastage Fine": 0.0,
    "Total Fine": 0.0,
    "Total Amt": 0.0,
  };

  @override
  void initState() {
    super.initState();

    _initializeRows();

    _procumentdataGridSource = ProcumentDataGridSource(
        _Procumentrows, _removeRow, _updateSummaryRow, true);
    setState(() {});
  }

  void _procumentSummery(Map<String, dynamic> updatedVarient) {
    setState(() {});
    try {
      procumentSummery['Wt'] = 0;
      procumentSummery['Total Amt'] = 0;
      procumentSummery['Pieces'] = 0;
      procumentSummery["Stone Wt"] = 0.0;
      procumentSummery["Stone Amt"] = updatedVarient["Stone Pieces"] ?? 0.0;
      log("updating procument summery");

      for (var element in _Procumentrows) {
        element.getCells().forEach((cell) {
          if (cell.columnName == 'Weight') {
            procumentSummery["Wt"] += cell.value.runtimeType == double
                ? cell.value
                : int.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Amount') {
            procumentSummery["Total Amt"] += cell.value.runtimeType == double
                ? cell.value
                : int.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Stone Wt') {
            log("stone wt runtype ${cell.value.runtimeType}");
            procumentSummery["Stone Wt"] += cell.value.runtimeType == String
                ? int.parse(cell.value)
                : cell.value;
          } else if (cell.columnName == 'Pieces') {
            procumentSummery['Pieces'] = cell.value;
          }
        });
      }
      procumentSummery["Metal Wt"] =
          procumentSummery["Wt"] - procumentSummery["Stone Wt"];
    } catch (e) {
      log("error in updating summery $e");
    }
  }

  void _addNewRowWithItemGroup(Map<dynamic, dynamic> varient) {
    // log("varient $varient ${varient["BOM"]["data"][0][3]}");
    log("varient $varient");
    setState(() {
      _Procumentrows.add(
        DataGridRow(cells: [
          const DataGridCell<String>(columnName: 'Ref Document', value: ''),
          const DataGridCell<String>(columnName: 'Line No', value: ''),
          const DataGridCell<int>(columnName: 'Stock Code', value: 0),
          DataGridCell<String>(
              columnName: 'Variant Name', value: varient['Varient Name']),
          const DataGridCell<double>(columnName: 'Stock Status', value: 0.0),
          DataGridCell<String>(
              columnName: 'Stone Wt', value: varient["Stone Min Wt"]),
          DataGridCell<String>(
              columnName: 'Pieces', value: varient['Pieces'] ?? "1"),
          DataGridCell<String>(
              columnName: 'Weight',
              value: varient["BOM"]["data"][0][3].toString()),
          DataGridCell<String>(
              columnName: 'Rate', value: varient["Std Buying Rate"]),
          DataGridCell<String>(
              columnName: 'Amount',
              value: (int.parse(varient["BOM"]["data"][0][3].toString()) *
                      int.parse(varient["Std Buying Rate"] ?? 0))
                  .toString()),
          const DataGridCell<String>(columnName: 'Wastage', value: "0"),
        ]),
      );
      _procumentdataGridSource.updateDataGridSource();
      setState(() {});
      _procumentSummery({});
      // _updateSummaryRow();
    });
  }

  void _initializeRows() {
    log("intilizing start");
    _Procumentrows = [];
    Future.delayed(const Duration(seconds: 1), () {
      ref.read(procurementVariantProvider.notifier).resetAllVariants();
    });
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _Procumentrows.remove(row);
      _procumentdataGridSource.updateDataGridSource();
      _updateSummaryRow();
    });
  }

  void _updateSummaryRow() {
    ///first update stored preocument vairent as update from text field
    ///
    ///
    ///
    for (var row in _Procumentrows) {
      Map<String, dynamic> updatedVarient = {
        for (var cell in row.getCells()) cell.columnName: cell.value
      };
      String varientName = row.getCells()[3].value;
      ref
          .read(procurementVariantProvider.notifier)
          .updateVariant(varientName, updatedVarient);
    }

    _procumentSummery({});
  }

  void updateVarientRow(Map<String, dynamic> updatedVarient) {
    int varientIndex = updatedVarient["varientIndex"];
    _Procumentrows[varientIndex] = DataGridRow(
        cells: _Procumentrows[varientIndex].getCells().map((cell) {
      if (updatedVarient[cell.columnName] != null) {
        return DataGridCell(
            columnName: cell.columnName,
            value: updatedVarient[cell.columnName]);
      } else {
        return cell;
      }
    }).toList());
    setState(() {});
    log("updated varient proc summery is $updatedVarient");

    _procumentSummery(updatedVarient);
    _Procumentrows[varientIndex].getCells().forEach((element) {
      log("updated varient row ${element.columnName} ${element.value}");
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(BomProcProvider.notifier).updateAction(updatedVarient, false);
    });
  }

  bool showDialogBom = false;

  void showProcumentdialog(String endUrl, String value) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ItemDataScreen(
                title: '',
                endUrl: endUrl,
                canGo: true,
                onDoubleClick: (Map<String, dynamic> intialData) {
                  log("intial data $intialData");
                  // _addNewRowBom(intialData["OPERATION_NAME"] ?? "", value);
                  // Navigator.pop(context);
                  // _updateBomSummaryRow();
                },
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth =
        screenWidth * 0.6; // Set grid width to 50% of screen width
    log("widht $screenWidth ${screenWidth * 0.9}");
    final varientAction = ref.watch(BomProcProvider);
    if (varientAction['trigger'] == true) {
      log("varientAction $varientAction");
      updateVarientRow(varientAction["data"]);
    }

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Goods Reciept Note',
                  style: TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  width: 40,
                ),
                InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => ItemTypeDialogScreen(
                          title: 'Add Varient',
                          endUrl: 'ItemMasterAndVariants/Style/Style/Variant',
                          value: 'Varient Name',
                          onOptionSelectd: (selectedValue) {
                            log("selected value $selectedValue");
                          },
                          onSelectdRow: (selectedRow) {
                            ref
                                .read(procurementVariantProvider.notifier)
                                .addItem(selectedRow);
                            Map<dynamic, dynamic>? selected = ref
                                .read(procurementVariantProvider.notifier)
                                .getItemByVariant(selectedRow['Varient']);
                            log("selected $selected selectedRow $selectedRow");
                            _addNewRowWithItemGroup(selectedRow);
                            setState(() {});
                          },
                        ),
                      );
                    },
                    child: Container(
                        width: screenWidth * 0.1,
                        height: 35,
                        decoration: BoxDecoration(
                            color: const Color(0xff003450),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Center(
                            child: Text(
                          "Add Varients",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )))),
              ],
            ),
            Container(
              height: screenHeight * 0.6,

              margin: const EdgeInsets.only(top: 10, left: 0),
              // padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.pink),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 4), // Offset only on the bottom
                  ),
                ],
              ),
              // height: screenHeight * 0.5,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  width: screenWidth,
                  // Set the grid width to 50% of the screen width
                  child: Theme(
                      data: ThemeData(
                        cardColor:
                            Colors.transparent, // Background color for DataGrid
                        shadowColor:
                            Colors.transparent, // Removes shadow if any
                      ),
                      child: SfDataGrid(
                        rowHeight: 40,
                        headerRowHeight: 40,
                        source: _procumentdataGridSource,
                        controller: _dataGridController,
                        footerFrozenColumnsCount: 1,
                        // Freeze the last column
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'Ref Document',
                            width: gridWidth /
                                5, // Adjust column width to fit 4-5 columns
                            label: Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xFF003450),
                                  border: Border(
                                      right: BorderSide(color: Colors.grey)),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0),
                                      topLeft: Radius.circular(15))),
                              alignment: Alignment.center,
                              child: const Text(
                                'Ref Document',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Stock Code',
                            width: gridWidth / 5,
                            label: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFF003450),
                                border: Border(
                                    right: BorderSide(color: Colors.grey)),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                'Stock Code',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Line No',
                            width: gridWidth / 5,
                            label: Container(
                              color: const Color(0xFF003450),
                              alignment: Alignment.center,
                              child: const Text(
                                'Line No',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Variant Name',
                            width: gridWidth / 5,
                            label: Container(
                              color: const Color(0xFF003450),
                              alignment: Alignment.center,
                              child: const Text(
                                'Variant Name',
                                style: TextStyle(color: Colors.green),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Stock Status',
                            width: gridWidth / 5,
                            label: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: const Color(0xFF003450),
                                alignment: Alignment.center,
                                child: const Text(
                                  'Stock Status',
                                  style: TextStyle(color: Colors.green),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Stone Wt',
                            width: gridWidth / 5,
                            label: Container(
                              color: const Color(0xFF003450),
                              alignment: Alignment.center,
                              child: const Text(
                                'Stone Wt',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Pieces',
                            width: gridWidth / 5,
                            label: Container(
                              color: const Color(0xFF003450),
                              alignment: Alignment.center,
                              child: const Text(
                                'Pieces',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Weight',
                            width: gridWidth / 5,
                            label: Container(
                              color: const Color(0xFF003450),
                              alignment: Alignment.center,
                              child: const Text(
                                'Weight',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Rate',
                            width: gridWidth / 5,
                            label: Container(
                              color: const Color(0xFF003450),
                              alignment: Alignment.center,
                              child: const Text(
                                'Rate',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Amount',
                            width: gridWidth /
                                5, // Adjust column width to fit 4-5 columns
                            label: Container(
                              color: const Color(0xFF003450),
                              alignment: Alignment.center,
                              child: const Text(
                                'Amount',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'Wastage',
                            width: gridWidth /
                                5, // Adjust column width to fit 4-5 columns
                            label: Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xFF003450),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15))),
                              alignment: Alignment.center,
                              child: const Text(
                                'Wastage',
                                style: TextStyle(color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.none,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _Procumentrows.isEmpty
          ? Container()
          : SummaryDetails(
              Summery: procumentSummery,
            ),
    );
  }
}
