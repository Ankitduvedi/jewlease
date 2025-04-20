import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/heirarchy_controller.dart';

class HierarchyDetailsList extends ConsumerWidget {
  const HierarchyDetailsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the itemListProvider to get the map with keys and lists of values
    final itemMap = ref.watch(itemListProvider);

    return SingleChildScrollView(
      child: DataTable(
        headingRowColor: MaterialStateColor.resolveWith((states) {
          return const Color.fromARGB(255, 0, 52, 80);
        }),
        columns: const [
          DataColumn(
            label: Text(
              'Key',
              style: TextStyle(color: Colors.white),
            ),
          ),
          DataColumn(
            label: Text(
              'Value',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        // Creating rows for each key-value pair in itemMap
        rows: itemMap.entries.expand((entry) {
          print("entry is $entry $itemMap");
          final key = entry.key;
          final values = entry.value;

          // Create a row for each value associated with the key
          return values.map((value) {
            return DataRow(
              cells: [
                DataCell(Text(key)), // Key in the first cell
                DataCell(Text(value)), // Individual value in the second cell
              ],
            );
          });
        }).toList(),
      ),
    );
  }
}
