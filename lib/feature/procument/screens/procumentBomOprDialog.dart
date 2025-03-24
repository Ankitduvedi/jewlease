import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/procument/screens/formulaGrid.dart';
import 'package:jewlease/feature/procument/screens/procumenOprGrid.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGrid.dart';
import 'package:jewlease/feature/procument/screens/procumentBomGridSource.dart';
import 'package:jewlease/feature/vendor/controller/procumentVendor_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/data_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

// Separate models for better organization
class BomRow {
  final String variantName;
  final String itemGroup;
  final int pieces;
  final double weight;
  final double rate;
  final double avgWeight;
  final double amount;

  const BomRow({
    required this.variantName,
    required this.itemGroup,
    this.pieces = 0,
    this.weight = 0.0,
    this.rate = 0.0,
    this.avgWeight = 0.0,
    this.amount = 0.0,
  });

  factory BomRow.fromMap(Map<String, dynamic> data) {
    return BomRow(
      variantName: data['Variant Name'] ?? '',
      itemGroup: data['Item Group'] ?? '',
      pieces: data['Pieces'] ?? 0,
      weight: (data['Weight'] ?? 0.0).toDouble(),
      rate: (data['Rate'] ?? 0.0).toDouble(),
      avgWeight: (data['Avg Wt(Pcs)'] ?? 0.0).toDouble(),
      amount: (data['Amount'] ?? 0.0).toDouble(),
    );
  }
}

class OperationRow {
  final String calcBom;
  final String operation;
  final int calcQty;
  final int type;
  final int calcMethod;

  const OperationRow({
    required this.calcBom,
    required this.operation,
    this.calcQty = 0,
    this.type = 0,
    this.calcMethod = 0,
  });

  factory OperationRow.fromMap(Map<String, dynamic> data) {
    return OperationRow(
      calcBom: data['Calc Bom'] ?? '',
      operation: data['Operation'] ?? '',
      calcQty: data['Calc Qty'] ?? 0,
      type: data['Type'] ?? 0,
      calcMethod: data['Calc Method'] ?? 0,
    );
  }
}

// Enum for material types to improve type safety
enum MaterialType {
  gold(path: 'ItemMasterAndVariants/Metal/Gold/Variant/'),
  silver(path: 'ItemMasterAndVariants/Metal/Silver/Variant/'),
  diamond(path: 'ItemMasterAndVariants/Stone/Diamond/Variant/'),
  bronze(path: 'ItemMasterAndVariants/Metal/Bronze/Variant/');

  final String path;
  const MaterialType({required this.path});
}

class ProcurementBomDialog extends ConsumerStatefulWidget {
  final String variantName;
  final int variantIndex;
  final bool canEdit;
  final bool isFromSubContracting;
  final bool isHorizontal;

  const ProcurementBomDialog({
    super.key,
    required this.variantName,
    required this.variantIndex,
    this.canEdit = true,
    this.isFromSubContracting = false,
    this.isHorizontal = true,
  });

  @override
  ProcurementBomDialogState createState() => ProcurementBomDialogState();
}

class ProcurementBomDialogState extends ConsumerState<ProcurementBomDialog> {
  final _dataGridController = DataGridController();
  late ProcurementBomGridSource _bomDataGridSource;
  late ProcurementBomGridSource _oprDataGridSource;

  List<BomRow> _bomRows = [];
  List<OperationRow> _operationRows = [];
  double gridWidth = screenWidth * 0.4;

  final bool _isShowFormula = false;

  @override
  @override
  void initState() {
    super.initState();
    _initializeBomAndOperations();

    // Convert BomRows to DataGridRows
    final bomDataGridRows = _bomRows
        .map((bomRow) => DataGridRow(cells: [
              DataGridCell(
                  columnName: 'Variant Name', value: bomRow.variantName),
              DataGridCell(columnName: 'Item Group', value: bomRow.itemGroup),
              DataGridCell(columnName: 'Pieces', value: bomRow.pieces),
              DataGridCell(columnName: 'Weight', value: bomRow.weight),
              DataGridCell(columnName: 'Rate', value: bomRow.rate),
              DataGridCell(columnName: 'Avg Wt(Pcs)', value: bomRow.avgWeight),
              DataGridCell(columnName: 'Amount', value: bomRow.amount),
              const DataGridCell(
                  columnName: 'Actions', value: null), // Add Actions cell
            ]))
        .toList();

    // Convert OperationRows to DataGridRows
    final operationDataGridRows = _operationRows
        .map((operationRow) => DataGridRow(cells: [
              DataGridCell(columnName: 'Calc Bom', value: operationRow.calcBom),
              DataGridCell(
                  columnName: 'Operation', value: operationRow.operation),
              DataGridCell(columnName: 'Calc Qty', value: operationRow.calcQty),
              DataGridCell(columnName: 'Type', value: operationRow.type),
              DataGridCell(
                  columnName: 'Calc Method', value: operationRow.calcMethod),
              const DataGridCell(
                  columnName: 'Actions', value: null), // Add Actions cell
            ]))
        .toList();

    // Initialize the grid sources
    _bomDataGridSource = ProcurementBomGridSource(
        dataGridRows: bomDataGridRows,
        onDelete: (row) {
          // Implement delete logic
        },
        onEdit: () {
          _updateBomSummary();
        },
        showFormulaDialog: (itemGroup, rowIndex) {
          // Implement show formula dialog logic
        },
        ref: ref,
        canEdit: widget.canEdit);

    _oprDataGridSource = ProcurementBomGridSource(
        dataGridRows: operationDataGridRows,
        onDelete: (row) {
          // Implement delete logic for operations
        },
        onEdit: () {
          // Implement edit logic for operations
        },
        showFormulaDialog: (itemGroup, rowIndex) {
          // Implement show formula dialog logic for operations
        },
        ref: ref,
        canEdit: widget.canEdit);
  }

  void _initializeBomAndOperations() {
    // Refactored initialization logic
    final variantData = ref
        .read(procurementVariantProvider.notifier)
        .getItemByVariant(widget.variantName);

    if (variantData == null) {
      _createEmptyRows();
      return;
    }

    _bomRows = (variantData['BOM']['data'] as List)
        .map((bom) => BomRow.fromMap({
              'Variant Name': bom[0],
              'Item Group': bom[1],
              'Pieces': bom[2],
              'Weight': bom[3],
              'Rate': bom[4],
              'Avg Wt(Pcs)': bom[5],
              'Amount': bom[6],
            }))
        .toList();

    _operationRows = (variantData['Operation']['data'] as List)
        .map((opr) => OperationRow.fromMap({
              'Calc Bom': opr[0],
              'Operation': opr[1],
              'Calc Qty': opr[2],
              'Type': opr[3],
              'Calc Method': opr[4],
            }))
        .toList();
  }

  void _createEmptyRows() {
    _bomRows = [
      const BomRow(
        variantName: 'Summary',
        itemGroup: '',
        pieces: 1,
      )
    ];
    _operationRows = [
      const OperationRow(
        calcBom: '',
        operation: '',
      )
    ];
  }

  // Optimized method for calculating summary
  BomRow _calculateBomSummary() {
    final summary = _bomRows.skip(1).fold(
      const BomRow(variantName: 'Summary', itemGroup: ''),
      (acc, row) {
        final isMetalRow = row.itemGroup.contains('Metal');
        return BomRow(
          variantName: 'Summary',
          itemGroup: '',
          pieces: acc.pieces,
          weight: acc.weight + (isMetalRow ? row.weight : row.weight * 0.2),
          rate: acc.rate + row.rate,
          amount: acc.amount + row.amount,
          avgWeight: acc.avgWeight + row.avgWeight,
        );
      },
    );

    return summary;
  }

  void _showMaterialDialog(MaterialType materialType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ItemDataScreen(
          title: '',
          endUrl: materialType.path,
          canGo: true,
          onDoubleClick: (data) {
            log("Material Type: ${materialType.toString()}");
            log("Raw Material Data: $data");

            // Adjust the key to match your actual data structure
            final variantName =
                data['Metal Variant Name'] ?? data['Variant Name'] ?? '';

            log("Variant Name from Data: $variantName");

            _addBomRow(variantName,
                materialType.toString().split('.').last.toUpperCase());
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _addBomRow(String variantName, String itemGroup) {
    setState(() {
      // Add the new BOM row
      _bomRows.add(
        BomRow(
          variantName: variantName,
          itemGroup: itemGroup,
          pieces: itemGroup.contains('Diamond') ? 1 : 0,
        ),
      );

      // Convert the new row to a DataGridRow
      final newDataGridRow = DataGridRow(cells: [
        DataGridCell(columnName: 'Variant Name', value: variantName),
        DataGridCell(columnName: 'Item Group', value: itemGroup),
        const DataGridCell(columnName: 'Pieces', value: 0),
        const DataGridCell(columnName: 'Weight', value: 0.0),
        const DataGridCell(columnName: 'Rate', value: 0.0),
        const DataGridCell(columnName: 'Avg Wt(Pcs)', value: 0.0),
        const DataGridCell(columnName: 'Amount', value: 0.0),
        const DataGridCell(columnName: 'Actions', value: null),
      ]);

      // Add the new DataGridRow to the DataGrid source
      _bomDataGridSource.rows.add(newDataGridRow);

      // Notify the DataGrid source of changes
      _bomDataGridSource.updateDataGridSource();

      // Update the summary
      _updateBomSummary();
    });
  }

  void _updateBomSummary() {
    if (_bomRows.length > 1) {
      final summaryRow = _calculateBomSummary();
      setState(() {
        _bomRows[0] = summaryRow;
      });

      // Trigger variant update
      _updateVariantData();
    }
  }

  void _updateVariantData() {
    final updatedVariant = {
      'Variant Name': widget.variantName,
      'varientIndex': widget.variantIndex,
      // Add other necessary fields
    };

    ref
        .read(procurementVariantProvider.notifier)
        .updateVariant(widget.variantName, updatedVariant);
  }

  @override
  Widget build(BuildContext context) {
    log("Building ProcurementBomDialog");
    return _buildLayout();
  }

  Widget _buildLayout() {
    return widget.isHorizontal
        ? _buildHorizontalLayout()
        : _buildVerticalLayout();
  }

  Widget _buildHorizontalLayout() {
    return Row(
      children: [
        _buildBomSection(),
        if (_isShowFormula)
          FormulaDataGrid(widget.variantName, widget.variantIndex),
        if (!_isShowFormula) _buildOperationSection(),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      children: [
        _buildBomSection(),
        if (_isShowFormula)
          FormulaDataGrid(widget.variantName, widget.variantIndex),
        if (!_isShowFormula) _buildOperationSection(),
      ],
    );
  }

  Widget _buildBomSection() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            _buildBomHeader(),
            ProcumentBomGrid(
              bomDataGridSource: _bomDataGridSource,
              dataGridController: _dataGridController,
              gridWidth: gridWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBomHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'BOM',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        _buildAddOperationButton(),
        _buildAddBomButton(),
        _buildSummaryButton(),
      ],
    );
  }

  Widget _buildAddOperationButton() {
    return TextButton(
      onPressed: widget.canEdit ? () => _showOperationDialog() : null,
      child: const Text(
        '+ Add Operation',
        style: TextStyle(color: Color(0xff28713E)),
      ),
    );
  }

  Widget _buildAddBomButton() {
    return PopupMenuButton<MaterialType>(
      onSelected: (materialType) => _showMaterialDialog(materialType),
      itemBuilder: (_) => MaterialType.values
          .map((type) => PopupMenuItem(
                value: type,
                child: Text(type.toString().split('.').last),
              ))
          .toList(),
      child: const Text('+ Add BOM'),
    );
  }

  Widget _buildSummaryButton() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        'Summary',
        style: TextStyle(color: Color(0xff28713E)),
      ),
    );
  }

  Widget _buildOperationSection() {
    return Expanded(
      child: ProcumentOperationGrid(
        operationType: 'Operation',
        dataGridController: _dataGridController,
        oprDataGridSource: _oprDataGridSource,
        gridWidth: gridWidth,
      ),
    );
  }

  void _showOperationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ItemDataScreen(
          title: '',
          endUrl: 'Global/operations/',
          canGo: true,
          onDoubleClick: (data) {
            _addOperationRow(data['OPERATION_NAME'] ?? '');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _addOperationRow(String operation) {
    setState(() {
      _operationRows.add(
        OperationRow(
          calcBom: 'New Variant',
          operation: operation,
        ),
      );
    });
  }
}
