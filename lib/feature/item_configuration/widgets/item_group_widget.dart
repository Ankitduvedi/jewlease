import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class ItemGroupDialogScreen extends ConsumerWidget {
  const ItemGroupDialogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemDataAsyncValue = ref.watch(itemGroupFutureProvider);
    final selectedItem = ref.watch(dialogSelectionProvider);

    return Dialog(
      child: Column(
        children: [
          AppBar(
            title: const Text('Item Group'),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          Expanded(
            child: itemDataAsyncValue.when(
              data: (items) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('CONFIG ID')),
                      DataColumn(label: Text('CONFIG TYPE')),
                      DataColumn(label: Text('CONFIG CODE')),
                      DataColumn(label: Text('CONFIG VALUE')),
                      DataColumn(label: Text('CONFIG REMARK_1')),
                      DataColumn(label: Text('CONFIG REMARK_2')),
                      DataColumn(label: Text('DepdConfigCode')),
                      DataColumn(label: Text('DepdConfigID')),
                      DataColumn(label: Text('DepdConfigValue')),
                      DataColumn(label: Text('Keywords')),
                      DataColumn(label: Text('RowStatus')),
                    ],
                    rows: items.map((item) {
                      final isSelected =
                          selectedItem['Item Group'] == item['ConfigValue'];

                      return DataRow(
                        selected: isSelected,
                        color: WidgetStateColor.resolveWith((states) {
                          return isSelected
                              ? Colors.lightGreenAccent
                              : Colors.transparent;
                        }),
                        onSelectChanged: (bool? selected) {
                          if (selected == true) {
                            log('Row selected: ${item['ConfigValue']}');
                            ref
                                .read(dialogSelectionProvider.notifier)
                                .updateSelection(
                                    'Item Group', item['ConfigValue']);
                          }
                        },
                        cells: [
                          DataCell(Text(item['ConfigID'].toString())),
                          DataCell(Text(item['ConfigType'] ?? '')),
                          DataCell(Text(item['ConfigCode'] ?? '')),
                          DataCell(Text(item['ConfigValue'] ?? '')),
                          DataCell(Text(item['ConfigRemark1'] ?? '')),
                          DataCell(Text(item['ConfigRemark2'] ?? '')),
                          DataCell(Text(item['DepdConfigCode'] ?? '')),
                          DataCell(Text(item['DepdConfigID'] ?? '')),
                          DataCell(Text(item['DepdConfigValue'] ?? '')),
                          DataCell(Text(item['Keywords'] ?? '')),
                          DataCell(Text(item['RowStatus'] ?? '')),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final selectedItemID =
                        ref.read(dialogSelectionProvider)['Item Group'];
                    if (selectedItemID != null) {
                      // ref
                      //     .read(dialogSelectionProvider.notifier)
                      //     .clearSelection(); // Clear selection
                      Navigator.of(context).pop(); // Close the dialog
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an item')),
                      );
                    }
                  },
                  child: const Text('Save Selection'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
