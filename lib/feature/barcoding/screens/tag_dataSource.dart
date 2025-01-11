import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../controllers/tag_list_controller.dart';

class TagDataSource extends DataGridSource {
  final List<DataGridRow> _dataGridRows;

  TagDataSource(List<TagRow> tagRows)
      : _dataGridRows = tagRows.map<DataGridRow>((tag) {
          return DataGridRow(cells: [
            DataGridCell(
              columnName: 'checkbox',
              value: Checkbox(
                value: tag.checkbox,
                onChanged: (value) {},
              ),
            ),
            DataGridCell(
                columnName: 'image',
                value: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(tag.image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            DataGridCell<String>(columnName: 'variant', value: tag.variant),
            DataGridCell<String>(columnName: 'stockCode', value: tag.stockCode),
            DataGridCell<int>(columnName: 'pcs', value: tag.pcs),
            DataGridCell<double>(columnName: 'wt', value: tag.wt),
            DataGridCell<double>(columnName: 'netWt', value: tag.netWt),
            DataGridCell<double>(columnName: 'clsWt', value: tag.clsWt),
            DataGridCell<double>(columnName: 'diaWt', value: tag.diaWt),
            DataGridCell<double>(columnName: 'stoneAmt', value: tag.stoneAmt),
            DataGridCell<double>(columnName: 'metalAmt', value: tag.metalAmt),
            DataGridCell<double>(columnName: 'wstg', value: tag.wstg),
            DataGridCell<double>(columnName: 'fixMrp', value: tag.fixMrp),
            DataGridCell<double>(columnName: 'making', value: tag.making),
            DataGridCell<double>(columnName: 'rate', value: tag.rate),
            DataGridCell<double>(columnName: 'amount', value: tag.amount),
            DataGridCell<String>(
                columnName: 'lineRemark', value: tag.lineRemark),
            DataGridCell<String>(columnName: 'huid', value: tag.huid),
            DataGridCell<String>(
                columnName: 'orderVariant', value: tag.orderVariant),
          ]);
        }).toList() {
    // Populate the dataGridRows property
    dataGridRows = _dataGridRows;
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridCell<dynamic> getCellValue(DataGridRow row, String columnName) {
    return row.getCells().firstWhere((cell) => cell.columnName == columnName);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFFFFFFFF),
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          // color: Colors.red,
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
