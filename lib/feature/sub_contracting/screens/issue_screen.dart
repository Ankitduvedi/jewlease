import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/model/barcode_detail_model.dart';
import '../../../data/model/barcode_historyModel.dart';
import '../../../data/model/transaction_model.dart';
import '../../../main.dart';
import '../../../widgets/app_bar_buttons.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../barcoding/controllers/barcode_detail_controller.dart';
import '../../barcoding/controllers/barcode_history_controller.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../home/right_side_drawer/controller/drawer_controller.dart';
import '../../procument/controller/procumentVendorDailog.dart';
import '../../procument/controller/procumentcController.dart';
import '../../procument/screens/procumentFloatingBar.dart';
import '../../procument/screens/procumentScreen.dart';
import '../../procument/screens/procumentSummeryGridSource.dart';
import '../../procument/screens/procumentVendorDialog.dart';
import '../../transaction/controller/transaction_controller.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../issue_controller.dart';
import '../widgets/metail_issue_dialog.dart';

class IssueScreen extends ConsumerStatefulWidget {
  const IssueScreen({super.key});

  @override
  ConsumerState<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends ConsumerState<IssueScreen> {
  List<String> transferOutwardColumnns = [
    'Ref Document',
    'Variant Name',
    'Line No',
    'Batch',
    'Stock Code',
    'Stock Status',
    'Group Item',
    'Pieces',
    'Weight',
    'Rate',
    'Amount',
    'Karat Color',
    'Certificate No',
    'Batch Quality',
    'Remarks',
    'Against Transfer Doc'
  ];

  final DataGridController outwardDataGridController = DataGridController();
  List<DataGridRow> outwardRows = [];
  Map<String, dynamic> otwardSummery = {
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
  late ProcumentDataGridSource _procumentdataGridSource;

  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0; // Approximate width of a character
    const double paddingWidth = 20.0; // Extra padding for the cell
    return (columnName.length * charWidth) + paddingWidth;
  }

  @override
  void initState() {
    // TODO: implement initState

    _procumentdataGridSource =
        ProcumentDataGridSource(outwardRows, (DataGridRow) {}, () {}, false);
    Future.delayed(
      Duration(milliseconds: 500),
      () => showDialog(
        context: context,
        builder: (context) => Dialog(child: procumentVendorDialog()),
      ),
    );
    super.initState();
  }

  void addNewRowRawMaterial(Map<String, dynamic> varient, bool isStone) {
    String netWt = double.parse(varient["Net Weight"]) == 0.0
        ? varient["Dia Weight"]
        : varient["Net Weight"];
    print("net wt $netWt");
    setState(() {
      outwardRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Ref Document', value: ''),
          DataGridCell<String>(
              columnName: 'Variant Name', value: varient['Varient Name']),
          DataGridCell<String>(columnName: 'Line No', value: ''),
          DataGridCell(columnName: "Batch", value: ""),
          DataGridCell<String>(
              columnName: 'Stock Code', value: varient['Stock ID']),
          DataGridCell<String>(columnName: 'Stock Status', value: ""),
          DataGridCell(columnName: 'Group Item', value: varient["Item Group"]),
          DataGridCell<String>(
              columnName: 'Pieces',
              value: isStone
                  ? varient['Dia Pieces'].toString()
                  : varient['Pieces'].toString()),
          DataGridCell<String>(columnName: 'Weight', value: netWt),
          DataGridCell<String>(
              columnName: 'Rate', value: varient["Std Buying Rate"]),
          DataGridCell<String>(columnName: 'Amount', value: ""),
          DataGridCell(
              columnName: "Karat Color", value: varient["Karat Color"]),
          DataGridCell(columnName: "Certificate No", value: ""),
          DataGridCell(columnName: "Batch Quality", value: ""),
          DataGridCell(columnName: "Remarks", value: varient["Remark 1"]),
          DataGridCell<String>(columnName: 'Against Transfer Doc', value: "0"),
        ]),
      );
      _procumentdataGridSource.updateDataGridSource();
      setState(() {});
      _otwardSummery({});
      _updateSummaryRow();
    });
  }

  void addNewRowWithItemGroup(Map<String, dynamic> varient) {
    // print("varient $varient ${varient["BOM"]["data"][0][3]}");
    print("varient $varient");
    List<dynamic> bomSummery = [];
    for (var item in varient["BOM"]["data"][0]) {
      print("item $item");
      bomSummery.add(item);
    }

    setState(() {
      outwardRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Ref Document', value: ''),
          DataGridCell<String>(
              columnName: 'Variant Name', value: varient['Varient Name']),
          DataGridCell<String>(columnName: 'Line No', value: ''),
          DataGridCell(columnName: "Batch", value: ""),
          DataGridCell<String>(
              columnName: 'Stock Code', value: varient['Stock ID']),
          DataGridCell<String>(columnName: 'Stock Status', value: ""),
          DataGridCell(columnName: 'Group Item', value: varient["Item Group"]),
          DataGridCell<String>(
              columnName: 'Pieces', value: varient['Pieces'].toString() ?? "1"),
          DataGridCell<String>(
              columnName: 'Weight', value: varient["Net Weight"].toString()),
          DataGridCell<String>(
              columnName: 'Rate', value: varient["Std Buying Rate"]),
          DataGridCell<String>(
              columnName: 'Amount', value: bomSummery[6].toString()),
          DataGridCell(
              columnName: "Karat Color", value: varient["Karat Color"]),
          DataGridCell(columnName: "Certificate No", value: ""),
          DataGridCell(columnName: "Batch Quality", value: ""),
          DataGridCell(columnName: "Remarks", value: varient["Remark 1"]),
          DataGridCell<String>(columnName: 'Against Transfer Doc', value: "0"),
        ]),
      );
      _procumentdataGridSource.updateDataGridSource();
      setState(() {});
      _otwardSummery({});
      _updateSummaryRow();
    });
  }

  void _updateSummaryRow() {
    ///first update stored preocument vairent as update from text field
    ///
    ///
    ///
    for (var row in outwardRows) {
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

    _otwardSummery({});
  }

  void _otwardSummery(Map<String, dynamic> updatedVarient) {
    setState(() {});
    try {
      otwardSummery['Wt'] = 0;
      otwardSummery['Total Amt'] = 0;
      otwardSummery['Pieces'] = 0;
      otwardSummery["Stone Wt"] = 0.0;
      otwardSummery["Stone Amt"] = updatedVarient["Stone Pieces"] ?? 0.0;
      print("updating procument summery");

      outwardRows.forEach((element) {
        element.getCells().forEach((cell) {
          if (cell.columnName == 'Weight') {
            otwardSummery["Wt"] += cell.value.runtimeType == double
                ? cell.value
                : double.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Amount') {
            otwardSummery["Total Amt"] += cell.value.runtimeType == double
                ? cell.value
                : int.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Stone Wt') {
            print("stone wt runtype ${cell.value.runtimeType}");
            otwardSummery["Stone Wt"] += cell.value.runtimeType == String
                ? int.parse(cell.value)
                : cell.value;
          } else if (cell.columnName == 'Pieces')
            otwardSummery['Pieces'] = cell.value;
        });
      });
      otwardSummery["Metal Wt"] =
          otwardSummery["Wt"] - otwardSummery["Stone Wt"];
    } catch (e) {
      print("error in updating summery $e");
    }
  }

  TextEditingController metalIssueController = TextEditingController();

  Map<String, dynamic> convertToSchema(Map<String, dynamic> input) {
    return {
      "stockId": input["Stock ID"],
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
      "pieces": input["Pieces"],
      "weight": (input["Weight"] ?? 0),
      "netWeight": input["Weight"] ?? 0,
      "diaWeight": input["Dia Weight"] ?? 0,
      "diaPieces": input["Dia Pieces"] ?? 0,
      "itemGroup": "Gold",
      "metalColor": "Yellow",
      "styleMetalColor": "Shiny Gold",
      "inwardDoc": "INV-2024001",
      "lastTrans": DateTime.now().toIso8601String(),
      "bom": input["BOM"] ?? {},
      "operation": input["Operation"] ?? {},
      "formulaDetails": input["Formula Details"] ?? {},
      "isRawMaterial": input["isRawMaterial"] ?? 0,
      "vendor": input["Vendor Name"],
      "vendorCode": input["Vendor Code"],
      "location": input["Location"],
      "department": input["Department"],
      "itemGroup": input["style"] ?? "",
      "metalColor": input["Karat Color"],
      "styleMetalColor": input["Karat Color"],
      "locationCode": ""
    };
  }

  Future<String> saveIssueStock() async {
    try {
      List<Map<String, dynamic>> reqstBodeis = [];
      List<Map<String, dynamic>>? varientList =
          ref.read(procurementVariantProvider);
      for (var varient in varientList!) {
        Map<String, dynamic> reqBody = convertToSchema(varient);

        reqBody["vendor"] = ref.read(pocVendorProvider)["Vendor Name"];
        reqBody["issueDate"] = DateTime.now().toIso8601String();
        reqBody["operationName"] = "Alteration";
        reqstBodeis.add(reqBody);
      }

      TransactionModel transaction = createTransaction(reqstBodeis);
      String? transactionID = await ref
          .read(TransactionControllerProvider.notifier)
          .sentTransaction(transaction);
      print("transId $transactionID");

      for (Map<String, dynamic> reqBody in reqstBodeis) {
        String? stockId = reqBody["stockId"];
        print("stockId $stockId $reqBody");

        ref.read(IssueStockControllerProvider.notifier).sentIssueStock(reqBody);
        BarcodeHistoryModel history =
            createHistory(reqBody, stockId!, transactionID!);
        BarcodeDetailModel detail =
            createDetail(reqBody, stockId, transactionID!);
        await ref
            .read(BarocdeDetailControllerProvider.notifier)
            .sentBarcodeDetail(detail);
        await ref
            .read(BarocdeHistoryControllerProvider.notifier)
            .sentBarcodeHistory(history);

        reqBody["length"]=-1;
        await ref
            .read(procurementControllerProvider.notifier)
            .updateGRN(reqBody, stockId);
      }
      return "Successfully issues stocks";
    } catch (e) {
      return "Error: $e";
    }
  }

  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth = screenWidth;
    return Scaffold(
      appBar: AppBar(
        actions: [
          AppBarButtons(
            ontap: [
              () {
                if (selectedIndex == 1)
                  showDialog(
                      context: context,
                      builder: (context) => procumentScreen());
                log('new pressed');
                if (selectedIndex == 3)
                  context.go('/addFormulaProcedureScreen');
              },
              () async {
                String compltionMsg = await saveIssueStock();
                print("completion msh $compltionMsg");
                // Utils.snackBar(compltionMsg, context);
                // goRouter.go("/");
              },
              () {
                // Reset the provider value to null on refresh
                ref.watch(formulaProcedureProvider.notifier).state = [
                  'Style',
                  null,
                  null
                ];
              },
              () {}
            ],
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Batch Issue',
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
                        title: 'Outward Stock',
                        endUrl: 'Procurement/GRN',
                        value: 'Stock ID',
                        onOptionSelectd: (selectedValue) {
                          print("selected value $selectedValue");
                        },
                        queryMap: {"Length": 0},
                        onSelectdRow: (selectedRow) {
                          ref
                              .read(procurementVariantProvider.notifier)
                              .addItem(selectedRow);
                          Map<dynamic, dynamic>? selected = ref
                              .read(procurementVariantProvider.notifier)
                              .getItemByVariant(selectedRow['Varient']);
                          print("selected $selected selectedRow $selectedRow");
                          addNewRowWithItemGroup(selectedRow);
                          setState(() {});
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: screenWidth * 0.15,
                    height: 35,
                    decoration: BoxDecoration(
                        color: Color(0xff003450),
                        borderRadius: BorderRadius.circular(5)),
                    child: Center(
                      child: Text(
                        "Add Issue Stock",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                PopupMenuButton<String>(
                    onSelected: (String value) {
                      // When an item is selected, add a new row with the item group
                      print("selected value is $value");
                      showDialog(
                        context: context,
                        builder: (context1) => ItemTypeDialogScreen(
                          title: 'Outward Stock',
                          endUrl: 'Procurement/GRN',
                          value: 'Stock ID',
                          queryMap: value == "Stone"
                              ? {
                                  "isRawMaterial": 1,
                                  "Varient Name": "New DIAMOND-5"
                                }
                              : {"isRawMaterial": 1, "Varient Name": "new"},
                          onOptionSelectd: (selectedValue) {
                            print("selected value $selectedValue");
                          },
                          onSelectdRow: (selectedRow) {
                            print("dialog");
                            // Future.delayed(Duration(milliseconds: 200), () {
                            // Navigator.of(context).pop(); // Close first dialog
                            if (value.contains("Stone")) {
                              addNewRowRawMaterial(selectedRow, true);
                            } else
                              Future.delayed(Duration(milliseconds: 200), () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                      child: metalIssueDialog(
                                          metalWeightController:
                                              metalIssueController,
                                          row: selectedRow,
                                          addRow: addNewRowRawMaterial)),
                                );
                              });

                            ref
                                .read(procurementVariantProvider.notifier)
                                .addItem(selectedRow);
                          },
                        ),
                      );
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Metal - Gold',
                            child: ExpansionTile(
                              title: Text('Metal'),
                              children: [
                                ListTile(
                                  title: Text('Metal'),
                                  onTap: () {
                                    Navigator.pop(context, 'Metal');
                                  },
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem<String>(
                            value: 'Stone - Diamond',
                            child: ExpansionTile(
                              title: Text('Stone'),
                              children: [
                                ListTile(
                                  title: Text('Stone'),
                                  onTap: () {
                                    Navigator.pop(context, 'Stone');
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
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: screenHeight * 0.6,

                  margin: EdgeInsets.only(top: 10, left: 0),
                  // padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    // color: Colors.green,
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
                  width: screenWidth,
                  child: Theme(
                    data: ThemeData(
                      cardColor: Colors.transparent,
                      // Background color for DataGrid
                      shadowColor: Colors.transparent, // Removes shadow if any
                    ),
                    child: SfDataGrid(
                      rowHeight: 40,
                      headerRowHeight: 40,
                      source: _procumentdataGridSource,
                      controller: outwardDataGridController,
                      footerFrozenColumnsCount: 1,
                      // Freeze the last column
                      columns: transferOutwardColumnns.map((columnName) {
                        return GridColumn(
                          columnName: columnName,
                          width: _calculateColumnWidth(columnName),
                          // Dynamically set column width
                          label: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFF003450),
                              border:
                                  Border(right: BorderSide(color: Colors.grey)),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(
                                    transferOutwardColumnns
                                                .indexOf(columnName) ==
                                            transferOutwardColumnns.length - 1
                                        ? 15
                                        : 0),
                                topLeft: Radius.circular(transferOutwardColumnns
                                            .indexOf(columnName) ==
                                        0
                                    ? 15
                                    : 0),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              columnName,
                              style: TextStyle(color: Colors.white),
                              maxLines: 1,
                              // Ensure text stays in a single line
                              overflow:
                                  TextOverflow.visible, // Prevent clipping
                            ),
                          ),
                        );
                      }).toList(),
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.none,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: outwardRows.length == 0
          ? Container()
          : SummaryDetails(
              Summery: otwardSummery,
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
      destination: "MHCASH",
      customer: "Ashish",
      vendor: "A",
      source: ref.watch(selectedDepartmentProvider).locationName,
      sourceDept: ref.watch(selectedDepartmentProvider).departmentName,
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
        bom: reqstBody["bom"],
        operation: reqstBody["operation"],
        formula: {});
    return history;
  }

  TransactionModel createTransaction(List<Map<String, dynamic>> reqstBodeis) {
    return TransactionModel(
        transType: "Opening Stock",
        subType: "OPS",
        transCategory: "GENERAL",
        docNo: "bsjbcs",
        transDate: DateTime.now().toIso8601String(),
        destination: "MH_CASH",
        customer: "ankit",
        source: ref.watch(selectedDepartmentProvider).locationName,
        sourceDept: ref.watch(selectedDepartmentProvider).departmentName,
        destinationDept: "MH_CASH",
        exchangeRate: "0.0",
        currency: "RS",
        salesPerson: "Arun",
        term: "term",
        remark: "Creating GRN",
        createdBy: DateTime.now().toIso8601String(),
        postingDate: DateTime.now().toIso8601String(),
        varients: reqstBodeis);
  }
}
