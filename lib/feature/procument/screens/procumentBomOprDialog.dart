import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  procumentBomOprDialog(this.VarientName, this.VairentIndex, this.canEdit,
      this.isFromSubContracting,
      {super.key});

  final String VarientName;
  final int VairentIndex;
  final bool canEdit;
  final bool isFromSubContracting;

  @override
  _procumentGridState createState() => _procumentGridState();
}

class _procumentGridState extends ConsumerState<procumentBomOprDialog> {
  final DataGridController _dataGridController = DataGridController();
  List<DataGridRow> _bomRows = [];
  List<DataGridRow> _OpeationRows = [];
  late procumentBomGridSource _bomDataGridSource;
  late procumentBomGridSource _oprDataGridSource;
  bool isShowFormula = false;
  int selectedBomForRow = -1;

  @override
  void initState() {
    super.initState();
    initializeBomOpr();
    _bomDataGridSource = procumentBomGridSource(_bomRows, _removeRow,
        _updateBomSummaryRow, showFormula, widget.canEdit);
    _oprDataGridSource = procumentBomGridSource(_OpeationRows, _removeRow,
        _updateBomSummaryRow, showFormula, widget.canEdit);
  }

  void showRawMaterialDialog(String value) {
    showDialog(
      context: context,
      builder: (context1) => ItemTypeDialogScreen(
        title: 'Outward Stock',
        endUrl: 'SubContracting/IssueWork',
        value: 'Stock ID',
        queryMap: value.contains("Stone")
            ? {"isRawMaterial": 1,"Variant Type": "Gold"}
            : {"isRawMaterial": 1, "Varient Type": "Diamond"},
        onOptionSelectd: (selectedValue) {
          print("selected value $selectedValue");
        },
        onSelectdRow: (selectedRow) {
          print("dialog");
          print("selected raw material row $selectedRow");
          selectedRow["styleVariant"] = widget.VarientName;
          selectedRow["rowNo"] = _bomRows.length + 1;
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
      // print("gridactions ${gridAction}");
      updateBomFromFormula(gridAction["data"]);

      print("end updating bom from formula1");
    }
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              width: screenWidth * 0.45,
              // height: screenHeight * 0.4,
              margin: EdgeInsets.only(top: 20, left: 20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.white,
              ),
              // height: screenHeight * 0.5,
              // width: screenWidth * 0.,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Header Row

                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                                              print(
                                                  "intial data is $intialData");
                                              _addNewRowOpr(intialData[
                                                      "OPERATION_NAME"] ??
                                                  "");
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ));
                              },
                              child: Text('+ Add Operation',
                                  style: TextStyle(color: Color(0xff28713E))),
                            ),
                            // Inside the build method, replace the "+ Add Bom" button with a PopupMenuButton:
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                // When an item is selected, add a new row with the item group
                                log("choosen Item $value");
                                if (widget.canEdit == false) return;

                                if (widget.isFromSubContracting) {
                                  showRawMaterialDialog(value);
                                } else {
                                  if (value.contains('Gold')) {
                                    showProcumentdialog(
                                        "ItemMasterAndVariants/Metal/Gold/Variant/",
                                        value);
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
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  bomPopUpItem(),
                              child: TextButton(
                                onPressed: null,
                                child: Text(
                                  '+ Add Bom',
                                  style: TextStyle(color: Color(0xff28713E)),
                                ),
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
                    bomDataGridSource: _bomDataGridSource,
                    dataGridController: _dataGridController,
                    gridWidth: gridWidth,
                  )
                ],
              ),
            ),
          ),
          if (isShowFormula)
            FormulaDataGrid(widget.VarientName, widget.VairentIndex),
          if (!isShowFormula)
            Expanded(
              child: ProcumentOperationGrid(
                  operationType: 'Operation',
                  gridWidth: gridWidth,
                  dataGridController: _dataGridController,
                  oprDataGridSource: _oprDataGridSource),
            )
        ],
      ),
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
    print("selected row is $rowIndex");
    ref.read(showFormulaProvider.notifier).selectedRow(rowIndex);
    ref
        .read(formulaBomOprProvider.notifier)
        .updateAction({"varientName": widget.VarientName}, false);
  }

  //<-------------------------Function To Update Bom From Formula -------------->

  void updateBomFromFormula(Map<dynamic, dynamic> data) {
    print("start updating bom from formula");
    int updatedRowIndex = ref.read(showFormulaProvider);
    double rate = _bomRows[updatedRowIndex]
            .getCells()
            .where((cell) => cell.columnName == 'Rate')
            .first
            .value *
        1.0;
    double weight = _bomRows[updatedRowIndex]
            .getCells()
            .where((cell) => cell.columnName == 'Weight')
            .first
            .value *
        1.0;
    print("updated Amount ${rate * weight}");
    _bomRows[updatedRowIndex] = DataGridRow(
        cells: _bomRows[updatedRowIndex].getCells().map((cell) {
      if (cell.columnName == 'Rate')
        return DataGridCell(
            columnName: 'Rate'.toString(), value: data["data"]["Rate"]);
      else if (cell.columnName == 'Amount') {
        return DataGridCell(
            columnName: 'Amount'.toString(),
            value: data["data"]["Rate"] * weight);
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
          .getItemByVariant(widget.VarientName);
      print("varientData is $varientData");
      _bomRows.add(
        DataGridRow(cells: [
          DataGridCell<String>(columnName: 'Variant Name', value: variantName),
          DataGridCell<String>(columnName: 'Item Group', value: itemGroup),
          DataGridCell<int>(
              columnName: 'Pieces',
              value: itemGroup.contains('Diamond') ? 1 : 0),
          DataGridCell<double>(columnName: 'Weight', value: 0.0),
          DataGridCell(columnName: 'Rate', value: 0.0),
          DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
          DataGridCell(columnName: 'Amount', value: 0),
          DataGridCell<String>(columnName: 'Sp Char', value: ''),
          DataGridCell<String>(columnName: 'Operation', value: ''),
          DataGridCell<String>(columnName: 'Type', value: ''),
          DataGridCell<Widget>(columnName: 'Actions', value: null),
        ]),
      );
      _bomDataGridSource.updateDataGridSource();
      _bomDataGridSource.updateDataGridSource();
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
              value: rawMaterialData["Varient Name"]),
          DataGridCell<String>(columnName: 'Item Group', value: itemGroup),
          DataGridCell<int>(
              columnName: 'Pieces',
              value: rawMaterialData['Dia Pieces'] == 0
                  ? 0
                  : rawMaterialData['Dia Pieces']),
          DataGridCell<double>(
              columnName: 'Weight',
              value: double.parse(rawMaterialData["Net Weight"])),
          DataGridCell(columnName: 'Rate', value: 0.0),
          DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: 0.0),
          DataGridCell(columnName: 'Amount', value: 0),
          DataGridCell<String>(columnName: 'Sp Char', value: ''),
          DataGridCell<String>(columnName: 'Operation', value: ''),
          DataGridCell<String>(columnName: 'Type', value: ''),
          DataGridCell<Widget>(columnName: 'Actions', value: null),
        ]),
      );
      _bomDataGridSource.updateDataGridSource();
      _bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Function To Add New Opr ----------- -------------->

  void _addNewRowOpr(String operation) {
    setState(() {
      _OpeationRows.add(
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
      _bomDataGridSource.updateDataGridSource();
      _bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Function To Intialize Bom &  Opr ----------- -------------->

  void initializeBomOpr() {
    print("widget.VarientName ${widget.VarientName}");
    Map<dynamic, dynamic>? varientData = ref
        .read(procurementVariantProvider.notifier)
        .getItemByVariant(widget.VarientName);
    print("varient Data");
    print("varientData is  ${varientData}");
    List<dynamic> listOfBoms = varientData!["BOM"]["data"];

    _bomRows = listOfBoms.map((bom) {
      print("bom is ${bom[2]}${bom[2].runtimeType}");
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: bom[0]),
        DataGridCell<String>(columnName: 'Item Group', value: bom[1]),
        DataGridCell(columnName: 'Pieces', value: bom[2]),
        DataGridCell(columnName: 'Weight', value: bom[3] * 1.0),
        DataGridCell(columnName: 'Rate', value: bom[4]),
        DataGridCell<double>(columnName: 'Avg Wt(Pcs)', value: bom[5] * 1.0),
        DataGridCell(columnName: 'Amount', value: bom[6]),
        DataGridCell<String>(columnName: 'Sp Char', value: bom[7]),
        DataGridCell<String>(columnName: 'Operation', value: bom[8]),
        DataGridCell<String>(columnName: 'Type', value: bom[9]),
        DataGridCell<Widget>(columnName: 'Actions', value: null),
      ]);
    }).toList();
    if (varientData["Operation"] == null) return;
    List<dynamic> listOfOperation = varientData!["Operation"]["data"];
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
  }

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
    print("start updating bom summary row");
    int totalPcs = 0;
    double totalWt = 0.0;
    double totalRate = 0.0;
    double totalAmount = 0.0;

    for (var i = 1; i < _bomRows.length; i++) {
      var tPcs = _bomRows[i].getCells()[2].value;

      if (tPcs is double) {
        totalPcs += tPcs.toInt(); // Convert to int
      } else if (tPcs is int) {
        totalPcs += tPcs; // Directly assign if already an int
      } else {
        totalPcs += 1; // Default or handle unexpected types
      }

      totalWt += _bomRows[i].getCells()[3].value ?? 0 * 1.0 as double;
      totalRate += _bomRows[i].getCells()[4].value ?? 0 * 1.0 as double;
      totalAmount += _bomRows[i].getCells()[6].value ?? 0.0 as double;
    }

    double avgWtPcs = totalPcs > 0 ? totalWt / totalPcs : 0.0;

    setState(() {
      _bomRows[0] = DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Variant Name', value: 'Summary'),
        DataGridCell<String>(columnName: 'Item Group', value: ''),
        DataGridCell<int>(columnName: 'Pieces', value: 1),
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
    ref.read(formulaBomOprProvider.notifier).updateAction({}, false);

    //<------------------update procumentBom------------------>
    List<String> bomHeader = [];
    _bomRows[0].getCells().forEach((element) {
      bomHeader.add(element.columnName);
    });
    List<List<dynamic>> updatedBom = [];
    for (var i = 0; i < _bomRows.length; i++) {
      updatedBom.add(_bomRows[i].getCells().map((cell) {
        return cell.value;
      }).toList());
    }

    //<------------------update procument operation------------------>
    List<String> operationHeader = [];
    _OpeationRows[0].getCells().forEach((element) {
      operationHeader.add(element.columnName);
    });
    List<List<dynamic>> updatedOperation = [];
    for (var i = 0; i < _OpeationRows.length; i++) {
      updatedOperation.add(_OpeationRows[i].getCells().map((cell) {
        return cell.value;
      }).toList());
    }
    //<------------------updatin the varient after updating bom summery row------------------>
    Map<String, dynamic> updatedVarient = Map.fromIterable(
      _bomRows[0].getCells(),
      key: (cell) => "${cell.columnName}",
      value: (cell) => cell.value,
    );
    double stoneWeight = 0;
    double stonePieces = 0;
    for (var row in _bomRows) {
      if (row.getCells()[1].value.contains('Diamond')) {
        stoneWeight += row.getCells()[3].value;
        stonePieces += row.getCells()[2].value * 1.0;
      }
      print("stone pieces ${row.getCells()[2].value}");
    }
    print("updated stone weight is ${stoneWeight} $stonePieces");
    if (stoneWeight != 0) updatedVarient["Stone Wt"] = stoneWeight;
    updatedVarient["Stone Pieces"] = stonePieces;
    updatedVarient["varientIndex"] = widget.VairentIndex;
    updatedVarient["Variant Name"] = widget.VarientName;
    updatedVarient["BOM"] = {"data": updatedBom, "Headers": bomHeader};
    updatedVarient["Operation"] = {
      "data": updatedOperation,
      "Headers": operationHeader
    };

    print("updatedVarient map is $updatedVarient ${widget.VarientName}");

    //<----update ui updates the procum varient with new values---->
    print("start ui updates the procum varient with new values");

    ref.read(BomProcProvider.notifier).updateAction(updatedVarient, true);

    //<----update the procument varient with new values---->
    print("start update the procument varient with new values");
    // Future.delayed(Duration(seconds: 3), () {
    ref
        .read(procurementVariantProvider.notifier)
        .updateVariant(widget.VarientName, updatedVarient);
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
