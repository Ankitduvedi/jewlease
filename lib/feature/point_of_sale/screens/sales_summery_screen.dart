import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/procumentStyleVariant.dart';
import 'package:jewlease/feature/point_of_sale/screens/point_of_sale_screen.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../../widgets/app_bar_buttons.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../procument/screens/procumentSummeryGridSource.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import 'Widgets/float_trans_summery_card.dart';

class SalesSummaryScreen extends ConsumerStatefulWidget {
  const SalesSummaryScreen({
    super.key,
  });

  @override
  _ProcumentDataGridState createState() => _ProcumentDataGridState();
}

class _ProcumentDataGridState extends ConsumerState<SalesSummaryScreen> {
  @override
  List<String> posColumnns = [
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
  List<DataGridRow> posRows = [];
  Map<String, dynamic> posSummery = {
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
  late ProcumentDataGridSource posDataGridSource;

  void initState() {
    // TODO: implement initState

    posDataGridSource =
        ProcumentDataGridSource(posRows, (DataGridRow) {}, () {}, false);

    super.initState();
  }

  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0; // Approximate width of a character
    const double paddingWidth = 20.0; // Extra padding for the cell
    return (columnName.length * charWidth) + paddingWidth;
  }

  void _addNewRowWithItemGroup(ProcumentStyleVariant variant) {

    setState(() {
      posRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Ref Document', value: ''),
          DataGridCell<String>(
              columnName: 'Variant Name', value:variant.variantName),
          DataGridCell<int>(columnName: 'Line No', value: variant.lineNo),
          DataGridCell<String>(columnName: "Batch", value: variant.batchNo),
          DataGridCell<String>(
              columnName: 'Stock Code', value: variant.stockID),
          DataGridCell<String>(columnName: 'Stock Status', value: ""),
          DataGridCell<String>(columnName: 'Group Item', value:variant.itemGroup),
          DataGridCell<double>(
              columnName: 'Pieces', value: variant.totalPieces.value),
          DataGridCell<double>(
              columnName: 'Weight', value: variant.totalMetalWeight.value),
          DataGridCell<double>(
              columnName: 'Rate', value: 0),
          DataGridCell<double>(
              columnName: 'Amount', value: 0),
          DataGridCell<String>(
              columnName: "Karat Color", value: variant.karatColor),
          DataGridCell<String>(columnName: "Certificate No", value: variant.certificateNo),
          DataGridCell<String>(columnName: "Batch Quality", value: ""),
          DataGridCell<String>(columnName: "Remarks", value: variant.remark),
          DataGridCell<String>(columnName: 'Against Transfer Doc', value: ""),
        ]),
      );
      posDataGridSource.updateDataGridSource();
      setState(() {});
      _posSummery({});
      _updateSummaryRow();
    });
  }

  void _updateSummaryRow() {
    ///first update stored preocument vairent as update from text field
    ///
    ///
    ///
    for (var row in posRows) {
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

    _posSummery({});
  }

  void _posSummery(Map<String, dynamic> updatedVarient) {
    setState(() {});
    try {
      posSummery['Wt'] = 0;
      posSummery['Total Amt'] = 0;
      posSummery['Pieces'] = 0;
      posSummery["Stone Wt"] = 0.0;
      posSummery["Stone Amt"] = updatedVarient["Stone Pieces"] ?? 0.0;
      print("updating procument summery");

      posRows.forEach((element) {
        element.getCells().forEach((cell) {
          if (cell.columnName == 'Weight') {
            posSummery["Wt"] += cell.value.runtimeType == double
                ? cell.value
                : double.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Amount') {
            posSummery["Total Amt"] += cell.value.runtimeType == double
                ? cell.value
                : int.parse(cell.value.toString()) * 1.0;
          } else if (cell.columnName == 'Stone Wt') {
            print("stone wt runtype ${cell.value.runtimeType}");
            posSummery["Stone Wt"] += cell.value.runtimeType == String
                ? int.parse(cell.value)
                : cell.value;
          } else if (cell.columnName == 'Pieces')
            posSummery['Pieces'] = cell.value;
        });
      });
      posSummery["Metal Wt"] = posSummery["Wt"] - posSummery["Stone Wt"];
    } catch (e) {
      print("error in updating summery $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth =
        screenWidth * 0.6; // Set grid width to 50% of screen width

    return Scaffold(
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
                // transferSave();
              },
              () {
                // Reset the provider value to null on refresh
                // ref.watch(formulaProcedureProvider.notifier).state = [
                //   'Style',
                //   null,
                //   null
                // ];
              },
              () {}
            ],
          )
        ],
      ),
      body: Container(
        color: Color(0xffFDFDFD),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Estimation Pos',
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
                        onOptionSelectd: (selectedValue) async{
                          print("selected value $selectedValue");
                        },
                        onSelectdRow: (selectedRow) async{
                          ref
                              .read(procurementVariantProvider.notifier)
                              .addItem(selectedRow);
                          // Map<dynamic, dynamic>? selected = ref
                          //     .read(procurementVariantProvider.notifier)
                          //     .getItemByVariant(selectedRow['Varient']);
                          final basicVariant = ProcumentStyleVariant.fromJson(
                              selectedRow, posRows.length);
                          final completeVariant = await ProcumentStyleVariant
                              .initializeCalculatedFields(
                              basicVariant, basicVariant.vairiantIndex);
                          _addNewRowWithItemGroup(completeVariant);
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
                        "Add  Stock",
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
                  decoration: BoxDecoration(
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
                      source: posDataGridSource,
                      controller: outwardDataGridController,
                      footerFrozenColumnsCount: 1,
                      // Freeze the last column
                      columns: posColumnns.map((columnName) {
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
                                    posColumnns.indexOf(columnName) ==
                                            posColumnns.length - 1
                                        ? 15
                                        : 0),
                                topLeft: Radius.circular(
                                    posColumnns.indexOf(columnName) == 0
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
            ),
            SizedBox(
              height: 100,
            ),
            FlotatingPOS(
              varients: posRows.map((row) {
                Map<String, dynamic> map = {
                  '${row.getCells()[1].columnName}': '${row.getCells()[1].value}'
                };
                print("map is $map");
                return map;
              }).toList(),
            ),
          ],
        ),
      ),
      //
    );
  }
}
