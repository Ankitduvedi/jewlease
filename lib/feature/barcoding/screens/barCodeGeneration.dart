import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/inventoryItem.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/barcode_generator_header.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/tag_data_grid.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/tag_mrp.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/tag_wt_summery.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../inventoryManagement/controllers/inventoryController.dart';
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
  late procumentBomGridSource _oprDataGridSource;
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

  //<------------------------- Function To Update Bom Summary Row  ----------- -------------->

  void _updateBomSummaryRow() {
    print("fun call");
    int totalPcs = 0;
    double totalWt = 0.0;
    double totalRate = 0.0;
    double totalAmount = 0.0;
    double totalStoneWt = 0.0;

    double prevTotalAmount = _bomRows[0].getCells()[6].value * 1.0;

    for (var i = 1; i < _bomRows.length; i++) {
      if (_bomRows[i].getCells()[2].value is num) {
        num value = _bomRows[i].getCells()[2].value;
        totalPcs += value is int ? value : value.toInt();
      } else {
        throw Exception(
            'Invalid value type: ${_bomRows[i].getCells()[2].value.runtimeType}');
      }

      totalWt += _bomRows[i].getCells()[3].value ?? 0 * 1.0 as double;
      print("wt is ${_bomRows[i].getCells()[3].value}");
      totalRate += _bomRows[i].getCells()[4].value ?? 0 * 1.0 as double;
      totalAmount += _bomRows[i].getCells()[6].value ?? 0.0 as double;
      if (_bomRows[i].getCells()[1].value.contains("Diamond")) {
        totalStoneWt += _bomRows[i].getCells()[3].value ?? 0 * 1.0 as double;
      }
    }

    double avgWtPcs = totalPcs > 0 ? totalWt / totalPcs : 0.0;

    setState(() {
      _bomRows[0] = DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: 'Summary'),
        DataGridCell<String>(columnName: 'Item Group', value: ''),
        DataGridCell<int>(columnName: 'Pieces', value: totalPcs),
        DataGridCell<double>(columnName: 'Weight', value: totalWt),
        DataGridCell<double>(columnName: 'Rate', value: totalRate),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: avgWtPcs),
        DataGridCell(columnName: 'Amount', value: totalAmount),
        DataGridCell<String>(columnName: 'Sp Char', value: ''),
        DataGridCell<String>(columnName: 'Operation', value: ''),
        DataGridCell<String>(columnName: 'Type', value: ''),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    });
    print("current stone wt $totalStoneWt $totalWt ");

    StockDetails prevStockDetails = ref.read(stockDetailsProvider);
    StockDetails updatedStockDetails = prevStockDetails.copyWith(
        rate: totalAmount, currentStoneWt: totalStoneWt, currentNetWt: totalWt);
    print("prevTotalAmount $prevTotalAmount totalAmount $totalAmount");
    if (prevTotalAmount != totalAmount)
      ref.read(stockDetailsProvider.notifier).update(updatedStockDetails);
  }

  //<------------------------- Function To update wt   ----------- -------------->
  void _updateWt(String val) {
    print("_upadte wt runs $val");
    _bomRows[1] = DataGridRow(
        cells: _bomRows[1].getCells().map((cell) {
      if (cell.columnName == 'Weight') {
        return DataGridCell<double>(
            columnName: 'Weight', value: double.parse(val));
      }
      return cell;
    }).toList());
    _updateAmount(double.parse(val) * _bomRows[1].getCells()[4].value);
    _updateBomSummaryRow();
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

  void showFormula(String val, int index) {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeBomOpr();
    _bomDataGridSource = procumentBomGridSource(
        _bomRows, _removeRow, _updateBomSummaryRow, showFormula, true);
    _oprDataGridSource = procumentBomGridSource(
        _OpeationRows, _removeRow, _updateBomSummaryRow, showFormula, true);
  }

  void initializeBomOpr() {
    InventoryItemModel currentStock =
        ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;

    List<dynamic> listOfBoms = currentStock.bom["data"];

    _bomRows = listOfBoms.map((bom) {
      print("bom is $bom");
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: bom[0]),
        DataGridCell<String>(columnName: 'Item Group', value: bom[1]),
        DataGridCell<int>(columnName: 'Pieces', value: bom[2]),
        DataGridCell<double>(columnName: 'Weight', value: bom[3] * 1.0),
        DataGridCell(columnName: 'Rate', value: bom[4]),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: bom[5] * 1.0),
        DataGridCell(columnName: 'Amount', value: bom[6]),
        DataGridCell<String>(columnName: 'Sp Char', value: bom[7]),
        DataGridCell<String>(columnName: 'Operation', value: bom[8]),
        DataGridCell<String>(columnName: 'Type', value: bom[9]),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    }).toList();
    List<dynamic> listOfOperation = currentStock.operation["data"];
    print("operation is $listOfOperation");
    _OpeationRows = listOfOperation.map((opr) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Calc Bom', value: opr[0]),
        DataGridCell<String>(columnName: 'Operation', value: opr[1]),
        DataGridCell<int>(columnName: 'Calc Qty', value: opr[2]),
        DataGridCell<dynamic>(columnName: 'Type', value: opr[3]),
        DataGridCell<dynamic>(columnName: 'Calc Method', value: opr[4]),
        DataGridCell<dynamic>(columnName: 'Calc Method Value', value: opr[5]),
        DataGridCell<dynamic>(columnName: 'Depd Method', value: opr[6]),
        DataGridCell<dynamic>(columnName: 'Depd Method Value', value: opr[7]),
        DataGridCell<Widget>(columnName: 'Depd Type', value: null),
        DataGridCell<Widget>(columnName: 'Depd Qty', value: null),
      ]);
    }).toList();
    setState(() {});
  }

  Widget build(BuildContext context) {
    ref.listen<StockDetails>(
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
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(top: screenHeight * 0.1),
        child: Column(
          children: [
            BarcodeHeader(),
            Row(
              children: [
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
