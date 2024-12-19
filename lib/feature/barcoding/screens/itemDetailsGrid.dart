import 'package:flutter/material.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class VariantDetailsGrid extends StatefulWidget {
  final List<Variant> variants;

  VariantDetailsGrid({Key? key, required this.variants}) : super(key: key);

  @override
  State<VariantDetailsGrid> createState() => _VariantDetailsGridState();
}

class _VariantDetailsGridState extends State<VariantDetailsGrid> {
  @override
  void initState() {
    super.initState();
  }

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

  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          width: screenWidth * 0.5,
          // margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            // color: Colors.red,
            border: Border.all(
              color: Colors.grey,
              width: 0.5,
            ),
            // color: const Color(0xFF002D47), // Dark blue background
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: SfDataGrid(
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.none,
            source: VariantDataSource(widget.variants),
            columns: List.generate(gridColumnName.length, (index) {
              return GridColumn(
                columnName: gridColumnName[index],
                label: _buildHeaderCell(gridColumnName[index], index),
              );
            }),
            rowHeight: 20,
            headerRowHeight: 30,
            // source: _dataGridSource,
            // controller: _dataGridController,
            footerFrozenColumnsCount: 1,
          ),
        ),
        Container(
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
            source: VariantDataSource(widget.variants),
            columns: List.generate(gridColumnName.length, (index) {
              return GridColumn(
                columnName: gridColumnName[index],
                label: _buildHeaderCell(gridColumnName[index], index),
              );
            }),
            rowHeight: 20,
            headerRowHeight: 30,
            // source: _dataGridSource,
            // controller: _dataGridController,
            footerFrozenColumnsCount: 1,
          ),
        )
      ],
    );
  }

  Widget _buildHeaderCell(String text, int index) {
    return Container(
      // padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(index == 0 ? 8.0 : 0.0),
          topRight: Radius.circular(index == 7 ? 8.0 : 0.0),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: Color(0xFF003450),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, overflow: TextOverflow.ellipsis, fontSize: 10),
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

class VariantDataSource extends DataGridSource {
  final List<DataGridRow> _dataGridRows;

  VariantDataSource(List<Variant> variants)
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
                DataGridCell(columnName: 'More', value: variant.more),
              ]),
            )
            .toList();

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFFFFFFFF), // White row background
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          // padding: const EdgeInsets.all(8.0),
          child: Text(
            cell.value.toString(),
            style: const TextStyle(
              color: Colors.black, // Text color
            ),
          ),
        );
      }).toList(),
    );
  }
}
