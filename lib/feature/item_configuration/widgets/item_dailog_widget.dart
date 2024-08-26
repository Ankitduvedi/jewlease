import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/widgets/custom_app_bar_finder.dart';

import 'package:jewlease/providers/dailog_selection_provider.dart';

class ItemTypeDialogScreen extends ConsumerStatefulWidget {
  const ItemTypeDialogScreen(
      {super.key, required this.title, required this.endUrl});
  final String title;
  final String endUrl;

  @override
  ItemTypeDialogScreenState createState() => ItemTypeDialogScreenState();
}

class ItemTypeDialogScreenState extends ConsumerState<ItemTypeDialogScreen> {
  String _searchQuery = '';
  String _selectedColumn = 'All'; // Default column is "All"

  List<Map<String, dynamic>> _filteredItems = [];
  List<String> _keys = []; // List to store the keys from the first item

  @override
  Widget build(BuildContext context) {
    final itemDataAsyncValue = ref.watch(itemTypeFutureProvider(widget.endUrl));

    final selectedItem = ref.watch(dialogSelectionProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners for dialog
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0), // Rounded corners for dialog
        child: Column(
          children: [
            CustomAppBarExample(title: widget.title),
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
                      Consumer(
                        builder: (context, ref, child) {
                          final key = ref.watch(dropDownValueProvider);
                          return Expanded(
                            flex: 1,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                highlightColor: Colors
                                    .transparent, // Removes the grey color on tap
                                focusColor: Colors
                                    .transparent, // Removes the grey color on focus
                              ),
                              child: DropdownButtonFormField<String>(
                                value: key[0], // Set the default value here
                                decoration: InputDecoration(
                                  labelText: 'Search By Column',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                items: key
                                    .map((option) => DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedColumn = value;
                                    });
                                  }
                                },
                                dropdownColor: Colors
                                    .white, // Set the dropdown menu background color
                                style: const TextStyle(
                                    color: Colors
                                        .black), // Text color for dropdown items
                              ),
                            ),
                          );
                        },
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ref
                              .read(dialogSelectionProvider.notifier)
                              .clearSelection(widget.title);
                        },
                        label: const Text(
                          'Reload',
                          style: TextStyle(
                              color: Color(0xFF346B43),
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        icon: const Icon(
                          weight: 20,
                          Icons.refresh_rounded,
                          color: Color(0xFF346B43),
                        ),
                      )
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
                          if (items.isEmpty) {
                            return const Center(
                                child: Text('No data available'));
                          }
                          if (items.isNotEmpty && _keys.isEmpty) {
                            _keys = items.first.keys.toList();
                            _keys.insert(0, 'All');
                            Future(
                              () {
                                ref.read(dropDownValueProvider.notifier).state =
                                    _keys;
                              },
                            );
                          }

                          // Update _filteredItems based on search query
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
                                WidgetStateColor.resolveWith((states) {
                              return const Color.fromARGB(255, 0, 52, 80);
                            }),
                            columns:
                                _keys.where((key) => key != 'All').map((key) {
                              return DataColumn(
                                label: Text(
                                  key.toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              );
                            }).toList(),
                            rows: _filteredItems.map((item) {
                              final isSelected = selectedItem[widget.title] ==
                                  item['ConfigValue'];

                              return DataRow(
                                selected: isSelected,
                                onSelectChanged: (bool? selected) {
                                  if (selected == true) {
                                    ref
                                        .read(dialogSelectionProvider.notifier)
                                        .updateSelection(
                                            widget.title, item['ConfigValue']);
                                  }
                                },
                                cells: _keys
                                    .where((key) => key != 'All')
                                    .map((key) {
                                  return DataCell(
                                      Text(item[key]?.toString() ?? ''));
                                }).toList(),
                              );
                            }).toList(),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            Center(child: Text('Error: $error')),
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
                          ref.read(dialogSelectionProvider)[widget.title];
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
