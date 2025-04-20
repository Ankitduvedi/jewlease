import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/operation_model.dart';
import 'package:jewlease/feature/procument/screens/operationGridSource.dart';
import 'package:jewlease/feature/procument/screens/procumenOprGrid.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGrid.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGridSource.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
  procumentBomOprDialog(
    this.VariantName,
    this.VairentIndex,
    this.canEdit,
    this.isFromSubContracting, {
    super.key,
    this.isHorizonatal = true,
  });

  final String VariantName;
  final int VairentIndex;
  final bool canEdit;
  final bool isFromSubContracting;
  final bool isHorizonatal;

  @override
  _procumentGridState createState() => _procumentGridState();
}

class _procumentGridState extends ConsumerState<procumentBomOprDialog> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _bomRows = [];
  List<DataGridRow> OpeationRows = [];
  late procumentBomGridSource bomDataGridSource;
  late procumentOperationGridSource oprDataGridSource;
  bool isShowFormula = false;
  int selectedBomForRow = -1;

  @override
  void initState() {
    super.initState();
    initializeBomOpr();
    bomDataGridSource = procumentBomGridSource(_bomRows, _removeRow,
        _updateBomSummaryRow, showFormula, widget.canEdit, ref);
    oprDataGridSource = procumentOperationGridSource(OpeationRows, _removeRow,
        updateOperationSummeryRow, showFormula, widget.canEdit, ref);
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
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    final gridAction = ref.watch(formulaBomOprProvider);
    if (gridAction['trigger'] == true) {
      print("start updating bom from formula1");
      updateBomFromFormula(gridAction["data"]);

      print("end updating bom from formula1");
    }
    return ListView(
      scrollDirection: widget.isHorizonatal ? Axis.horizontal : Axis.vertical,
      children: [
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
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bom',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
                                        onDoubleClick:
                                            (Map<String, dynamic> intialData) {
                                          print("intial data is $intialData");
                                          _addNewRowOpr(
                                              intialData["OPERATION_NAME"] ??
                                                  "");
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
                                showProcumentdialog(materialPaths[key]!, value);
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
        if (isShowFormula)
          FormulaDataGrid(widget.VariantName, widget.VairentIndex),
        if (!isShowFormula)
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
  void showFormula(String val, int rowIndex) {
    setState(() {
      isShowFormula = !isShowFormula;
    });
    ref.read(showFormulaProvider.notifier).selectedRow(rowIndex);
    ref
        .read(formulaBomOprProvider.notifier)
        .updateAction({"variantName": widget.VariantName}, false);
  }

  //<-------------------------Function To Update Bom From Formula -------------->

  void updateBomFromFormula(Map<dynamic, dynamic> data) {
    int updatedRowIndex = ref.read(showFormulaProvider);
    double weight = _bomRows[updatedRowIndex]
        .getCells()
        .where((cell) => cell.columnName == 'Weight')
        .first
        .value;
    double updatedRate = data["data"]["Rate"];
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

  void _addNewRowOpr(String operation) {
    setState(() {
      OpeationRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Calc Bom', value: 'New Variant'),
          DataGridCell<String>(columnName: 'Operation', value: operation),
          DataGridCell<int>(columnName: 'Calc Qty', value: 0),
          DataGridCell<double>(columnName: 'Type', value: 0.0),
          DataGridCell<double>(columnName: 'Calc Method', value: 0.0),
          DataGridCell<String>(columnName: 'Calc Method Value', value: ''),
          DataGridCell<String>(columnName: 'Depd Method', value: ''),
          DataGridCell<String>(columnName: 'Depd Method Value', value: ''),
          DataGridCell<Widget>(columnName: 'Depd Type', value: null),
          DataGridCell<Widget>(columnName: 'Depd Qty', value: null),
        ]),
      );
      bomDataGridSource.updateDataGridSource();
      bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
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
      OpeationRows = [
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Calc Bom', value: ""),
          DataGridCell<String>(columnName: 'Operation', value: ""),
          DataGridCell<double>(columnName: 'Calc Qty', value: 0),
          DataGridCell<double>(columnName: 'Rate', value: 0),
          DataGridCell<double>(columnName: 'Amount', value: 0),
          DataGridCell<String>(columnName: 'Calc Method', value: ""),
        ])
      ];
    });
  }

  //<------------------------- Function To Intialize Bom &  Opr ----------- -------------->

  void initializeBomOpr() {
    if (widget.VariantName == "") {
      intializeBomOprEmpty();
      return;
    }
    Map<dynamic, dynamic>? varientData = ref
        .read(procurementVariantProvider.notifier)
        .getItemByVariant(widget.VariantName);
    print("varientData is  ${varientData}");
    List<dynamic> mapBomRows = varientData!["BOM Data"];
    List<BomRowModel> listOfBoms = mapBomRows
        .map((row) => BomRowModel.fromJson(row as Map<String, dynamic>))
        .toList();

    _bomRows = listOfBoms.map((bom) {
      print("bor row ${bom.toJson()}");
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
    if (varientData["Operation"] == null) return;
    print("operation is ${varientData!["Operation"]}");
    List<dynamic> listOfOperation = varientData!["Operation"];

    List<OperationRowModel> operationData = listOfOperation
        .map((operation) => OperationRowModel.fromJson(operation))
        .toList();
    // print("operation is $listOfOperation");
    OpeationRows = operationData.map((opr) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Calc Bom', value: opr.calcBom),
        DataGridCell<String>(columnName: 'Operation', value: opr.operation),
        DataGridCell<double>(columnName: 'Calc Qty', value: opr.calcQty),
        DataGridCell<double>(columnName: 'Rate', value: opr.labourRate),
        DataGridCell<double>(columnName: 'Amount', value: opr.labourAmount),
        DataGridCell<String>(columnName: 'Calc Method', value: opr.calcMethod),
      ]);
    }).toList();
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
    setState(() {
      double lastAmount = 0;
      for (int i = 1; i < _bomRows.length; i++) {
        lastAmount += _bomRows[i]
            .getCells()
            .firstWhere((cell) => cell.columnName == "Amount")
            .value;
      }
      print("lastAMount $lastAmount operation amount $operationTotalAmount");

      _bomRows[0] = DataGridRow(
          cells: _bomRows[0].getCells().map((cell) {
        if (cell.columnName == "Amount")
          return DataGridCell(
              columnName: cell.columnName,
              value: lastAmount + operationTotalAmount);
        else
          return cell;
      }).toList());
      Map<String, dynamic> updatedVarient = {
        "Amount": lastAmount + operationTotalAmount,
        "varientIndex": widget.VairentIndex
      };

      double updatedRate = OpeationRows[updatedRowIndex]
          .getCells()
          .firstWhere((cell) => cell.columnName == "Rate")
          .value;
      Map<dynamic, dynamic>? varientData = ref
          .read(procurementVariantProvider.notifier)
          .getItemByVariant(widget.VariantName);
      List<dynamic> listOfOperation = varientData!["Operation"];

      List<OperationRowModel> operationData = listOfOperation
          .map((operation) => OperationRowModel.fromJson(operation))
          .toList();
      operationData[updatedRowIndex].labourRate = updatedRate;
      operationData[updatedRowIndex].labourAmount = updatedRate*operationData[updatedRowIndex].calcQty;
      ref.read(procurementVariantProvider)[widget.VairentIndex]["Operation"] =
          operationData.map((row) => row.toJson()).toList();
      List<dynamic>values = _bomRows[0].getCells().map((cell)=>cell.value).toList();

      ref.read(procurementVariantProvider)[widget.VairentIndex]["BOM Data"][0] =
          BomRowModel.fromJsonDataRow(values, 0).toJson2();
      print("updated final bom ${BomRowModel.fromJsonDataRow(values, 0).toJson()}");


      ref.read(BomProcProvider.notifier).updateAction(updatedVarient, true);
    });
  }

  //<------------------------- Function To Update Bom Summary Row  ----------- -------------->

  void _updateBomSummaryRow() {
    print("start updating bom summary row");
    // int totalPcs = 0;
    double totalWt = 0.0;
    double totalRate = 0.0;
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

      totalRate += _bomRows[i].getCells()[4].value;
      totalAmount += _bomRows[i].getCells()[6].value;
      totalAVg += _bomRows[i].getCells()[5].value;
    }

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
        DataGridCell<double>(columnName: 'Amount', value: totalAmount),
        DataGridCell<String>(columnName: 'Sp Char', value: ''),
        DataGridCell<String>(columnName: 'Operation', value: ''),
        DataGridCell<String>(columnName: 'Type', value: ''),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    });
    ref.read(formulaBomOprProvider.notifier).updateAction({}, false);

    //<------------------update procumentBom------------------>
    List<String> bomHeader = [];
    _bomRows[0].getCells().forEach((element) {
      bomHeader.add(element.columnName);
    });
    List<BomRowModel> updatedBom = [];
    for (var i = 0; i < _bomRows.length; i++) {
      List<dynamic> rowValues = _bomRows[i].getCells().map((cell) {
        return cell.value;
      }).toList();
      updatedBom.add(BomRowModel.fromJsonDataRow(rowValues, i + 1));
    }
    ;

    //<------------------update procument operation------------------>
    List<String> operationHeader = [];
    // _OpeationRows[0].getCells().forEach((element) {
    //   operationHeader.add(element.columnName);
    // });
    List<List<dynamic>> updatedOperation = [];
    for (var i = 0; i < OpeationRows.length; i++) {
      updatedOperation.add(OpeationRows[i].getCells().map((cell) {
        return cell.value;
      }).toList());
    }
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
    updatedVarient["BOM Data"] = updatedBom.map((bom) => bom.toJson()).toList();
    updatedVarient["Operation"] = {
      "data": updatedOperation,
      "Headers": operationHeader
    };

    print("updatedVarient map is $updatedVarient ${widget.VariantName}");

    //<----update ui updates the procum varient with new values---->
    print("start ui updates the procum varient with new values");

    ref.read(BomProcProvider.notifier).updateAction(updatedVarient, true);

    //<----update the procument varient with new values---->
    print("start update the procument varient with new values");
    // Future.delayed(Duration(seconds: 3), () {
    ref
        .read(procurementVariantProvider.notifier)
        .updateVariant(widget.VariantName, updatedVarient);
    // });

    print("end updating bom summary row");
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
                  _updateBomSummaryRow();
                },
              ),
            ));
  }
}
