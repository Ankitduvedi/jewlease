import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_detail_list_controller.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_history_list_controller.dart';
import 'package:jewlease/feature/barcoding/screens/finanacial_transaction.dart';
import 'package:jewlease/feature/barcoding/screens/status%20Card.dart';
import 'package:jewlease/feature/procument/screens/operationGridSource.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/utils/utils.dart';
import '../../procument/screens/procumenOprGrid.dart';
import '../../procument/screens/procumentBomGrid.dart';
import '../../procument/screens/procumentBomGridSource.dart';
import 'StockDetailsScreen.dart';
import 'invantory_transaction_screeen.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class BarcodingScreen extends ConsumerStatefulWidget {
  const BarcodingScreen({super.key});

  @override
  ConsumerState<BarcodingScreen> createState() => _BarcodingScreenState();
}

class _BarcodingScreenState extends ConsumerState<BarcodingScreen> {
  final List<String> _tabs = [
    'Batch History',
    'Barcode History',
    'Inventory Transaction',
    'Financial Transaction',
    'Discount Approval',
    'Stone List'
  ];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    int selectedIndex = ref.watch(barcodeIndexProvider);
    int tabselectedIndex = ref.watch(tabIndexProvider);
    var historys = ref.watch(barcodeHistoryListProvider);

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.08),
          child: Container(
              margin: EdgeInsets.only(
                top: screenHeight * 0.08,
              ),
              height: screenHeight * 0.05,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                      children: List.generate(
                        _tabs.length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                ref
                                    .read(tabIndexProvider.notifier)
                                    .state = index;
                              });
                            },
                            child: Container(
                              color: index == tabselectedIndex
                                  ? const Color(0xff28713E)
                                  : Colors.white,
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.01),
                              padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.007),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenHeight * 0.005),
                                decoration: BoxDecoration(
                                  color: index == tabselectedIndex
                                      ? const Color(0xff28713E)
                                      : const Color(0xffF0F4F8),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    _tabs[index],
                                    style: TextStyle(
                                        color: index == tabselectedIndex
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )))),
        ),
        body: tabselectedIndex == 0
            ? Container(
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const StockDetailsScreen()),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ref
                                  .watch(barcodeDetailListProvider)
                                  .length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 50,
                                  width: 220,
                                  child: InkWell(
                                    onTap: () {
                                      ref
                                          .read(
                                          barcodeIndexProvider.notifier)
                                          .state = index;
                                    },
                                    child: StatusCard(
                                      date: DateFormat('d-M-yyyy').format(
                                          DateTime.parse(ref
                                              .watch(barcodeDetailListProvider)[
                                          index]
                                              .date)),
                                      documentId: ref
                                          .watch(barcodeDetailListProvider)[
                                      index]
                                          .transNo
                                          .toString(),
                                      note: ref
                                          .watch(barcodeDetailListProvider)[
                                      index]
                                          .transType,
                                      status1: 'Verified',
                                      status2: 'Active',
                                      isSelected: index == selectedIndex,
                                    ),
                                  ),
                                );
                              }),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xff075184),
                                            borderRadius:
                                            BorderRadius.circular(8)),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        child: const Center(
                                          child: Text(
                                            "Item Details",
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(child: Container())
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // if (historys[selectedIndex].bom.isNotEmpty)
                                //   Expanded(
                                //       child: ItemDetails(
                                //           bom: historys[selectedIndex].bom,
                                //           operation: historys[selectedIndex]
                                //               .operation)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ))
            : tabselectedIndex == 2
            ? const InvantoryTransactionScreeen()
            : tabselectedIndex == 3
            ? const FinanacialTransaction()
            : Container());
  }
}

class ItemDetails extends ConsumerStatefulWidget {
  const ItemDetails({super.key, required this.bom, required this.operation});

  final BomModel bom;
  final OperationModel operation;

  @override
  ConsumerState<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends ConsumerState<ItemDetails> {
  final DataGridController _dataGridController = DataGridController();
  late procumentBomGridSource _bomDataGridSource;
  late procumentOperationGridSource _oprDataGridSource;
  List<DataGridRow> _bomRows = [];
  List<DataGridRow> _OpeationRows = [];

  //<------------------------- Function To Remove Bom Row ----------- -------------->

  void _removeRow(DataGridRow row) {
    setState(() {
      _bomRows.remove(row);
      _bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Function To Update Operation Summary Row  ----------- -------------->

  void updateOperationSummeryRow(double totalAmount, int value) {
    setState(() {
      _bomRows[0] = DataGridRow(
          cells: _bomRows[0].getCells().map((cell) {
            if (cell.columnName == "Amount")
              return DataGridCell(
                  columnName: cell.columnName, value: cell.value + totalAmount);
            else
              return cell;
          }).toList());
    });
  }

  //<------------------------- Function To Update Bom Summary Row  ----------- -------------->

  void _updateBomSummaryRow() {}

  void showFormula(String val, int index) {}

  //<-------------------------Function To show OprFormula------------------------------>
  void showFormulaOperation(int rowIndex) {
  }

  @override
  void initState() {
    log("rebuilding item details");
    initializeBomOpr();
    _bomDataGridSource = procumentBomGridSource(
        _bomRows, _removeRow, _updateBomSummaryRow, showFormula, true, ref);
    _oprDataGridSource = procumentOperationGridSource(_OpeationRows, _removeRow,
        updateOperationSummeryRow, showFormulaOperation, true, ref);
    super.initState();
  }


  void initializeBomOpr() {
    log("bom is1 ${widget.bom}");
    List<dynamic> listOfBoms = widget.bom.bomRows;

    _bomRows = listOfBoms.map((bom) {
      return DataGridRow(cells: [
        DataGridCell<String>(
            columnName: 'Variant Name', value: bom.variantName),
        DataGridCell<String>(columnName: 'Item Group', value: bom.itemGroup),
        DataGridCell<double>(columnName: 'Pieces', value: bom.pieces),
        DataGridCell<double>(columnName: 'Weight', value: bom.weight),
        DataGridCell<double>(columnName: 'Rate', value: bom.rate),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: bom.avgWeight),
        DataGridCell<double>(columnName: 'Amount', value: bom.amount),
        DataGridCell<String>(columnName: 'Sp Char', value: bom.spChar),
        DataGridCell<String>(columnName: 'Operation', value: bom.operation),
        DataGridCell<String>(columnName: 'Type', value: bom.type),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    }).toList();
    List<dynamic> listOfOperation = widget.operation.operationRows;
    log("operation is $listOfOperation");
    _OpeationRows = listOfOperation.map((opr) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Calc Bom', value: opr.calcBom),
        DataGridCell<String>(columnName: 'Operation', value: opr.operation),
        DataGridCell<double>(
            columnName: 'Calc Qty',
            value:0
          // Utils().operationMapping(opr.operation, variant)
        ),
        DataGridCell<double>(columnName: 'Rate', value: opr.labourRate),
        DataGridCell<double>(
            columnName: 'Amount',
            value: opr.labourRate * 0

          // Utils().operationMapping(opr.operation, variant),
        ),
        DataGridCell<String>(
            columnName: 'Calc Method', value: opr.calcMethod),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    double gridWidth = screenWidth * 0.4;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: (gridWidth / 5) * 10,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1)
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '   Modify Bom',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                // height: screenHeight * 0.28,
                child: ProcumentBomGrid(
                  bomDataGridSource: _bomDataGridSource,
                  dataGridController: _dataGridController,
                  gridWidth: gridWidth,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          // Allows the content to expand only as needed
          fit: FlexFit.loose,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: 1)
                ]),
            child: SizedBox(
              // height: screenHeight * 0.33,
              child: ProcumentOperationGrid(
                  operationType: 'Modify operation',
                  gridWidth: gridWidth,
                  dataGridController: _dataGridController,
                  oprDataGridSource: _oprDataGridSource),
            ),
          ),
        )
      ],
    );
  }
}
