import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/data/model/transaction_model.dart';
import 'package:jewlease/feature/transaction/controller/transaction_controller.dart';
import 'package:jewlease/feature/transfer/screens/widgets/transfer_outward_dialog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/model/barcode_detail_model.dart';
import '../../../data/model/barcode_historyModel.dart';
import '../../../main.dart';
import '../../../widgets/app_bar_buttons.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../barcoding/controllers/barcode_detail_controller.dart';
import '../../barcoding/controllers/barcode_history_controller.dart';
import '../../formula/controller/formula_prtocedure_controller.dart';
import '../../procument/screens/procumentFloatingBar.dart';
import '../../procument/screens/procumentScreen.dart';
import '../../procument/screens/procumentSummeryGridSource.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/destination_controller.dart';
import '../controller/outward_controller.dart';

class TransferOutwardScreen extends ConsumerStatefulWidget {
  const TransferOutwardScreen({super.key});

  @override
  ConsumerState<TransferOutwardScreen> createState() =>
      _TransferOutwardScreenState();
}

class _TransferOutwardScreenState extends ConsumerState<TransferOutwardScreen> {
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
        builder: (context) => const Dialog(
          child: TransferOutwardDialog(),
        ),
      ),
    );
    super.initState();
  }

  void _addNewRowWithItemGroup(Map<dynamic, dynamic> varient) {
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

  void transferSave() async {
    List<Map<String, dynamic>> varientList =
        ref.read(procurementVariantProvider);
    String destinationName =
        ref.read(destinationProvider)["Destination Name"] ?? "MCH";
    String destinationCode =
        ref.read(destinationProvider)["Destination Code"] ?? "MCH";

    TransactionModel transaction = createTransaction(varientList);
    String transactionId = await ref
            .read(TransactionControllerProvider.notifier)
            .sentTransaction(transaction) ??
        "ABC";

    for (var varient in varientList!) {
      String stockCode = varient["Stock ID"];
      String source = varient["Location"] ?? "MCH";
      await ref
          .read(OutwardControllerProvider.notifier)
          .sendOutwardGRN(stockCode, source, destinationName);

      BarcodeDetailModel detailModel =
          createBarCodeDetail(varient, transactionId);
      BarcodeHistoryModel historyModel =
          createBarCodeHistory(varient, transactionId);
      await ref
          .read(BarocdeDetailControllerProvider.notifier)
          .sentBarcodeDetail(detailModel);
      await ref
          .read(BarocdeHistoryControllerProvider.notifier)
          .sentBarcodeHistory(historyModel);
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
                transferSave();
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
                  'Transfer Outward',
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
                        onSelectdRow: (selectedRow) {
                          ref
                              .read(procurementVariantProvider.notifier)
                              .addItem(selectedRow);
                          Map<dynamic, dynamic>? selected = ref
                              .read(procurementVariantProvider.notifier)
                              .getItemByVariant(selectedRow['Varient']);
                          print("selected $selected selectedRow $selectedRow");
                          _addNewRowWithItemGroup(selectedRow);
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
                        "Add Outward Stock",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ),
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

  BarcodeHistoryModel createBarCodeHistory(
      Map<String, dynamic> varient, String transactionID) {
    BarcodeHistoryModel historyModel = BarcodeHistoryModel(
        stockId: varient["Stock ID"],
        attribute: '',
        varient: varient['Varient Name'],
        transactionNumber: transactionID,
        date: DateTime.now().toIso8601String(),
        bom: varient["BOM"],
        operation: varient["Operation"],
        formula: varient["Formula Details"]);
    return historyModel;
  }

  BarcodeDetailModel createBarCodeDetail(
      Map<String, dynamic> varient, String transactionID) {
    BarcodeDetailModel detailModel = BarcodeDetailModel(
        stockId: varient["Stock ID"],
        date: DateTime.now().toIso8601String(),
        transNo: transactionID,
        transType: "Transward outward",
        source: varient["Location"],
        destination: "IET",
        customer: "Anurag",
        vendor: varient["Vendor"],
        sourceDept: "MHCASH",
        destinationDept: "MHCash",
        exchangeRate: 11.33,
        currency: "Rs",
        salesPerson: "Arpit",
        term: "nothing",
        remark: "transward outward ",
        createdBy: "Arpit Verma",
        varient: varient['Varient Name'],
        postingDate: DateTime.now().toIso8601String());
    return detailModel;
  }

  TransactionModel createTransaction(List<Map<String, dynamic>> varients) {
    TransactionModel transaction = TransactionModel(
        transType: "Transfer Outward",
        subType: "TO",
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
        createdBy: DateTime.now().toIso8601String(),
        postingDate: DateTime.now().toIso8601String(),
        varients: varients);
    return transaction;
  }
}
