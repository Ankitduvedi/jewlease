import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class CustomerDataGridSource extends DataGridSource {
  CustomerDataGridSource(this.selectedIndex, {
    required this.dataGridRows,
  });

  final List<DataGridRow> dataGridRows;
  final Function(int index) selectedIndex;

  // final bool isFromSubContracting;

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        print("cell ${dataCell.value}");
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onDoubleTap: () {
                print("double tap");
                if (dataCell.columnName == 'Party Name') {
                  print("duble tap ${dataCell.value}");
                  selectedIndex(rows.indexOf(row));
                }
              },
              child: Text(
                dataCell.value,
                style: TextStyle(
                    color: dataCell.columnName == "Party Name"
                        ? Colors.blueAccent
                        : Colors.black,
                    decoration: dataCell.columnName == "Party Name"
                        ? TextDecoration.underline:TextDecoration.none
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
