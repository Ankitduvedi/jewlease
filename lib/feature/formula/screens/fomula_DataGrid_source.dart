// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
//
// class formulaDataSource extends DataGridSource {
//   final BuildContext context;
//   final List<DataGridRow> dataGridRows;
//
//   // Corrected Constructor Syntax
//   formulaDataSource(this.context, this.dataGridRows);
//
//   @override
//   List<DataGridRow> get rows => dataGridRows;
//
//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//       color: const Color(0xFFFFFFFF),
//       cells: row.getCells().map<Widget>((cell) {
//         return Container(
//           alignment: Alignment.center,
//           child: TextField(
//             onSubmitted: (value) {},
//             controller: TextEditingController(
//               text: cell.value.toString(),
//             ),
//             style: TextStyle(
//               decorationColor: Colors.blue.shade900,
//             ),
//             keyboardType: TextInputType.number,
//             enabled: true,
//             decoration: InputDecoration(
//               border: InputBorder.none,
//               isDense: true,
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
