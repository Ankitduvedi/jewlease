// item_screen.dart
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class ItemDialogScreen extends ConsumerWidget {
  const ItemDialogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemDataAsyncValue = ref.watch(itemFutureProvider);
    final selectedItem = ref.watch(dialogSelectionProvider);

    return Dialog(
      child: Column(
        children: [
          AppBar(
            title: const Text('Item Type'),
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Expanded(
              child: itemDataAsyncValue.when(
                data: (items) {
                  return DataTable(
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
                          selectedItem['Item Type'] == item['ConfigValue'];

                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (isSelected) {
                          if (isSelected ?? false) {
                            log('Row selected: ${item['ConfigValue']}');
                            ref.read(dialogSelectionProvider.notifier).state = {
                              'Item Type': item["ConfigValue"]
                            };
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
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => Center(
                  child: Text('Error: $error'),
                ),
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
                        ref.read(dialogSelectionProvider)['Item Type'];
                    if (selectedItemID != null) {
                      // Save the selected item ID to the provider or perform any action you need
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
