import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/feature/procument/controller/procumentBomProcController.dart';
import 'package:jewlease/feature/procument/screens/procumentFloatingBar.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/routes/go_router.dart';
import '../../../data/model/barcode_detail_model.dart';
import '../../../data/model/barcode_historyModel.dart';
import '../../../data/model/transaction_model.dart';
import '../../../main.dart';
import '../../../widgets/app_bar_buttons.dart';
import '../../../widgets/data_widget.dart';
import '../../barcoding/controllers/barcode_detail_controller.dart';
import '../../barcoding/controllers/barcode_history_controller.dart';
import '../../home/right_side_drawer/controller/drawer_controller.dart';
import '../../procument/controller/procumentVendorDailog.dart';
import '../../procument/controller/procumentcController.dart';
import '../../procument/screens/procumentVendorDialog.dart';
import '../../transaction/controller/transaction_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';

class RmProcumentSummaryScreen extends ConsumerStatefulWidget {
  const RmProcumentSummaryScreen({
    super.key,
  });

  @override
  _ProcumentDataGridState createState() => _ProcumentDataGridState();
}

class _ProcumentDataGridState extends ConsumerState<RmProcumentSummaryScreen> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _RmProcumentRows = [];
  late RmProcumentDataGridSource _RmProcumentDataGridSource;
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
    Future.delayed(Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        builder: (context) => Dialog(child: procumentVendorDialog()),
      );
      ref.read(procurementVariantProvider.notifier).resetAllVariants();
    });
    _initializeRows();
    _RmProcumentDataGridSource = RmProcumentDataGridSource(
        _RmProcumentRows, _removeRow, _updateSummaryRow, true);
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
      print("updating procument summery");

      _RmProcumentRows.forEach((element) {
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
            print("stone wt runtype ${cell.value.runtimeType}");
            procumentSummery["Stone Wt"] += cell.value.runtimeType == String
                ? int.parse(cell.value)
                : cell.value;
          } else if (cell.columnName == 'Pieces')
            procumentSummery['Pieces'] = cell.value;
        });
      });
      procumentSummery["Metal Wt"] = procumentSummery["Wt"];
      procumentSummery["Wt"] =
          procumentSummery["Metal Wt"] + procumentSummery["Stone Wt"];
    } catch (e) {
      print("error in updating summery $e");
    }
  }

  void _addNewRowWithItemGroup(Map<dynamic, dynamic> varient) {
    // print("varient $varient ${varient["BOM"]["data"][0][3]}");
    print("varient $varient");
    setState(() {
      _RmProcumentRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Ref Document', value: ''),
          DataGridCell<String>(columnName: 'Line No', value: ''),
          DataGridCell<int>(columnName: 'Stock Code', value: 0),
          DataGridCell<String>(
              columnName: 'Variant Name', value: varient['Varient Name']),
          DataGridCell<double>(columnName: 'Stock Status', value: 0.0),
          DataGridCell<String>(
              columnName: 'Stone Wt', value: varient["Stone Min Wt"] ?? "0"),
          DataGridCell<String>(
              columnName: 'Pieces', value: varient['Pieces'] ?? "1"),
          DataGridCell<String>(columnName: 'Weight', value: "0"),
          DataGridCell<String>(
              columnName: 'Rate', value: varient["Std Buying Rate"] ?? "0"),
          DataGridCell<String>(columnName: 'Amount', value: "0"),
          DataGridCell<String>(columnName: 'Wastage', value: "0"),
        ]),
      );
      _RmProcumentDataGridSource.updateDataGridSource();
      setState(() {});
      _procumentSummery({});
      // _updateSummaryRow();
    });
  }

  void _initializeRows() {
    print("intilizing start");
    _RmProcumentRows = [];
  }

  void _removeRow(DataGridRow row) {
    setState(() {
      _RmProcumentRows.remove(row);
      _RmProcumentDataGridSource.updateDataGridSource();
      _updateSummaryRow();
    });
  }

  void _updateSummaryRow() {
    ///first update stored preocument vairent as update from text field
    ///
    ///
    ///
    for (var row in _RmProcumentRows) {
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
    _RmProcumentRows[varientIndex] = DataGridRow(
        cells: _RmProcumentRows[varientIndex].getCells().map((cell) {
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
    _RmProcumentRows[varientIndex].getCells().forEach((element) {
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
                  intialData["Varient Name"] = intialData["Stone Variant Name"];
                  if (intialData["Varient Name"] == null) {
                    intialData["Varient Name"] =
                        intialData["Metal Variant Name"];
                  }
                  ref
                      .read(procurementVariantProvider.notifier)
                      .addItem(intialData);
                  _addNewRowWithItemGroup(intialData);
                  Navigator.pop(context);
                  // _addNewRowBom(intialData["OPERATION_NAME"] ?? "", value);
                  // Navigator.pop(context);
                  // _updateBomSummaryRow();
                },
              ),
            ));
  }

  Map<String, dynamic> convertToSchema(Map<String, dynamic> input) {
    return {
      "style": input["Style"],
      "varientName": input["Varient Name"],
      "oldVarient": input["Varient Name"],
      "customerVarient": input["Varient Name"],
      "baseVarient": input["Varient Name"],
      "vendor": input["Vendor"],
      "remark1": input["Remark 1"],
      "vendorVarient": input["Varient Name"],
      "remark2": input["Remark 2"],
      "createdBy": input["Created By"],
      "stdBuyingRate": input["Std Buying Rate"],
      "stoneMaxWt": input["Stone Max Wt"],
      "remark": input["Remark"],
      "stoneMinWt": input["Stone Min Wt"],
      "karatColor": input["Karat Color"],
      "deliveryDays": input["Delivery Days"],
      "forWeb": input["For Web"],
      "rowStatus": input["Row Status"],
      "verifiedStatus": input["Verified Status"],
      "length": input["Length"],
      "codegenSrNo": input["Codegen Sr No"],
      "category": input["CATEGORY"],
      "subCategory": input["Sub-Category"],
      "styleKarat": input["STYLE KARAT"],
      "varient": input["Varient"],
      "hsnSacCode": input["HSN - SAC CODE"],
      "lineOfBusiness": input["LINE OF BUSINESS"],
      "imageDetails": input["Image Details"],
      "pieces": (input["Varient Name"]).contains("DIAMOND")
          ? 0
          : input["Pieces"] ?? 0,
      "weight": (input["Weight"] ?? 0),
      "netWeight": input["Weight"] ?? 0,
      "diaWeight": input["Stone Wt"] ?? 0,
      "diaPieces":
          (input["Varient Name"]).contains("DIAMOND") ? input["Pieces"] : 0,
      "loactionCode": input["Location Code"],
      "itemGroup": "Gold",
      "metalColor": "Yellow",
      "styleMetalColor": "Shiny Gold",
      "inwardDoc": "INV-2024001",
      "lastTrans": DateTime.now().toIso8601String(),
      "bom": {},
      "operation": {},
      "formulaDetails": {},
      "isRawMaterial": true,
      "variantType": input["Variant Type"],
    };
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth =
        screenWidth * 0.6; // Set grid width to 50% of screen width
    print("widht ${screenWidth} ${screenWidth * 0.9}");
    final varientAction = ref.watch(BomProcProvider);
    if (varientAction['trigger'] == true) {
      print("varientAction $varientAction");
      updateVarientRow(varientAction["data"]);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          AppBarButtons(
            ontap: [
              () {},
              () async {
                try {
                  List<Map<String, dynamic>>? varientList =
                      ref.read(procurementVariantProvider);
                  print("varientList = $varientList ");

                  //
                  List<Map<String, dynamic>> reqstBodeis = [];
                  //
                  // return;
                  for (int i = 0; i < varientList!.length; i++) {
                    print("varientList is ${varientList[i]}");
                    Map<String, dynamic> reuestBody =
                        convertToSchema(varientList[i]);
                    reuestBody["vendor"] =
                        ref.read(pocVendorProvider)["Vendor Name"];

                    reuestBody["vendorCode"] =
                        ref.read(pocVendorProvider)["Vendor Code"];
                    reuestBody["location"] =
                        ref.watch(selectedDepartmentProvider).locationName;
                    reuestBody["department"] =
                        ref.watch(selectedDepartmentProvider).departmentName;
                    reuestBody["itemGroup"] = reuestBody["style"];
                    reuestBody["metalColor"] = reuestBody["Karat Color"];
                    reuestBody["styleMetalColor"] = reuestBody["Karat Color"];

                    print("req body is $reuestBody");
                    print('--' * 55);

                    reqstBodeis.add(reuestBody);
                  }
                  // return;

                  TransactionModel transaction = TransactionModel(
                      transType: "Opening Stock",
                      subType: "OPS",
                      transCategory: "GENERAL",
                      docNo: "bsjbcs",
                      transDate: DateTime.now().toIso8601String(),
                      source: "WareHouse",
                      destination: "MH_CASH",
                      customer: "ankit",
                      sourceDept: "Warehouse",
                      destinationDept: "MH_CASH",
                      exchangeRate: "0.0",
                      currency: "RS",
                      salesPerson: "Arun",
                      term: "term",
                      remark: "Creating GRN",
                      createdBy: "Arpit",
                      postingDate: DateTime.now().toIso8601String(),
                      varients: reqstBodeis);
                  String? transactionID = await ref
                      .read(TransactionControllerProvider.notifier)
                      .sentTransaction(transaction);
                  print("transactionID is $transactionID");
                  //
                  for (var reqstBody in reqstBodeis) {
                    print("reqst body $reqstBody");
                    print("-------------------------------------");
                    reqstBody["inwardDoc"] = transactionID;
                    String stockId = await ref
                        .read(procurementControllerProvider.notifier)
                        .sendGRN(reqstBody);
                    BarcodeHistoryModel history =
                        createHistory(reqstBody, stockId, transactionID!);
                    BarcodeDetailModel detail =
                        createDetail(reqstBody, stockId, transactionID!);
                    await ref
                        .read(BarocdeDetailControllerProvider.notifier)
                        .sentBarcodeDetail(detail);
                    await ref
                        .read(BarocdeHistoryControllerProvider.notifier)
                        .sentBarcodeHistory(history);
                  }
                  //
                  ref
                      .read(procurementVariantProvider.notifier)
                      .resetAllVariants();
                  Utils.snackBar("Raw Materail Added", context);
                  goRouter.go("/");
                } catch (e) {
                  Utils.snackBar(e.toString(), context);
                }
                // Navigator.pop(context);\\
              },
              () {},
              () {}
            ],
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 60),
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
                PopupMenuButton<String>(
                    onSelected: (String value) {
                      // When an item is selected, add a new row with the item group

                      if (value.contains('Gold')) {
                        showProcumentdialog(
                            "ItemMasterAndVariants/Metal/Gold/Variant/", value);
                      } else if (value.contains('Silver'))
                        showProcumentdialog(
                            "ItemMasterAndVariants/Metal/Silver/Variant/",
                            value);
                      else if (value.contains('Diamond'))
                        showProcumentdialog(
                            "ItemMasterAndVariants/Stone/Diamond/Variant/",
                            value);
                      else if (value.contains('Bronze'))
                        showProcumentdialog(
                            "ItemMasterAndVariants/Metal/Bronze/Variant/",
                            value);
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Metal - Gold',
                            child: ExpansionTile(
                              title: Text('Metal'),
                              children: <Widget>[
                                ListTile(
                                  title: Text('Gold'),
                                  onTap: () {
                                    Navigator.pop(context, 'Metal - Gold');
                                  },
                                ),
                                ListTile(
                                  title: Text('Silver'),
                                  onTap: () {
                                    Navigator.pop(context, 'Metal - Silver');
                                  },
                                ),
                                ListTile(
                                  title: Text('Bronze'),
                                  onTap: () {
                                    Navigator.pop(context, 'Metal - Bronze');
                                  },
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Stone - Diamond',
                            child: ExpansionTile(
                              title: Text('Stone'),
                              children: <Widget>[
                                ListTile(
                                  title: Text('Diamond'),
                                  onTap: () {
                                    Navigator.pop(context, 'Stone - Diamond');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                    child: Container(
                      // width: screenWidth * 0.1,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 35,
                      decoration: BoxDecoration(
                          color: Color(0xff003450),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(
                        child: Text(
                          "Add  Raw Material",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    )),
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
                        source: _RmProcumentDataGridSource,
                        controller: _dataGridController,
                        footerFrozenColumnsCount: 1,
                        // Freeze the last column
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'Ref Document',
                            width: gridWidth /
                                5, // Adjust column width to fit 4-5 columns
                            label: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xFF003450),
                                  border: Border(
                                      right: BorderSide(color: Colors.grey)),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(0),
                                      topLeft: Radius.circular(15))),
                              alignment: Alignment.center,
                              child: Text(
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
                              decoration: BoxDecoration(
                                color: Color(0xFF003450),
                                border: Border(
                                    right: BorderSide(color: Colors.grey)),
                              ),
                              alignment: Alignment.center,
                              child: Text(
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
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
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
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
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
                                color: Color(0xFF003450),
                                alignment: Alignment.center,
                                child: Text(
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
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
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
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
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
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
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
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
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
                              color: Color(0xFF003450),
                              alignment: Alignment.center,
                              child: Text(
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
                              decoration: BoxDecoration(
                                  color: Color(0xFF003450),
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15))),
                              alignment: Alignment.center,
                              child: Text(
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
      floatingActionButton: _RmProcumentRows.length == 0
          ? Container()
          : SummaryDetails(
              Summery: procumentSummery,
            ),
    );
  }

  BarcodeDetailModel createDetail(
      Map<String, dynamic> reqstBody, String stockId, String transactionID) {
    BarcodeDetailModel detail = BarcodeDetailModel(
      stockId: stockId,
      date: DateTime.now().toIso8601String(),
      transNo: transactionID!,
      transType: "GRN",
      source: "MHCASH",
      destination: "MHCASH",
      customer: "Ashish",
      vendor: "A",
      sourceDept: "MHCASH",
      destinationDept: "MHCASH",
      exchangeRate: 0.0,
      currency: "inr",
      salesPerson: "arun",
      term: "terms",
      remark: "grn",
      createdBy: DateTime.now().toIso8601String(),
      varient: reqstBody["varientName"],
      postingDate: DateTime.now().toIso8601String(),
    );
    return detail;
  }

  BarcodeHistoryModel createHistory(
      Map<String, dynamic> reqstBody, String stockId, String transactionID) {
    BarcodeHistoryModel history = BarcodeHistoryModel(
        stockId: stockId,
        attribute: "",
        varient: reqstBody["varientName"],
        transactionNumber: transactionID ?? "",
        date: DateTime.now().toIso8601String(),
        bom: {},
        operation: {},
        formula: {});
    return history;
  }
}

class RmProcumentDataGridSource extends DataGridSource {
  RmProcumentDataGridSource(
    this.dataGridRows,
    this.onDelete,
    this.onEdit,
    this.canEdit,
  ) : _editingRows = dataGridRows;

  final List<DataGridRow> dataGridRows;
  final List<DataGridRow> _editingRows;
  final Function(DataGridRow) onDelete;
  final Function() onEdit;
  final bool canEdit;

  @override
  List<DataGridRow> get rows => dataGridRows;

  // Method to recalculate all 'Wt' values
  void recalculateWt(int updateRowIndex, bool isMetalRow) {
    var pieces = dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Pieces')
        .value;
    if (pieces.runtimeType != int) pieces = int.parse(pieces);
    var weight = dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Weight')
        .value;
    if (weight.runtimeType != int) weight = int.parse(weight);
    var rate = dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Rate')
        .value;
    if (rate.runtimeType != int) rate = int.parse(rate);
    var stoneWt = dataGridRows[updateRowIndex]
        .getCells()
        .firstWhere((cell) => cell.columnName == 'Stone Wt')
        .value;
    if (stoneWt.runtimeType != int) stoneWt = int.parse(stoneWt);
    print(
        'final amount is ${rate.runtimeType} ${weight.runtimeType} ${pieces.runtimeType}');
    dataGridRows[updateRowIndex] = DataGridRow(
        cells: dataGridRows[updateRowIndex].getCells().map((cell) {
      if (cell.columnName == 'Amount')
        return DataGridCell(
            columnName: 'Amount',
            value: rate * pieces * (isMetalRow ? weight : stoneWt));
      else
        return cell;
    }).toList());
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
        if (dataCell.columnName == 'Actions') {
          return IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(row),
          );
        }

        bool isMetalRow = row.getCells().any((cell) =>
            cell.columnName == 'Variant Name' && cell.value.contains('GL'));
        bool isGoldRow = row
            .getCells()
            .any((cell) => cell.columnName == 'Item Group' && cell.value);
        bool isPcsColumn = dataCell.columnName == 'Pieces';
        bool isStonWtCol = dataCell.columnName == 'Stone Wt';
        bool isWtCol = dataCell.columnName == 'Weight';

        return Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: TextField(
                onSubmitted: (value) {
                  int parsedValue = int.tryParse(value) ?? 0;
                  int rowIndex = dataGridRows.indexOf(row);

                  // Update the _rows list directly
                  dataGridRows[rowIndex] = DataGridRow(cells: [
                    for (var cell in row.getCells())
                      if (cell == dataCell)
                        DataGridCell<int>(
                          columnName: cell.columnName,
                          value: parsedValue,
                        )
                      else
                        cell,
                  ]);

                  recalculateWt(rowIndex, isMetalRow);
                  onEdit();
                },
                controller: TextEditingController(
                  text: dataCell.value.toString(),
                ),
                style: TextStyle(
                    decoration: dataCell.columnName == 'Variant Name'
                        ? TextDecoration.underline
                        : TextDecoration.none,
                    decorationColor: Colors.blue.shade900,
                    color: dataCell.columnName == 'Variant Name'
                        ? Colors.blue.shade900
                        : Colors.black),
                keyboardType: TextInputType.number,
                enabled: canEdit
                    ? isEditable(isMetalRow, isPcsColumn, isStonWtCol, isWtCol)
                    : false,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  bool isEditable(
      bool isMetalRow, bool isPcsColumn, bool isStonWtCol, isWtCol) {
    if (isMetalRow) {
      if (isStonWtCol) return false;
      if (isPcsColumn) return false;
      return true;
    } else {
      if (isWtCol) return false;
      return true;
    }
  }
}
