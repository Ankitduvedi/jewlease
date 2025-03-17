import 'package:flutter/material.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VariantDetailsGrid extends StatefulWidget {
  final List<Variant> variants;
  final List<Operation> operations;

  const VariantDetailsGrid(
      {Key? key, required this.variants, required this.operations})
      : super(key: key);

  @override
  State<VariantDetailsGrid> createState() => _VariantDetailsGridState();
}

class _VariantDetailsGridState extends State<VariantDetailsGrid> {
  List<String> gridColumnName = [
    'Id',
    'Variant',
    'Stock Code',
    'Pcs',
    'Wt',
    'Ownership',
    'Parent',
    'More'
  ];

  List<String> formulaGridColumns = [
    'Row',
    'Description',
    'Data Type',
    'Row Type',
    'Formula',
    'Range Value',
    'Editable',
    'Visible'
  ];
  List<String> oprGridColumns = [
    "Id",
    "Operation Name",
    "Operation Type",
    "Calc Qty",
    "Calc On",
    "Rate",
    "Amount",
    "More"
  ];
  @override
  void initState() {
    _addVariant();
    _addOperation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.4,
          width: screenWidth * 0.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SfDataGrid(
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.none,
            source: VariantDataSource(
                context, widget.variants, _showFormulaGrid, _showAttributeGrid),
            columns: List.generate(gridColumnName.length, (index) {
              return GridColumn(
                columnName: gridColumnName[index],
                label: _buildHeaderCell(gridColumnName[index], index),
              );
            }),
            rowHeight: 30,
            headerRowHeight: 40,
            footerFrozenColumnsCount: 1,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          height: screenHeight * 0.2,
          width: screenWidth * 0.5,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SfDataGrid(
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.none,
            source: OperationDataSource(context, widget.operations,
                _showFormulaGrid, _showAttributeGrid),
            columns: List.generate(oprGridColumns.length, (index) {
              return GridColumn(
                columnName: oprGridColumns[index],
                label: _buildHeaderCell(oprGridColumns[index], index),
              );
            }),
            rowHeight: 30,
            headerRowHeight: 40,
            footerFrozenColumnsCount: 1,
          ),
        ),
        // ElevatedButton(
        //   onPressed: _addVariant,
        //   child: Text('Add New Variant'),
        // )
      ],
    );
  }

  void _addVariant() {
    // Logic to add a new variant
    setState(() {
      widget.variants.add(Variant(
        id: '54790',
        variant: 'GL-18 KT-Y',
        stockCode: '-',
        pcs: '0',
        wt: '3.831',
        ownership: '-',
        parent: '-',
        more: '',
      ));
    });
  }

  void _addOperation() {
    setState(() {
      widget.operations.add(Operation(
        id: 1,
        operationName: 'GL-18 KT-Y',
        operationType: 'Add',
        calcQty: 1,
        calcOn: 'PCS',
        rate: 100,
        amount: 100,
        more: '',
      ));
    });
  }

  void _showFormulaGrid(BuildContext context, Offset buttonPosition) {
    // Default values for the formula grid
    final defaultRows = [
      {
        "Row": 1,
        "Description": "METAL RATE",
        "Data Type": "Amount",
        "Row Type": "",
        "Formula": "",
        "Range Value": "",
        "Editable": "1",
        "Visible": "1",
      },
      {
        "Row": 2,
        "Description": "METAL RATE",
        "Data Type": "Metal Fineness",
        "Row Type": "",
        "Formula": "",
        "Range Value": "",
        "Editable": "",
        "Visible": "1",
      },
      {
        "Row": 3,
        "Description": "WASTAGE %",
        "Data Type": "Range",
        "Row Type": "WASTAGE_PER",
        "Formula": "",
        "Range Value": "18 dec2",
        "Editable": "1",
        "Visible": "1",
      },
      {
        "Row": 4,
        "Description": "METAL LOSS",
        "Data Type": "Calculation",
        "Row Type": "Loss %",
        "Formula": "[R3]/100",
        "Range Value": "",
        "Editable": "",
        "Visible": "1",
      },
      {
        "Row": 5,
        "Description": "METAL LOSS AMOUNT",
        "Data Type": "Calculation",
        "Row Type": "GOLD-LOSS",
        "Formula": "[R2]+[R4]",
        "Range Value": "",
        "Editable": "",
        "Visible": "1",
      },
      {
        "Row": 6,
        "Description": "ADJUSTED AMOUNT",
        "Data Type": "Adjusted Amount",
        "Row Type": "",
        "Formula": "",
        "Range Value": "",
        "Editable": "",
        "Visible": "1",
      },
      {
        "Row": 7,
        "Description": "Metal Rate",
        "Data Type": "Total",
        "Row Type": "",
        "Formula": "[R1]",
        "Range Value": "",
        "Editable": "",
        "Visible": "1",
      },
    ];

    final int rowCount = defaultRows.length;
    const double rowHeight = 25.0;
    const double headerHeight = 35.0;
    const double maxDialogHeight = 300.0; // Maximum height for the dialog
    const double additionalPadding = 80.0; // Space for header, padding, etc.

    final double calculatedHeight =
        (rowCount * rowHeight) + headerHeight + additionalPadding;

    final double dialogHeight = calculatedHeight;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                left: buttonPosition.dx,
                top: buttonPosition.dy,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: dialogHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Formula Details'),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Formula Grid
                        Expanded(
                          child: SfDataGrid(
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.none,
                            source: FormulaDataSource(defaultRows),
                            columns: List.generate(formulaGridColumns.length,
                                (index) {
                              return GridColumn(
                                columnName: formulaGridColumns[index],
                                label: _buildHeaderCell(
                                    formulaGridColumns[index], index),
                              );
                            }),
                            rowHeight: rowHeight,
                            headerRowHeight: headerHeight,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAttributeGrid(BuildContext context, Offset buttonPosition) {
    final attributeData = [
      {
        "Type": "HSN - SAC CODE",
        "Desc": "710813",
        "Belonging": "Master",
      },
      {
        "Type": "KARAT",
        "Desc": "18 KT",
        "Belonging": "Variant",
      },
      {
        "Type": "METAL COLOR",
        "Desc": "YELLOW",
        "Belonging": "Variant",
      },
    ];

    final attributeGridColumns = ['Type', 'Desc', 'Belonging'];

    // Calculate dynamic height for the dialog
    final int rowCount = attributeData.length;
    const double rowHeight = 35.0;
    const double headerHeight = 35.0;
    const double additionalPadding = 80.0; // Space for header, padding, etc.
    final double dialogHeight =
        (rowCount * rowHeight) + headerHeight + additionalPadding;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Close",
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                left: buttonPosition.dx,
                top: buttonPosition.dy,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: dialogHeight, // Dynamic height
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Attribute Details'),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        // Attribute Grid
                        Expanded(
                          child: SfDataGrid(
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.none,
                            source: AttributeDataSource(attributeData),
                            columns: List.generate(attributeGridColumns.length,
                                (index) {
                              return GridColumn(
                                width:
                                    MediaQuery.of(context).size.width * 0.5 / 3,
                                columnName: attributeGridColumns[index],
                                label: _buildHeaderCell(
                                    attributeGridColumns[index], index),
                              );
                            }),
                            rowHeight: rowHeight,
                            headerRowHeight: headerHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCell(String text, int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(index == 0 ? 8.0 : 0.0),
          topRight:
              Radius.circular(index == gridColumnName.length - 1 ? 8.0 : 0.0),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: const Color(0xFF003450),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          overflow: TextOverflow.ellipsis,
          fontSize: 10,
        ),
      ),
    );
  }
}

class Variant {
  final String id;
  final String variant;
  final String stockCode;
  final String pcs;
  final String wt;
  final String ownership;
  final String parent;
  final String more;

  Variant({
    required this.id,
    required this.variant,
    required this.stockCode,
    required this.pcs,
    required this.wt,
    required this.ownership,
    required this.parent,
    required this.more,
  });
}

class Operation {
  final int id;
  final String operationName;
  final String operationType;
  final double calcQty;
  final String calcOn;
  final double rate;
  final double amount;
  final String more;

  Operation({
    required this.id,
    required this.operationName,
    required this.operationType,
    required this.calcQty,
    required this.calcOn,
    required this.rate,
    required this.amount,
    required this.more,
  });
}

class VariantDataSource extends DataGridSource {
  final BuildContext context;
  final List<DataGridRow> _dataGridRows;
  final Function(BuildContext, Offset) showFormulaGrid;
  final Function(BuildContext, Offset) showAttributeGrid;

  VariantDataSource(this.context, List<Variant> variants, this.showFormulaGrid,
      this.showAttributeGrid)
      : _dataGridRows = variants
            .map<DataGridRow>(
              (variant) => DataGridRow(cells: [
                DataGridCell(columnName: 'Id', value: variant.id),
                DataGridCell(columnName: 'Variant', value: variant.variant),
                DataGridCell(columnName: 'StockCode', value: variant.stockCode),
                DataGridCell(columnName: 'Pcs', value: variant.pcs),
                DataGridCell(columnName: 'Wt', value: variant.wt),
                DataGridCell(columnName: 'Ownership', value: variant.ownership),
                DataGridCell(columnName: 'Parent', value: variant.parent),
                DataGridCell(
                  columnName: 'More',
                  value: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "Formula") {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final position = renderBox.localToGlobal(Offset.zero);
                        showFormulaGrid(context, position);
                      } else if (value == "Attribute") {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final position = renderBox.localToGlobal(Offset.zero);
                        // Handle Attribute logic here
                        showAttributeGrid(context, position);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "Attribute",
                        child: Text("Attribute"),
                      ),
                      const PopupMenuItem(
                        value: "Formula",
                        child: Text("Formula"),
                      ),
                    ],
                    child: const Icon(Icons.more_vert), // "More" button icon
                  ),
                ),
              ]),
            )
            .toList();

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFFFFFFFF),
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          child: cell.value is Widget
              ? cell.value
              : Text(
                  cell.value.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
        );
      }).toList(),
    );
  }
}

class OperationDataSource extends DataGridSource {
  final BuildContext context;
  final List<DataGridRow> _dataGridRows;
  final Function(BuildContext, Offset) showFormulaGrid;
  final Function(BuildContext, Offset) showAttributeGrid;

  // Constructor for OperationDataSource
  OperationDataSource(this.context, List<Operation> operations,
      this.showFormulaGrid, this.showAttributeGrid)
      : _dataGridRows = operations
            .map<DataGridRow>(
              (operation) => DataGridRow(cells: [
                DataGridCell(columnName: 'Id', value: operation.id),
                DataGridCell(
                    columnName: 'Operation Name',
                    value: operation.operationName),
                DataGridCell(
                    columnName: 'Operation Type',
                    value: operation.operationType),
                DataGridCell(columnName: 'Calc Qty', value: operation.calcQty),
                DataGridCell(columnName: 'Calc On', value: operation.calcOn),
                DataGridCell(columnName: 'Rate', value: operation.rate),
                DataGridCell(columnName: 'Amount', value: operation.amount),
                DataGridCell(
                  columnName: 'More',
                  value: PopupMenuButton<String>(
                    onSelected: (value) {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final position = renderBox.localToGlobal(Offset.zero);
                      showFormulaGrid(context, position);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "Formula",
                        child: Text("Formula"),
                      ),
                    ],
                    child: const Icon(Icons.more_vert), // "More" button icon
                  ),
                ),
              ]),
            )
            .toList();

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFFFFFFFF),
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          child: cell.value is Widget
              ? cell.value
              : Text(
                  cell.value.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
        );
      }).toList(),
    );
  }
}

class FormulaDataSource extends DataGridSource {
  final List<DataGridRow> _dataGridRows;

  FormulaDataSource(List<Map<String, dynamic>> formulas)
      : _dataGridRows = formulas
            .map<DataGridRow>((formula) => DataGridRow(cells: [
                  DataGridCell(columnName: 'Row', value: formula['Row']),
                  DataGridCell(
                      columnName: 'Description', value: formula['Description']),
                  DataGridCell(
                      columnName: 'Data Type', value: formula['Data Type']),
                  DataGridCell(
                      columnName: 'Row Type', value: formula['Row Type']),
                  DataGridCell(
                      columnName: 'Formula', value: formula['Formula']),
                  DataGridCell(
                      columnName: 'Range Value', value: formula['Range Value']),
                  DataGridCell(
                      columnName: 'Editable', value: formula['Editable']),
                  DataGridCell(
                      columnName: 'Visible', value: formula['Visible']),
                ]))
            .toList();

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFFFFFFFF),
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          child: Text(
            cell.value.toString(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class AttributeDataSource extends DataGridSource {
  List<DataGridRow> _rows = [];

  AttributeDataSource(List<Map<String, dynamic>> data) {
    _rows = data
        .map((item) => DataGridRow(cells: [
              DataGridCell(columnName: 'Type', value: item['Type']),
              DataGridCell(columnName: 'Desc', value: item['Desc']),
              DataGridCell(columnName: 'Belonging', value: item['Belonging']),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }
}

// Helper to build header cells
Widget _buildHeaderCell(String columnName) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(8),
    child: Text(
      columnName,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}
