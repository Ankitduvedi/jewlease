import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_configuration/widgets/custom_app_bar_finder.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class ItemTypeDialogScreen extends ConsumerStatefulWidget {
  const ItemTypeDialogScreen({super.key});

  @override
  ItemTypeDialogScreenState createState() => ItemTypeDialogScreenState();
}

class ItemTypeDialogScreenState extends ConsumerState<ItemTypeDialogScreen> {
  String _searchQuery = '';
  String _selectedColumn = 'All'; // Default column is "All"

  List<Map<String, dynamic>> _filteredItems = [];

  @override
  Widget build(BuildContext context) {
    final itemDataAsyncValue = ref.watch(itemTypeFutureProvider);
    final selectedItem = ref.watch(dialogSelectionProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners for dialog
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners for dialog
        child: Column(
          children: [
            const CustomAppBarExample(
              title: 'Item Type',
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  // Search Bar and Dropdown Menu
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (query) {
                            setState(() {
                              _searchQuery = query.toLowerCase();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: _selectedColumn,
                        items: const [
                          DropdownMenuItem(
                            value: 'All',
                            child: Text('All'),
                          ),
                          DropdownMenuItem(
                            value: 'ConfigID',
                            child: Text('CONFIG ID'),
                          ),
                          DropdownMenuItem(
                            value: 'ConfigType',
                            child: Text('CONFIG TYPE'),
                          ),
                          DropdownMenuItem(
                            value: 'ConfigCode',
                            child: Text('CONFIG CODE'),
                          ),
                          DropdownMenuItem(
                            value: 'ConfigValue',
                            child: Text('CONFIG VALUE'),
                          ),
                          DropdownMenuItem(
                            value: 'ConfigRemark1',
                            child: Text('CONFIG REMARK_1'),
                          ),
                          // Add other columns as needed
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedColumn = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      // Rounded corners for DataTable
                      child: itemDataAsyncValue.when(
                        data: (items) {
                          _filteredItems = items.where((item) {
                            if (_searchQuery.isEmpty) {
                              return true;
                            }
                            if (_selectedColumn == 'All') {
                              return item.values.any((value) =>
                                  value != null &&
                                  value
                                      .toString()
                                      .toLowerCase()
                                      .contains(_searchQuery));
                            } else {
                              return item[_selectedColumn]
                                      ?.toString()
                                      .toLowerCase()
                                      .contains(_searchQuery) ??
                                  false;
                            }
                          }).toList();

                          return DataTable(
                            headingRowColor:
                                MaterialStateColor.resolveWith((states) {
                              return const Color.fromARGB(255, 0, 52, 80);
                            }),
                            columns: const [
                              DataColumn(
                                  label: Text(
                                'CONFIG ID',
                                style: TextStyle(color: Colors.white),
                              )),
                              DataColumn(
                                  label: Text('CONFIG TYPE',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('CONFIG CODE',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('CONFIG VALUE',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('CONFIG REMARK_1',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('CONFIG REMARK_2',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('DepdConfigCode',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('DepdConfigID',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('DepdConfigValue',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('Keywords',
                                      style: TextStyle(color: Colors.white))),
                              DataColumn(
                                  label: Text('RowStatus',
                                      style: TextStyle(color: Colors.white))),
                            ],
                            rows: _filteredItems.map((item) {
                              final isSelected = selectedItem['Item Type'] ==
                                  item['ConfigValue'];

                              return DataRow(
                                selected: isSelected,
                                onSelectChanged: (bool? selected) {
                                  if (selected == true) {
                                    ref
                                        .read(dialogSelectionProvider.notifier)
                                        .updateSelection(
                                            'Item Type', item['ConfigValue']);
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
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) => Center(
                          child: Text('Error: $error'),
                        ),
                      ),
                    ),
                  ),
                ],
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
                          const SnackBar(
                              content: Text('Please select an item')),
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
      ),
    );
  }
}
