import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/heirarchy_controller.dart';

class HierarchyDetailsList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItems = ref.watch(selectedItemProvider);
    final itemValues = ref.watch(itemValueProvider);
    return DataTable(
      headingRowColor: WidgetStateColor.resolveWith((states) {
        return const Color.fromARGB(255, 0, 52, 80);
      }),
      columns: [
        DataColumn(
          label: Text(
            'Data Type',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'Depd Field',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
      rows: selectedItems.entries.map((entry) {
        final item = entry.key;
        final isSelected = entry.value;
        final itemValue = itemValues[item] ?? '';

        return DataRow(
          cells: [
            DataCell(Text(item)), // Item
            DataCell(Text(itemValue.toString())), // Value
          ],
        );
      }).toList(),
    );
  }
}
