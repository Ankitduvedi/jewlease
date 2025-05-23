import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';
import 'package:jewlease/data/model/procumentStyleVariant.dart';
import 'package:jewlease/feature/procument/screens/operationGridSource.dart';
import 'package:jewlease/feature/procument/screens/procumenOprGrid.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGrid.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGridSource.dart';
import 'package:jewlease/feature/vendor/controller/bom_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/utils/utils.dart';
import '../../../main.dart';
import '../../../widgets/data_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../sub_contracting/Controllers/return_raw_material.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentBomProcController.dart';
import '../controller/procumentFormualaBomController.dart';
import '../controller/procumentFormulaController.dart';
import 'formulaGrid.dart';

class procumentBomOprDialog extends ConsumerStatefulWidget {
  procumentBomOprDialog(this.VariantName, this.VairentIndex, this.canEdit,
      this.isFromSubContracting,
      {super.key, this.isHorizonatal = true, this.isAddNewVariant = false});

  final String VariantName;
  final int VairentIndex;
  final bool canEdit;
  final bool isFromSubContracting;
  final bool isHorizonatal;
  final isAddNewVariant;

  @override
  _procumentGridState createState() => _procumentGridState();
}

class _procumentGridState extends ConsumerState<procumentBomOprDialog> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _bomRows = [];
  List<DataGridRow> OpeationRows = [];
  late procumentBomGridSource bomDataGridSource;
  late procumentOperationGridSource oprDataGridSource;
  bool isShowFormulaBom = false;
  int selectedBomForRow = -1;
  bool isShowFormulaOperation = false;
  int formulaRowIndex = 0;

  @override
  void initState() {
    super.initState();
    initializeBomOpr();

    bomDataGridSource = procumentBomGridSource(_bomRows, _removeRow,
        _updateBomSummaryRow, showFormulaBom, widget.canEdit, ref);
    // Future.delayed(Duration(milliseconds: 500),(){
    oprDataGridSource = procumentOperationGridSource(OpeationRows, _removeRow,
        updateOperationSummeryRow, showFormulaOperation, widget.canEdit, ref);
    // });
  }

  void showRawMaterialDialog(String value) {
    showDialog(
      context: context,
      builder: (context1) => ItemTypeDialogScreen(
        title: 'Outward Stock',
        endUrl: 'SubContracting/IssueWork',
        value: 'Stock ID',
        queryMap: value.contains("Stone")
            ? {"isRawMaterial": 1, "Variant Type": "Diamond"}
            : {"isRawMaterial": 1, "Variant Type": "Gold"},
        onOptionSelectd: (selectedValue) {
          print("selected value $selectedValue");
        },
        onSelectdRow: (selectedRow) {
          print("dialog");
          print("selected raw material row $selectedRow");
          selectedRow["styleVariant"] = widget.VariantName;
          selectedRow["rowNo"] = _bomRows.length + 1;
          if (selectedRow["Variant Type"] == "Diamond") {
            selectedRow["Net Weight"] = selectedRow["Dia Weight"];
          }

          ref.read(returnRawListProvider.notifier).addMap(selectedRow);
          _addNewRowBomRawMaterial(selectedRow, value);
          _updateBomSummaryRow();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    double gridWidth = widget.isHorizonatal
        ? screenWidth * 0.4
        : screenWidth * 0.8; // Set grid width to 50% of screen width
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

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      scrollDirection: widget.isHorizonatal ? Axis.horizontal : Axis.vertical,
      children: [
        if (isShowFormulaOperation)
          FormulaDataGrid(
            varientName: widget.VariantName,
            varientIndex: widget.VairentIndex,
            isFromBom: !isShowFormulaOperation,
            FormulaName:
                "${widget.VariantName}_${widget.VairentIndex}_opr_$formulaRowIndex",
            backButton: () {
              setState(() {
                print("backbutton is pressed");
                isShowFormulaOperation = !isShowFormulaOperation;
              });
            },
            formulaIndex: formulaRowIndex,
          ),
        if (!isShowFormulaOperation)
          Container(
            width: screenWidth * 0.45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Bom',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              if (widget.canEdit == false) return;
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        content: ItemDataScreen(
                                          title: '',
                                          endUrl: 'Global/operations/',
                                          canGo: true,
                                          onDoubleClick: (Map<String, dynamic>
                                              intialData) {
                                            print("intial data is $intialData");
                                            String operation =
                                                intialData["OPERATION_NAME"]
                                                    .toUpperCase()
                                                    .trim();
                                            double calcQty = 0;
                                            ProcumentStyleVariant? variant;
                                            if (!widget.isAddNewVariant) {
                                              variant = ref.read(
                                                      procurementVariantProvider2)[
                                                  widget.VairentIndex];
                                              calcQty = Utils()
                                                  .operationMapping(
                                                      operation, variant);
                                            }

                                            print("new calc qty is $calcQty");
                                            OperationRowModel newOperationRow =
                                                OperationRowModel(
                                                    variantName: '',
                                                    calcBom:
                                                        variant?.variantName ??
                                                            "",
                                                    calcCf: 0,
                                                    calcMethod: '',
                                                    calcMethodVal: '',
                                                    calcQty: calcQty,
                                                    calculateFormula: '',
                                                    depdBom: '',
                                                    depdMethod: '',
                                                    depdMethodVal: 0,
                                                    depdQty: 0,
                                                    labourAmount: 0,
                                                    labourAmountLocal: 0,
                                                    labourRate: 0,
                                                    maxRateValue: 0,
                                                    minRateValue: 0,
                                                    operation: operation,
                                                    operationType: '',
                                                    rateAsPerFormula: 0,
                                                    rowStatus: 1,
                                                    rateEditInd: 1);
                                            if (!widget.isAddNewVariant)
                                              ref
                                                  .read(procurementVariantProvider2)[
                                                      widget.VairentIndex]
                                                  .operationData
                                                  .operationRows
                                                  .add(newOperationRow);
                                            _addNewRowOpr(newOperationRow);

                                            Navigator.pop(context);
                                          },
                                        ),
                                      ));
                            },
                            child: Text('+ Add Operation',
                                style: TextStyle(color: Color(0xff28713E))),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (String value) {
                              log("Chosen Item: $value");
                              if (widget.canEdit == false) return;

                              if (widget.isFromSubContracting) {
                                showRawMaterialDialog(value);
                              } else {
                                const materialPaths = {
                                  'Gold':
                                      'ItemMasterAndVariants/Metal/Gold/Variant/',
                                  'Silver':
                                      'ItemMasterAndVariants/Metal/Silver/Variant/',
                                  'Diamond':
                                      'ItemMasterAndVariants/Stone/Diamond/Variant/',
                                  'Bronze':
                                      'ItemMasterAndVariants/Metal/Bronze/Variant/',
                                };

                                final key = materialPaths.keys.firstWhere(
                                  (k) => value.contains(k),
                                  orElse: () => '',
                                );

                                if (key.isNotEmpty)
                                  showProcumentdialog(
                                      materialPaths[key]!, value);
                              }
                            },
                            itemBuilder: (context) => bomPopUpItem(),
                            child: Text(
                              '+ Add Bom',
                              style: TextStyle(color: const Color(0xff28713E)),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Summary',
                                style: TextStyle(color: Color(0xff28713E))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ProcumentBomGrid(
                  bomDataGridSource: bomDataGridSource,
                  dataGridController: _dataGridController,
                  gridWidth: gridWidth,
                )
              ],
            ),
          ),
        SizedBox(
          width: 20,
        ),
        if (isShowFormulaBom)
          FormulaDataGrid(
            varientIndex: widget.VairentIndex,
            varientName: widget.VariantName,
            isFromBom: isShowFormulaBom,
            FormulaName:
                "${widget.VariantName}_${widget.VairentIndex}_bom_${formulaRowIndex}",
            backButton: () {
              setState(() {
                isShowFormulaBom = !isShowFormulaBom;
              });
            },
            formulaIndex: formulaRowIndex,
          ),
        if (!isShowFormulaBom)
          ProcumentOperationGrid(
              operationType: 'Operation',
              gridWidth: gridWidth,
              dataGridController: _dataGridController,
              oprDataGridSource: oprDataGridSource)
      ],
    );
  }

  List<PopupMenuEntry<String>> bomPopUpItem() {
    return [
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
      PopupMenuItem<String>(
        value: 'Consumables',
        child: ListTile(
          title: Text('Consumables'),
          onTap: () {
            Navigator.pop(context, 'Consumables');
          },
        ),
      ),
      PopupMenuItem<String>(
        value: 'Packing Material',
        child: ListTile(
          title: Text('Packing Material'),
          onTap: () {
            Navigator.pop(context, 'Packing Material');
          },
        ),
      ),
    ];
  }

  //<-------------------------Function To Hide Opr/Formula------------------------------>
  void showFormulaBom(String val, int rowIndex) {
    setState(() {
      print("val is ${val}");
      if (val == "Show Formula") {
        formulaRowIndex = rowIndex;
        isShowFormulaBom = true;
      } else {
        isShowFormulaBom = false;
      }
      isShowFormulaOperation = false;
    });
    ref.read(showFormulaProvider.notifier).selectedRow(rowIndex);
    ref
        .read(formulaBomOprProvider.notifier)
        .updateAction({"variantName": widget.VariantName}, false);
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
        print("this called herre");
        isShowFormulaOperation = true;
      });
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
        .read(procurementVariantProvider2)[widget.VairentIndex]
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
        .read(procurementVariantProvider2)[widget.VairentIndex]
        .operationData;
    double totalAmount = operationModel.operationRows
        .fold(0.0, (sum, row) => sum + row.labourAmount);
    ref
        .read(procurementVariantProvider2)[widget.VairentIndex]
        .totalOperationAmount = TotalOperationAmount(totalAmount);
    Future.delayed(Duration(seconds: 1), () {
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Function To Add New Bom ----------- -------------->

  void _addNewRowBom(String variantName, String itemGroup) {
    setState(() {
      Map<dynamic, dynamic>? varientData = ref
          .read(procurementVariantProvider.notifier)
          .getItemByVariant(widget.VariantName);
      print("variantData is $varientData");
      _bomRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Variant Name', value: variantName),
          DataGridCell<String>(columnName: 'Item Group', value: itemGroup),
          DataGridCell<double>(
              columnName: 'Pieces',
              value: itemGroup.contains('Diamond') ? 1 : 0),
          DataGridCell<double>(columnName: 'Weight', value: 0.0),
          DataGridCell<double>(columnName: 'Rate', value: 0.0),
          DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
          DataGridCell<double>(columnName: 'Amount', value: 0.0),
          DataGridCell<String>(columnName: 'Sp Char', value: ''),
          DataGridCell<String>(columnName: 'Operation', value: ''),
          DataGridCell<String>(columnName: 'Type', value: ''),
          DataGridCell<Widget>(columnName: 'Actions', value: null),
        ]),
      );
      bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Add New Bom With Raw Material ------------------------->
  void _addNewRowBomRawMaterial(
      Map<String, dynamic> rawMaterialData, String itemGroup) {
    setState(() {
      _bomRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'Variant Name',
              value: rawMaterialData["Variant Name"]),
          DataGridCell<String>(columnName: 'Item Group', value: itemGroup),
          DataGridCell<double>(
              columnName: 'Pieces',
              value: rawMaterialData['Dia Pieces'] == 0 &&
                      rawMaterialData["Pieces"] <= 1
                  ? 0
                  : rawMaterialData['Pieces']),
          DataGridCell<double>(
              columnName: 'Weight',
              value: rawMaterialData["Variant Type"] == "Gold"
                  ? double.parse(rawMaterialData["Net Weight"])
                  : double.parse(rawMaterialData["Dia Weight"])),
          DataGridCell<double>(columnName: 'Rate', value: 0.0),
          DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
          DataGridCell<double>(columnName: 'Amount', value: 0.0),
          DataGridCell<String>(columnName: 'Sp Char', value: ''),
          DataGridCell<String>(columnName: 'Operation', value: ''),
          DataGridCell<String>(
              columnName: 'Type', value: rawMaterialData["Variant Type"]),
          DataGridCell<Widget>(columnName: 'Actions', value: null),
        ]),
      );
      bomDataGridSource.updateDataGridSource();
      bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Function To Add New Opr ----------- -------------->

  void _addNewRowOpr(OperationRowModel newOprRow) {
    setState(() {
      OpeationRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(
              columnName: 'Calc Bom', value: newOprRow.calcBom),
          DataGridCell<String>(
              columnName: 'Operation', value: newOprRow.operation),
          DataGridCell<double>(
              columnName: 'Calc Qty', value: newOprRow.calcQty),
          DataGridCell<double>(columnName: 'Rate', value: newOprRow.labourRate),
          DataGridCell<double>(
              columnName: 'Amount', value: newOprRow.labourAmount),
          DataGridCell<String>(
              columnName: 'Calc Method', value: newOprRow.calcMethod),
        ]),
      );

      oprDataGridSource = procumentOperationGridSource(OpeationRows, _removeRow,
          updateOperationSummeryRow, showFormulaOperation, widget.canEdit, ref);
    });
    updateOperationSummeryRow(0, OpeationRows.length - 1);
  }

//<------------------------- Function To intialize Bom & Opr with Empty Row --------------->

  void intializeBomOprEmpty() {
    setState(() {
      _bomRows = [
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Variant Name', value: 'Summary'),
          DataGridCell<String>(columnName: 'Item Group', value: ""),
          DataGridCell<double>(columnName: 'Pieces', value: 1.0),
          DataGridCell<double>(columnName: 'Weight', value: 0.0),
          DataGridCell<double>(columnName: 'Rate', value: 0.0),
          DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
          DataGridCell<double>(columnName: 'Amount', value: 0.0),
          DataGridCell<String>(columnName: 'Sp Char', value: ''),
          DataGridCell<String>(columnName: 'Operation', value: ''),
          DataGridCell<String>(columnName: 'Type', value: ''),
          DataGridCell<Widget>(columnName: 'Actions', value: null)
        ]),
      ];
      // OpeationRows = [
      //   DataGridRow(cells: [
      //     DataGridCell<String>(columnName: 'Calc Bom', value: ""),
      //     DataGridCell<String>(columnName: 'Operation', value: ""),
      //     DataGridCell<double>(columnName: 'Calc Qty', value: 0),
      //     DataGridCell<double>(columnName: 'Rate', value: 0),
      //     DataGridCell<double>(columnName: 'Amount', value: 0),
      //     DataGridCell<String>(columnName: 'Calc Method', value: ""),
      //   ])
      // ];
    });
  }

//<------------------------- Function To Intialize Bom &  Opr ----------- -------------->

  void initializeBomOpr() {
    if (widget.VariantName == "") {
      intializeBomOprEmpty();
      return;
    }
    initializeBom();
    initializeOpr();
  }

  void initializeBom() {
    ProcumentStyleVariant variant =
        ref.read(procurementVariantProvider2)[widget.VairentIndex];
    List<BomRowModel> listOfBoms = variant.bomData.bomRows;
    _bomRows = listOfBoms.map((bom) {
      print("bor row index ${widget.VairentIndex} ${bom.toJson()}");
      // print("bom is ${bom[2]}${bom[2].runtimeType}");
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
  }

  void initializeOpr() {
    try {
      print("initialize opr called");
      ProcumentStyleVariant variant =
          ref.read(procurementVariantProvider2)[widget.VairentIndex];
      List<OperationRowModel> operationData =
          variant.operationData.operationRows;
      setState(() {
        OpeationRows = operationData.map((opr) {
          return DataGridRow(cells: [
            DataGridCell<String>(columnName: 'Calc Bom', value: opr.calcBom),
            DataGridCell<String>(columnName: 'Operation', value: opr.operation),
            DataGridCell<double>(
                columnName: 'Calc Qty',
                value: Utils().operationMapping(opr.operation, variant)),
            DataGridCell<double>(columnName: 'Rate', value: opr.labourRate),
            DataGridCell<double>(
              columnName: 'Amount',
              value: opr.labourRate *
                  Utils().operationMapping(opr.operation, variant),
            ),
            DataGridCell<String>(
                columnName: 'Calc Method', value: opr.calcMethod),
          ]);
        }).toList();
        oprDataGridSource = procumentOperationGridSource(
            OpeationRows,
            _removeRow,
            updateOperationSummeryRow,
            showFormulaOperation,
            widget.canEdit,
            ref);
      });
      print("initialize opr called ends");
    } catch (e) {
      print("intialize opr error $e");
    }
  }

//<------------------------- Function To Remove Bom Row ----------- -------------->

  void _removeRow(DataGridRow row) {
    setState(() {
      _bomRows.remove(row);
      bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

//<------------------------- Function To Update Operation Summary Row  ----------- -------------->

  void updateOperationSummeryRow(
      double operationTotalAmount, int updatedRowIndex) {
    if (widget.isAddNewVariant) {
      List<OperationRowModel> listOfOperation = [];
      for (int rowNo = 0; rowNo <OpeationRows.length; rowNo++) {
        List<dynamic> values =
            OpeationRows[rowNo].getCells().map((cell) => cell.value).toList();

        listOfOperation
            .add(OperationRowModel.fromNewDatagrid(values));
      }
      ref.read(operationProvider.notifier).updateAll(listOfOperation);
      setState(() {});
      return;
    }
    print("updateOprSummery called");
    setState(() {
      double updatedRate = OpeationRows[updatedRowIndex]
          .getCells()
          .firstWhere((cell) => cell.columnName == "Rate")
          .value;

      List<OperationRowModel> operationData = ref
          .read(procurementVariantProvider2)[widget.VairentIndex]
          .operationData
          .operationRows;
      operationData[updatedRowIndex].labourRate = updatedRate;
      operationData[updatedRowIndex].labourAmount =
          updatedRate * operationData[updatedRowIndex].calcQty;
      ref
          .read(procurementVariantProvider2)[widget.VairentIndex]
          .operationData
          .operationRows[updatedRowIndex] = operationData[updatedRowIndex];
      _updateBomSummaryRow();
    });
  }

  Future<void> updateOprFromBom() async {
    print("updateOprFromBom Called");
    ProcumentStyleVariant oldVariant =
        ref.read(procurementVariantProvider2)[widget.VairentIndex];
    final completeVariant = await ProcumentStyleVariant.calculte(oldVariant);
    ref.read(procurementVariantProvider2)[widget.VairentIndex] =
        completeVariant;
    initializeOpr();
    double totalAmount = 0;
    for (int oprIndex = 0; oprIndex < OpeationRows.length; oprIndex++) {
      List<dynamic> values =
          OpeationRows[oprIndex].getCells().map((cell) => cell.value).toList();
      ref
              .read(procurementVariantProvider2)[widget.VairentIndex]
              .operationData
              .operationRows[oprIndex] =
          OperationRowModel.fromDatagrid(
              oldVariant.operationData.operationRows[oprIndex], values);
      totalAmount += values[4];
    }
    ref
        .read(procurementVariantProvider2)[widget.VairentIndex]
        .totalOperationAmount = TotalOperationAmount(totalAmount);
    print("updateOprFromBom Called ends");
  }

//<------------------------- Function To Update Bom Summary Row  ----------- -------------->

  void _updateBomSummaryRow() async {
    if (widget.isAddNewVariant) {
      List<BomRowModel> listOfBoms = [];
      for (int rowNo = 0; rowNo < _bomRows.length; rowNo++) {
        List<dynamic> values =
            _bomRows[rowNo].getCells().map((cell) => cell.value).toList();
        listOfBoms.add(BomRowModel.fromJsonDataRow(values, rowNo));
      }
      ref.read(bomProvider.notifier).replaceAll(listOfBoms);
      setState(() {});
      return;
    }
    try {
      print("start updating bom summary row");
      double totalWt = 0.0;
      double totalAmount = 0.0;
      double totalAVg = 0.0;

      for (var i = 1; i < _bomRows.length; i++) {
        bool isMetal = _bomRows[i].getCells().any((cell) =>
            cell.columnName == 'Item Group' && cell.value.contains("Metal"));
        if (isMetal) {
          totalWt += _bomRows[i].getCells()[3].value;
        } else {
          totalWt += _bomRows[i].getCells()[3].value * 0.2;
        }
        totalAmount += _bomRows[i].getCells()[6].value;
        totalAVg += _bomRows[i].getCells()[5].value;
      }
      List<BomRowModel> updatedBom = [];
      for (var i = 0; i < _bomRows.length; i++) {
        List<dynamic> rowValues = _bomRows[i].getCells().map((cell) {
          return cell.value;
        }).toList();
        updatedBom.add(BomRowModel.fromJsonDataRow(rowValues, i + 1));
      }
      ;
      ref.read(procurementVariantProvider2)[widget.VairentIndex].bomData =
          BomModel(bomRows: updatedBom, headers: []);
      await updateOprFromBom();
      double operationAmount = ref
          .read(procurementVariantProvider2)[widget.VairentIndex]
          .totalOperationAmount
          .value;
      print("updated operation amount $operationAmount bomamount $totalAmount");

      setState(() {
        _bomRows[0] = DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Variant Name', value: 'Summary'),
          DataGridCell<String>(columnName: 'Item Group', value: ''),
          DataGridCell<double>(
              columnName: 'Pieces', value: (_bomRows[0].getCells()[2].value)),
          DataGridCell<double>(columnName: 'Weight', value: totalWt),
          DataGridCell<double>(
              columnName: 'Rate',
              value: totalAmount / _bomRows[0].getCells()[2].value),
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

      //<------------------update procumentBom------------------>
      updatedBom = [];
      for (var i = 0; i < _bomRows.length; i++) {
        List<dynamic> rowValues = _bomRows[i].getCells().map((cell) {
          return cell.value;
        }).toList();
        updatedBom.add(BomRowModel.fromJsonDataRow(rowValues, i + 1));
      }
      ;

      //<------------------updating the varient after updating bom summery row------------------>
      Map<String, dynamic> updatedVarient = Map.fromIterable(
        _bomRows[0].getCells(),
        key: (cell) => "${cell.columnName}",
        value: (cell) => cell.value,
      );
      double stoneWeight = 0;
      double stonePieces = 0;
      for (var row in _bomRows) {
        if (row.getCells()[1].value.contains('Diamond')) {
          stoneWeight += row.getCells()[3].value * 0.2;
          stonePieces += row.getCells()[2].value;
        }
        print("stone pieces ${row.getCells()[2].value}");
      }
      print("updated stone weight is ${stoneWeight} $stonePieces");
      if (stoneWeight != 0) updatedVarient["Stone Wt"] = stoneWeight;
      updatedVarient["Stone Pieces"] = stonePieces;
      updatedVarient["varientIndex"] = widget.VairentIndex;
      updatedVarient["Variant Name"] = widget.VariantName;
      updatedVarient["BOM Data"] = BomModel(bomRows: updatedBom, headers: []);

      print("updatedVarient map is $updatedVarient ${widget.VariantName}");

      print("start update the procument varient with new values");
      // Future.delayed(Duration(seconds: 3), () {
      ref.read(procurementVariantProvider2)[widget.VairentIndex].bomData =
          updatedVarient["BOM Data"];
      ref
          .read(procurementVariantProvider2)[widget.VairentIndex]
          .totalOperationAmount = TotalOperationAmount(operationAmount);

      ref.read(BomProcProvider.notifier).updateAction(updatedVarient, true);

      BomModel bomModel =
          ref.read(procurementVariantProvider2)[widget.VairentIndex].bomData;
      print("updated data ${bomModel.bomRows[0].amount}");
      // .updateVariant(widget.VariantName, updatedVarient);

      // print('updated boom ${ref
      //     .read(procurementVariantProvider2)[widget.VairentIndex].bomData.bomRows[0].toJson()}');
      // });

      print("end updating bom summary row");
    } catch (e) {
      print("erorr in bom summary $e");
    }
  }

//<------------------------- Function To Show Dialog Bom & Opr ----------- -------------->

  void showProcumentdialog(String endUrl, String value) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: ItemDataScreen(
                title: '',
                endUrl: endUrl,
                canGo: true,
                onDoubleClick: (Map<String, dynamic> intialData) {
                  log("intial data is $intialData");
                  _addNewRowBom(intialData["OPERATION_NAME"] ?? "", value);
                  Navigator.pop(context);
                },
              ),
            ));
  }
}
