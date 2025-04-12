import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/feature/procument/controller/procumentBomProcController.dart';
import 'package:jewlease/feature/procument/controller/procumentVarientFormula.dart';
import 'package:jewlease/feature/procument/screens/procumentFloatingBar.dart';
import 'package:jewlease/feature/procument/screens/procumentSummeryGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/model/formula_model.dart';
import '../../../main.dart';
import '../../../widgets/data_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';

class ProcumentSummaryScreen extends ConsumerStatefulWidget {
  const ProcumentSummaryScreen({
    super.key,
  });

  @override
  _ProcumentDataGridState createState() => _ProcumentDataGridState();
}

class _ProcumentDataGridState extends ConsumerState<ProcumentSummaryScreen> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _Procumentrows = [];
  late ProcumentDataGridSource _procumentdataGridSource;
  List<String> procumentColumns = [
    'Ref Document',
    'Stock Code',
    'Line No',
    'Variant Name',
    'Stock Status',
    'Stone Wt',
    'Pieces',
    'Weight',
    'Rate',
    'Amount',
    'Wastage'
  ];
  Map<String, dynamic> procumentSummery = {
    "Pieces": 0.0,
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

  //done
  void _procumentSummery(Map<String, dynamic> updatedVarient) {
    setState(() {});
    try {
      procumentSummery['Wt'] = 0.0;
      procumentSummery['Total Amt'] = 0.0;
      procumentSummery['Pieces'] = 0.0;
      procumentSummery["Stone Wt"] = 0.0;
      procumentSummery["Stone Amt"] = updatedVarient["Stone Pieces"] ?? 0.0;

      _Procumentrows.forEach((element) {
        element.getCells().forEach((cell) {
          if (cell.columnName == 'Weight') {
            procumentSummery["Wt"] += cell.value;
          } else if (cell.columnName == 'Amount') {
            procumentSummery["Total Amt"] += cell.value;
          } else if (cell.columnName == 'Stone Wt') {
            procumentSummery["Stone Wt"] += cell.value;
          } else if (cell.columnName == 'Pieces')
            procumentSummery['Pieces'] = cell.value;
        });
      });
      procumentSummery["Metal Wt"] =
          procumentSummery["Wt"] - procumentSummery["Stone Wt"];
    } catch (e) {
      print("error in updating summery $e");
    }
  }

  void fetchFormulas(
    Map<String, dynamic> variant,
  ) async {
    String variantName = variant['Variant Name'];
    List<FormulaModel> bomFormulas = [];

    List<dynamic> mapBomRows = variant!["BOM Data"];
    List<BomRowModel> listOfBomRows = mapBomRows
        .map((row) => BomRowModel.fromJson(row as Map<String, dynamic>))
        .toList();

    Map<String, dynamic> attributes = {
      "procedureType": "Transaction",
      "transactionType": "STONE ASSORTMENT",
      "documentType": "TRANSFER OUTWARD ( DEPARTMENT )",
      "transactionCategory": "Glue",
      "partyName": "",
      "variantName": "",
      "itemGroup": "Zircon",
      "attributeType": "METAL COLOR",
      "attributeValue": "Rose Gold",
      "operation": "MAKING CHARGES PER GRAM",
      "operationType": "",
      "transType": ""
    };

    final data = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchFormulaByAttribute(attributes, context);
    Utils.printJsonFormat(data);

    for (int i = 0; i < listOfBomRows.length; i++) {
      List<dynamic> rows = data["data"]["excelDetail"];
      List<FomulaRowModel> formulaRows = rows
          .map((formula) =>
              FomulaRowModel.fromJson2(formula as Map<String, dynamic>))
          .toList();
      FormulaModel formulaModel = FormulaModel(
          formulaId: "", formulaRows: formulaRows, isUpdated: false);
      bomFormulas.add(formulaModel);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update("${variantName}_${i + 1})", formulaModel);
      ref
          .read(allVariantFormulasProvider2.notifier)
          .update("formula_${variantName}", formulaModel);
    }
  }

//done
  void _addNewRowWithItemGroup(Map<dynamic, dynamic> variant) {
    // print("varient $varient ${varient["BOM"]["data"][0][3]}");
    // print("varient $varient");
    List<dynamic> mapBomRows = variant!["BOM Data"];
    BomRowModel bomSummeryRow = BomRowModel.fromJson(mapBomRows[0]);
    setState(() {
      _Procumentrows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Ref Document', value: ''),
          DataGridCell<String>(columnName: 'Line No', value: ''),
          DataGridCell<int>(columnName: 'Stock Code', value: 0),
          DataGridCell<String>(
              columnName: 'Variant Name', value: variant['Variant Name']),
          DataGridCell<double>(columnName: 'Stock Status', value: 0.0),
          DataGridCell<String>(
              columnName: 'Stone Wt', value: variant["Stone Min Wt"]),
          DataGridCell<double>(
              columnName: 'Pieces', value: bomSummeryRow.pieces),
          DataGridCell<double>(
              columnName: 'Weight', value: bomSummeryRow.weight),
          DataGridCell<double>(columnName: 'Rate', value: bomSummeryRow.rate),
          DataGridCell<double>(
              columnName: 'Amount', value: bomSummeryRow.amount),
          DataGridCell<String>(columnName: 'Wastage', value: "0"),
        ]),
      );
      _procumentdataGridSource.updateDataGridSource();
    });
  }

  void _initializeRows() {
    print("intilizing start");
    _Procumentrows = [];
    Future.delayed(Duration(seconds: 1), () {
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
    for (var row in _Procumentrows) {
      Map<String, dynamic> updatedVarient = Map.fromIterable(
        row.getCells(),
        key: (cell) => "${cell.columnName}",
        value: (cell) => cell.value,
      );
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
      if (updatedVarient[cell.columnName] != null)
        return DataGridCell(
            columnName: cell.columnName,
            value: updatedVarient[cell.columnName]);
      else
        return cell;
    }).toList());
    setState(() {});
    print("updated varient proc summery is $updatedVarient");

    _procumentSummery(updatedVarient);
    _Procumentrows[varientIndex].getCells().forEach((element) {
      print("updated varient row ${element.columnName} ${element.value}");
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
                  print("intial data $intialData");
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
    double gridWidth = screenWidth * 0.6;
    final varientAction = ref.watch(BomProcProvider);
    if (varientAction['trigger'] == true) {
      print("varientAction $varientAction");
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
                SizedBox(
                  width: 40,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'Add Variant',
                        endUrl: 'ItemMasterAndVariants/Style/Style/Variant',
                        value: 'Variant Name',
                        onOptionSelectd: (selectedValue) async {
                          print("selected value $selectedValue");
                        },
                        onSelectdRow: (selectedRow) async {
                          print("selected Row $selectedRow");
                          ref
                              .read(procurementVariantProvider.notifier)
                              .addItem(selectedRow);
                          fetchFormulas(selectedRow);
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
                        color: Color(0xff003450),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "Add Variants",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: screenHeight * 0.6,
              margin: EdgeInsets.only(top: 10, left: 0),
              // padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.pink),
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.2), // Shadow color with opacity
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 4), // Offset only on the bottom
                  ),
                ],
              ),
              // height: screenHeight * 0.5,
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  decoration: BoxDecoration(
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
                        columns: procumentColumns
                            .map((columnName) => GridColumn(
                                  columnName: columnName,
                                  width: gridWidth /
                                      5, // Adjust column width to fit 4-5 columns
                                  label: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xFF003450),
                                        border: Border(
                                            right:
                                                BorderSide(color: Colors.grey)),
                                        borderRadius: BorderRadius.only(
                                            topRight: procumentColumns
                                                        .indexOf(columnName) ==
                                                    procumentColumns.length - 1
                                                ? Radius.circular(15)
                                                : Radius.circular(0),
                                            topLeft: procumentColumns
                                                        .indexOf(columnName) ==
                                                    0
                                                ? Radius.circular(15)
                                                : Radius.circular(0))),
                                    alignment: Alignment.center,
                                    child: Text(
                                      columnName,
                                      style: TextStyle(color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ))
                            .toList(),
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
      floatingActionButton: _Procumentrows.length == 0
          ? Container()
          : SummaryDetails(
              Summery: procumentSummery,
            ),
    );
  }
}
