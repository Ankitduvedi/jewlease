import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/transfer/controller/outward_controller.dart';
// import 'package:jewlease/feature/transfer/screens/widgets/transfer_Inward_dialog.dart';
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
import '../../procument/screens/procumentSummeryGridSource.dart';
import '../../vendor/controller/procumentVendor_controller.dart';

class TransferInwardScreen extends ConsumerStatefulWidget {
  const TransferInwardScreen({super.key});

  @override
  ConsumerState<TransferInwardScreen> createState() =>
      _TransferInwardScreenState();
}

class _TransferInwardScreenState extends ConsumerState<TransferInwardScreen> {
  List<String> transferInwardColumnns = [
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
  List<String> _tabs = ['Inter Wc Group Transfer Inward', 'Transfer In'];

  final DataGridController InwardDataGridController = DataGridController();
  List<DataGridRow> InwardRows = [];
  Map<String, dynamic> inwardSummery = {
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
  List<Map<dynamic, dynamic>> inwardRowsMap = [];

  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0; // Approximate width of a character
    const double paddingWidth = 20.0; // Extra padding for the cell
    return (columnName.length * charWidth) + paddingWidth;
  }

  @override
  void initState() {
    // TODO: implement initState

    _procumentdataGridSource =
        ProcumentDataGridSource(InwardRows, (DataGridRow) {}, () {}, false);

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
    inwardRowsMap.add(varient);

    setState(() {
      InwardRows.add(
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
      _inwardSummery({});
      _updateSummaryRow();
    });
  }

  void _updateSummaryRow() {
    ///first update stored preocument vairent as update from text field
    ///
    ///
    ///
    for (var row in InwardRows) {
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

    _inwardSummery({});
  }

  void _inwardSummery(Map<String, dynamic> updatedVarient) {
    setState(() {});
    try {
      inwardSummery['Wt'] = 0;
      inwardSummery['Total Amt'] = 0;
      inwardSummery['Pieces'] = 0;
      inwardSummery["Stone Wt"] = 0.0;
      inwardSummery["Stone Amt"] = updatedVarient["Stone Pieces"] ?? 0.0;
      print("updating procument summery");

      InwardRows.forEach((element) {
        element.getCells().forEach((cell) {
          if (cell.columnName == 'Weight') {
            inwardSummery["Wt"] += cell.value.runtimeType == double
                ? cell.value
                : double.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Amount') {
            inwardSummery["Total Amt"] += cell.value.runtimeType == double
                ? cell.value
                : int.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Stone Wt') {
            print("stone wt runtype ${cell.value.runtimeType}");
            inwardSummery["Stone Wt"] += cell.value.runtimeType == String
                ? int.parse(cell.value)
                : cell.value;
          } else if (cell.columnName == 'Pieces')
            inwardSummery['Pieces'] = cell.value;
        });
      });
      inwardSummery["Metal Wt"] =
          inwardSummery["Wt"] - inwardSummery["Stone Wt"];
    } catch (e) {
      print("error in updating summery $e");
    }
  }

  Map<String, dynamic> transformSchema(Map<dynamic, dynamic> schema1) {
    return {
      "style": schema1["Style"],
      "varientName": schema1["Varient Name"],
      "oldVarient": schema1["Old Varient"],
      "customerVarient": schema1["Customer Varient"],
      "baseVarient": schema1["Base Varient"],
      "vendorCode": schema1["Vendor Code"],
      "vendor": schema1["Vendor"],
      "location": schema1["Location"],
      "department": schema1["Department"],
      "remark1": schema1["Remark 1"],
      "vendorVarient": schema1["Vendor Varient"],
      "remark2": schema1["Remark 2"],
      "createdBy": schema1["Created By"],
      "stdBuyingRate": schema1["Std Buying Rate"],
      "stoneMaxWt": schema1["Stone Max Wt"],
      "remark": schema1["Remark"],
      "stoneMinWt": schema1["Stone Min Wt"],
      "karatColor": schema1["Karat Color"],
      "deliveryDays": schema1["Delivery Days"],
      "forWeb": schema1["For Web"],
      "rowStatus": schema1["Row Status"],
      "verifiedStatus": schema1["Verified Status"],
      "length": schema1["Length"],
      "codegenSrNo": schema1["Codegen Sr No"],
      "category": schema1["CATEGORY"],
      "subCategory": schema1["Sub-Category"],
      "styleKarat": schema1["STYLE KARAT"],
      "varient": schema1["Varient"],
      "hsnSacCode": schema1["HSN - SAC CODE"],
      "lineOfBusiness": schema1["LINE OF BUSINESS"],
      "bom": schema1["BOM"],
      "operation": schema1["Operation"],
      "imageDetails": schema1["Image Details"],
      "formulaDetails": schema1["Formula Details"],
      "pieces": schema1["Pieces"],
      "weight": schema1["Weight"],
      "netWeight": schema1["Net Weight"],
      "diaWeight": schema1["Dia Weight"],
      "diaPieces": schema1["Dia Pieces"],
      "locationCode": schema1["Location Code"],
      "itemGroup": schema1["Item Group"],
      "metalColor": schema1["Metal Color"],
      "styleMetalColor": schema1["Style Metal Color"]
    };
  }

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth = screenWidth;
    return Scaffold(
      body: Expanded(
        child: Scaffold(
          // Container(
          //   width: double.infinity,
          //   height: 50,
          //   color: Colors.green,
          // ),
          appBar: AppBar(
            actions: [
              AppBarButtons(
                ontap: [
                  () {
                    // if (selectedIndex == 1)
                    //   showDialog(
                    //       context: context,
                    //       builder: (context) => procumentScreen());
                    // log('new pressed');
                    // if (selectedIndex == 3)
                    //   context.go('/addFormulaProcedureScreen');
                  },
                  () async {
                    print("update inward grn");
                    List<Map<dynamic, dynamic>>? varientList = inwardRowsMap;
                    for (var varient in varientList!) {
                      print("varient $varient");
                      print("tansform schema is ${transformSchema(varient)}");
                      await ref
                          .read(OutwardControllerProvider.notifier)
                          .updateGRN(
                              transformSchema(varient), varient["Stock ID"]);
                      await ref
                          .read(OutwardControllerProvider.notifier)
                          .deleteInward(varient["Stock ID"]);
                      BarcodeDetailModel detailModel = BarcodeDetailModel(
                          stockId: varient["Stock ID"],
                          date: DateTime.now().toIso8601String(),
                          transNo: 12333,
                          transType: "Transward Inward",
                          source: varient["Location"],
                          destination: "REC",
                          customer: "Anurag",
                          vendor: varient["Vendor"],
                          sourceDept: "MHCASH",
                          destinationDept: "MHCash",
                          exchangeRate: 11.33,
                          currency: "Rs",
                          salesPerson: "Arpit",
                          term: "nothing",
                          remark: "transward inward ",
                          createdBy: "Arpit Verma",
                          varient: varient['Varient Name'],
                          postingDate: DateTime.now().toIso8601String());
                      BarcodeHistoryModel historyModel = BarcodeHistoryModel(
                          stockId: varient["Stock ID"],
                          attribute: '',
                          varient: varient['Varient Name'],
                          transactionNumber: 1231,
                          date: DateTime.now().toIso8601String(),
                          bom: varient["BOM"],
                          operation: varient["Operation"],
                          formula: varient["Formula Details"]);
                      await ref
                          .read(BarocdeDetailControllerProvider.notifier)
                          .sentBarcodeDetail(detailModel);
                      await ref
                          .read(BarocdeHistoryControllerProvider.notifier)
                          .sentBarcodeHistory(historyModel);
                    }
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
                      'Transfer Inward',
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
                            title: 'Inward Stock',
                            endUrl: 'Transfer/Department',
                            value: 'Stock ID',
                            onOptionSelectd: (selectedValue) {
                              print("selected value $selectedValue");
                            },
                            onSelectdRow: (selectedRow) async {
                              String stockCode = selectedRow['Stock ID'];
                              Map<String, dynamic> inwardStock = await ref
                                  .read(OutwardControllerProvider.notifier)
                                  .fetchGRN(stockCode);
                              inwardStock["Department"] =
                                  selectedRow["Destination Department"];

                              print("inward stock is $inwardStock");
                              _addNewRowWithItemGroup(inwardStock);
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
                            "Add Inward Stock",
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
                          shadowColor:
                              Colors.transparent, // Removes shadow if any
                        ),
                        child: SfDataGrid(
                          rowHeight: 40,
                          headerRowHeight: 40,
                          source: _procumentdataGridSource,
                          controller: InwardDataGridController,
                          footerFrozenColumnsCount: 1,
                          // Freeze the last column
                          columns: transferInwardColumnns.map((columnName) {
                            return GridColumn(
                              columnName: columnName,
                              width: _calculateColumnWidth(columnName),
                              // Dynamically set column width
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Color(0xFF003450),
                                  border: Border(
                                      right: BorderSide(color: Colors.grey)),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(
                                        transferInwardColumnns
                                                    .indexOf(columnName) ==
                                                transferInwardColumnns.length -
                                                    1
                                            ? 15
                                            : 0),
                                    topLeft: Radius.circular(
                                        transferInwardColumnns
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: InwardRows.length == 0
          ? Container()
          : SummaryDetails(
              Summery: inwardSummery,
            ),
    );
  }
}
