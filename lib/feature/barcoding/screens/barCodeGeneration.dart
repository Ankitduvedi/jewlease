import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';
import 'package:jewlease/data/model/stock_details_model.dart';
import 'package:jewlease/feature/barcoding/controllers/tag_list_controller.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/barcode_generator_header.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/tag_data_grid.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/tag_mrp.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/tag_wt_summery.dart';
import 'package:jewlease/feature/procument/screens/operationGridSource.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/utils/utils.dart';
import '../../../data/model/procumentStyleVariant.dart';
import '../../inventoryManagement/controllers/inventoryController.dart';
import '../../procument/controller/procumentFormualaBomController.dart';
import '../../procument/controller/procumentFormulaController.dart';
import '../../procument/screens/formulaGrid.dart';
import '../../procument/screens/procumenOprGrid.dart';
import '../../procument/screens/procumentBomGrid.dart';
import '../../procument/screens/procumentBomGridSource.dart';
import '../controllers/stockController.dart';

class BarCodeGeneration extends ConsumerStatefulWidget {
  const BarCodeGeneration({super.key});

  @override
  ConsumerState<BarCodeGeneration> createState() => _BarCodeGenerationState();
}

class _BarCodeGenerationState extends ConsumerState<BarCodeGeneration> {
  @override
  final DataGridController _dataGridController = DataGridController();
  late procumentBomGridSource _bomDataGridSource;
  late procumentOperationGridSource _oprDataGridSource;
  List<DataGridRow> _bomRows = [];
  List<DataGridRow> OpeationRows = [];
  bool isShowFormulaBom = false;
  int selectedBomForRow = -1;
  bool isShowFormulaOperation = false;
  int formulaRowIndex = 0;
  String variantName = "";
  int variantIndex = 0;


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

  //<--------------------function to get old Operation--------------->
  OperationModel getOldOperaion() {
    print("get old opr called");
    ProcumentStyleVariant currentStock =
        ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;
    List<OperationRowModel> oprRows = [];
    for (int oprIndex = 0; oprIndex < OpeationRows.length; oprIndex++) {
      List<dynamic> values = [];
      values = OpeationRows[oprIndex]
          .getCells()
          .map((dataRow) => dataRow.value)
          .toList();
      oprRows.add(OperationRowModel.fromDatagrid(
          currentStock.operationData.operationRows[oprIndex], values));
    }
    return OperationModel(operationId: "", operationRows: oprRows);
  }

  //<------------------------function to get oldBom ------------------>

  BomModel getOldBom() {
    print("get old bom called");
    List<BomRowModel> bomRows = [];
    for (int rowIndex = 0; rowIndex < _bomRows.length; rowIndex++) {
      List<dynamic> values = [];
      values = _bomRows[rowIndex]
          .getCells()
          .map((dataRow) => dataRow.value)
          .toList();
      bomRows.add(BomRowModel.fromJsonDataRow(values, rowIndex));
    }
    print("old bom rows ${bomRows.length}");
    return BomModel(bomRows: bomRows, headers: []);
  }

  //<------------------------- Function To Update Bom Summary Row  ----------- -------------->

  void _updateBomSummaryRow() {
    print("updating bom summery");
    double totalPcs = _bomRows[0].getCells()[2].value;
    double totalWt = 0.0;
    double totalRate = 0.0;
    double totalAmount = 0.0;
    double totalStoneWt = 0.0;
    double totalMetalWt = 0;

    double prevTotalAmount = _bomRows[0].getCells()[6].value * 1.0;
    double totalAVg = 0.0;
    double totalDiaPieces = 0;

    for (var i = 1; i < _bomRows.length; i++) {
      bool isMetal = _bomRows[i].getCells().any((cell) =>
          cell.columnName == 'Item Group' && cell.value.contains("Metal"));
      if (isMetal) {
        totalWt += _bomRows[i].getCells()[3].value;
        totalMetalWt += _bomRows[i].getCells()[3].value;
      } else {
        totalWt += _bomRows[i].getCells()[3].value * 0.2;
        totalStoneWt += _bomRows[i].getCells()[3].value;
      }
      totalAmount += _bomRows[i].getCells()[6].value;
      totalAVg += _bomRows[i].getCells()[5].value;
    }
    // double avgWtPcs = totalPcs > 0 ? totalWt / totalPcs : 0.0;
    double operationAmount = ref
        .read(inventoryControllerProvider.notifier)
        .getCurrentItem()
        .totalOperationAmount
        .value;
    print("operation amount $operationAmount");
    setState(() {
      _bomRows[0] = DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: 'Summary'),
        DataGridCell<String>(columnName: 'Item Group', value: ''),
        DataGridCell<double>(
            columnName: 'Pieces', value: (_bomRows[0].getCells()[2].value)),
        DataGridCell<double>(columnName: 'Weight', value: totalWt),
        DataGridCell<double>(
            columnName: 'Rate',
            value: (totalAmount + operationAmount) /
                _bomRows[0].getCells()[2].value),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: totalAVg),
        DataGridCell<double>(
            columnName: 'Amount', value: totalAmount + operationAmount),
        DataGridCell<String>(columnName: 'Sp Char', value: ''),
        DataGridCell<String>(columnName: 'Operation', value: ''),
        DataGridCell<String>(columnName: 'Type', value: ''),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    });
    ref.read(formulaBomOprProvider.notifier).updateAction({}, false);
    print("current stone wt $totalStoneWt $totalWt $totalMetalWt ");

    BomModel newBom = getOldBom();
    OperationModel newOpr = getOldOperaion();
    print("updated bom $newBom");

    StockDetailsModel prevStockDetails = ref.read(stockDetailsProvider);
    StockDetailsModel updatedStockDetails = prevStockDetails.copyWith(
        rate: totalAmount,
        currentStoneWt: totalStoneWt,
        currentNetWt: totalWt,
        currentAmount: totalAmount,
        currentPieces: totalPcs,
        currentDiaPieces: totalDiaPieces,
        curentMetalWt: totalMetalWt,
        currentBom: newBom,
        currentOpr: newOpr);
    print("updated bom2 $newBom");
    // print(
    //   "prevTotalAmount $prevTotalAmount totalAmount $totalAmount",
    // );
    if (prevTotalAmount != totalAmount)
      ref.read(stockDetailsProvider.notifier).update(updatedStockDetails);
    ProcumentStyleVariant currentStock =
    ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;
    print("bom after bom update bom summery");
    // Utils.printJsonFormat(currentStock.toJson());

  }

  //<------------------------- Function To update wt   ----------- -------------->
  void _updateWt(String val) {
    print("_upadte wt runs $val");
    // if(_bomRows.length>0) {
    //
    // _bomRows[1] = DataGridRow(
    //     cells: _bomRows[1].getCells().map((cell) {
    //   if (cell.columnName == 'Weight') {
    //     return DataGridCell<double>(
    //         columnName: 'Weight', value: double.parse(val));
    //   }
    //   return cell;
    // }).toList());
    // _updateAmount(double.parse(val) * _bomRows[1].getCells()[4].value);
    // _updateBomSummaryRow();
    // }
  }

  void _updateAmount(double updatedAmount) {
    print("updatedAmount $updatedAmount");
    _bomRows[1] = DataGridRow(
        cells: _bomRows[1].getCells().map((cell) {
      if (cell.columnName == 'Amount') {
        return DataGridCell<double>(columnName: 'Amount', value: updatedAmount);
      }
      return cell;
    }).toList());
  }

  //<-------------------------Function To Hide Opr/Formula------------------------------>
  void showFormulaBom(String val, int rowIndex) {
    print("showing bom formula $rowIndex $formulaRowIndex");
    ProcumentStyleVariant currentStock =
        ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;
    setState(() {
      print("val is ${val}");
      if (val == "Show Formula") {
        formulaRowIndex = rowIndex;
        isShowFormulaBom = true;
      } else {
        formulaRowIndex = -1;
        isShowFormulaBom = false;
      }
      isShowFormulaOperation = false;
    });
    ref.read(showFormulaProvider.notifier).selectedRow(rowIndex);
    ref
        .read(formulaBomOprProvider.notifier)
        .updateAction({"variantName": currentStock.variantName}, false);
  }

  //<-------------------------Function To show OprFormula------------------------------>
  void showFormulaOperation(int rowIndex) {
    print("showing operation formula $rowIndex $formulaRowIndex");
    if (isShowFormulaOperation && rowIndex == formulaRowIndex) return;

    setState(() {
      formulaRowIndex = rowIndex;
      isShowFormulaBom = false;
      isShowFormulaOperation = false;
    });
    Future.delayed(Duration(milliseconds: 10), () {
      setState(() {
        print("this called here");
        isShowFormulaOperation = true;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeBomOpr();
    _bomDataGridSource = procumentBomGridSource(
        _bomRows, _removeRow, _updateBomSummaryRow, showFormulaBom, true, ref);
    _oprDataGridSource = procumentOperationGridSource(OpeationRows, _removeRow,
        updateOperationSummeryRow, showFormulaOperation, true, ref);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utils().fetchFormulas(
          ref.read(inventoryControllerProvider.notifier).getCurrentItem()!,
          context,
          ref);
    });
  }

  //<-------------------------Function To Update Bom From Formula -------------->

  void updateBomFromFormula(Map<dynamic, dynamic> data) {
    print("update bom from formula");
    int updatedRowIndex = data["data"]["updatedRowIndex"];
    double updatedRate = data["data"]["total"];
    double weight = _bomRows[updatedRowIndex]
        .getCells()
        .where((cell) => cell.columnName == 'Weight')
        .first
        .value;

    _bomRows[updatedRowIndex] = DataGridRow(
        cells: _bomRows[updatedRowIndex].getCells().map((cell) {
      if (cell.columnName == 'Rate')
        return DataGridCell<double>(
            columnName: 'Rate'.toString(), value: updatedRate);
      else if (cell.columnName == 'Amount') {
        return DataGridCell<double>(
            columnName: 'Amount'.toString(), value: updatedRate * weight);
      } else
        return cell;
    }).toList());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateBomSummaryRow();
    });
    print("end updating bom from formula");
  }

  //<-------------------------Function To Update Bom From Formula -------------->
  void updateOprFromFormula(Map<String, dynamic> data) {
    print("update formulat to opr");
    int updatedRowIndex = data["data"]["updatedRowIndex"];
    double updatedTotal = data["data"]["total"];
    OperationRowModel operationRowModel = ref
        .read(inventoryControllerProvider.notifier)
        .getItemAt(variantIndex)
        .operationData
        .operationRows[updatedRowIndex];
    //<--update current bom from formula rate---->
    setState(() {
      OpeationRows[updatedRowIndex] = DataGridRow(
          cells: OpeationRows[updatedRowIndex].getCells().map((cell) {
        if (cell.columnName == "Rate")
          return DataGridCell(columnName: cell.columnName, value: updatedTotal);
        if (cell.columnName == "Amount")
          return DataGridCell(
              columnName: cell.columnName,
              value: updatedTotal * operationRowModel.calcQty);
        else
          return cell;
      }).toList());
    });

    //<---update operation provider

    operationRowModel.labourRate = updatedTotal;
    operationRowModel.labourAmount = updatedTotal * operationRowModel.calcQty;
    OperationModel operationModel = ref
        .read(inventoryControllerProvider.notifier)
        .getItemAt(variantIndex)
        .operationData;
    double totalAmount = operationModel.operationRows
        .fold(0.0, (sum, row) => sum + row.labourAmount);
    ProcumentStyleVariant oldStyleVariant =
        ref.read(inventoryControllerProvider.notifier).getItemAt(variantIndex);
    oldStyleVariant.totalOperationAmount = TotalOperationAmount(totalAmount);
    ref
        .read(inventoryControllerProvider.notifier)
        .updateStyleVariant(oldStyleVariant);
    Future.delayed(Duration(seconds: 1), () {
      _updateBomSummaryRow();
    });
  }

  void initializeBomOpr() async {
    ProcumentStyleVariant currentStock =
        ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;

    // if (currentStock.bom.) return;
    // print("bom is ${currentStock.bom}");

    List<BomRowModel> listOfBoms = currentStock.bomData.bomRows;
    print("bom lenght is ${listOfBoms.length}");

    _bomRows = listOfBoms.map((bom) {
      print("bom is2 ${bom.weight}" );
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
    List<OperationRowModel> listOfOperation =
        currentStock.operationData.operationRows;
    print("operation is $listOfOperation");
    OpeationRows = listOfOperation.map((opr) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Calc Bom', value: opr.calcBom),
        DataGridCell<String>(columnName: 'Operation', value: opr.operation),
        DataGridCell<double>(
            columnName: 'Calc Qty',
            value: Utils().operationMapping(opr.operation, currentStock)),
        DataGridCell<double>(columnName: 'Rate', value: opr.labourRate),
        DataGridCell<double>(
          columnName: 'Amount',
          value: opr.labourRate *
              Utils().operationMapping(opr.operation, currentStock),
        ),
        DataGridCell<String>(columnName: 'Calc Method', value: opr.calcMethod),
      ]);
    }).toList();
    _bomDataGridSource = procumentBomGridSource(
        _bomRows, _removeRow, _updateBomSummaryRow, showFormulaBom, true, ref);
    _oprDataGridSource = procumentOperationGridSource(OpeationRows, _removeRow,
        updateOperationSummeryRow, showFormulaOperation, true, ref);
    setState(() {
      variantName = currentStock.variantName;
      variantIndex = currentStock.vairiantIndex;
    });
  }

  Widget build(BuildContext context) {
    ref.listen<StockDetailsModel>(
      stockDetailsProvider,
      (previous, next) {
        // Trigger your function here
        if (previous != next) {
          _updateWt(
            next.currentWt.toString(),
          );
        }
      },
    );
    ref.listen<bool>(isTagCreatedProvider, (previous, next) {
      // Trigger your function here
      initializeBomOpr();
      print("triggered");
      setState(() {

      });
    });
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final gridAction = ref.watch(formulaBomOprProvider);
    if (gridAction['trigger'] == true) {
      print("start updating bom from formula1");
      print("grid action is ${gridAction}");
      Map<String, dynamic> gridActionData = gridAction["data"];
      Map<String, dynamic> updatedData = gridActionData["data"];
      print("updated data $updatedData");
      if (updatedData["isBomUpdate"] == true)
        updateBomFromFormula(gridAction["data"]);
      else if (updatedData["isOprUpdate"] == true) {
        updateOprFromFormula(gridAction["data"]);
      }

      print("end updating bom from formula1");
    }
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: screenHeight * 0.1),
        child: Column(
          children: [
            BarcodeHeader(),
            Row(
              children: [
                if (isShowFormulaOperation)
                  Container(
                    width: 600,
                    height: 300,
                    child: FormulaDataGrid(
                      varientName: variantName,
                      varientIndex: variantIndex,
                      isFromBom: !isShowFormulaOperation,
                      FormulaName:
                          "${variantName}_${variantIndex}_opr_$formulaRowIndex",
                      backButton: () {
                        setState(() {
                          print("backbutton is pressed");
                          isShowFormulaOperation = !isShowFormulaOperation;
                        });
                      },
                      formulaIndex: formulaRowIndex,
                    ),
                  ),
                if (!isShowFormulaOperation)
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '   Modify Bom',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.28,
                            child: ProcumentBomGrid(
                              bomDataGridSource: _bomDataGridSource,
                              dataGridController: _dataGridController,
                              gridWidth: gridWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  width: 10,
                ),
                if (isShowFormulaBom)
                  Container(
                    width: 630,
                    height: 300,
                    child: FormulaDataGrid(
                      varientIndex: variantIndex,
                      varientName: variantName,
                      isFromBom: isShowFormulaBom,
                      FormulaName:
                          "${variantName}_${variantIndex}_bom_${formulaRowIndex}",
                      backButton: () {
                        setState(() {
                          isShowFormulaBom = !isShowFormulaBom;
                        });
                      },
                      formulaIndex: formulaRowIndex,
                    ),
                  ),
                if (!isShowFormulaBom)
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
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
                      height: screenHeight * 0.33,
                      child: ProcumentOperationGrid(
                          operationType: 'Modify operation',
                          gridWidth: gridWidth,
                          dataGridController: _dataGridController,
                          oprDataGridSource: _oprDataGridSource),
                    ),
                  ))
              ],
            ),
            Row(
              children: [
                Expanded(child: TagWtSummery()),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: TagMRP())
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(height: 150, child: TagListUI())
          ],
        ),
      ),
    );
  }
}

class CheckboxFieldWidget extends StatelessWidget {
  final String label;

  const CheckboxFieldWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: Color(0xff28713E),
          value: true,
          onChanged: (val) {},
          checkColor: Colors.white,
        ),
        Text(label),
      ],
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
