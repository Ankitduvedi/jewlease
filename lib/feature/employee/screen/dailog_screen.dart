import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/departments_model.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/feature/employee/controller/employee_controller.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/widgets/custom_app_bar_finder.dart';

class ItemTypeDialogScreen extends ConsumerStatefulWidget {
  const ItemTypeDialogScreen({
    super.key,
    required this.title,
    required this.endUrl,
    required this.value,
    this.keyOfMap,
    this.query,
    this.onOptionsSelected, // Changed for multiple selections
  });

  final String title;
  final String endUrl;
  final String value;
  final String? query;
  final String? keyOfMap;
  final Function(List<Map<String, dynamic>>)? onOptionsSelected; // Updated

  @override
  ItemTypeDialogScreenState createState() => ItemTypeDialogScreenState();
}

class ItemTypeDialogScreenState extends ConsumerState<ItemTypeDialogScreen> {
  String _searchQuery = '';
  String _selectedColumn = 'All';

  List<Map<String, dynamic>> _filteredItems = [];
  List<String> _keys = [];

  @override
  Widget build(BuildContext context) {
    final itemDataAsyncValue = ref.watch(itemTypeFutureProvider(widget.endUrl));
    final selectedItems = ref.watch(newdialogSelectionProvider);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: [
            CustomAppBarExample(title: widget.title),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(newdialogSelectionProvider.notifier)
                          .clearSelection();
                    },
                    label: const Text(
                      'Reload',
                      style: TextStyle(
                          color: Color(0xFF346B43),
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF346B43),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: itemDataAsyncValue.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }

                  if (items.isNotEmpty && _keys.isEmpty) {
                    _keys = items.first.keys.toList();
                    _keys.insert(0, 'All');
                  }

                  _filteredItems = items.where((item) {
                    if (_searchQuery.isEmpty) return true;
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

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        headingRowColor: WidgetStateColor.resolveWith((states) {
                          return const Color.fromARGB(255, 0, 52, 80);
                        }),
                        columns: _keys.where((key) => key != 'All').map((key) {
                          return DataColumn(
                            label: Text(
                              key.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        rows: _filteredItems.map((item) {
                          final isSelected = selectedItems.any(
                              (e) => e[widget.value] == item[widget.value]);

                          return DataRow(
                            selected: isSelected,
                            onSelectChanged: (bool? selected) {
                              ref
                                  .read(newdialogSelectionProvider.notifier)
                                  .toggleSelection(item);
                            },
                            cells:
                                _keys.where((key) => key != 'All').map((key) {
                              return DataCell(
                                  Text(item[key]?.toString() ?? ''));
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Error: $error')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final selectedItems =
                          ref.read(newdialogSelectionProvider);
                      log('Selected Items: $selectedItems');

                      // Extract selected rows based on selected item IDs
                      // List<Map<String, dynamic>> selectedRows = _filteredItems
                      //     .where((map) => selectedItems
                      //         .contains(map[widget.value].toString()))
                      //     .toList();

                      List<Departments> selectedDepartments = selectedItems
                          .map((row) => Departments.froomJson(row))
                          .toList();
                      log('Selected Rows: ${selectedDepartments.first.departmentName}');

                      if (selectedDepartments.isNotEmpty) {
                        // Convert selected rows to list of Departments
                        // List<Departments> selectedDepartments =
                        //     selectedDepartments.map((row) {
                        //   return Departments.fromJson(row);
                        // }).toList();

                        // Create Location object
                        // Group departments by locationCode
                        Map<String, List<Departments>> groupedDepartments = {};

                        for (var department in selectedDepartments) {
                          String locationCode =
                              department.locationName; // Extract locationCode
                          if (!groupedDepartments.containsKey(locationCode)) {
                            groupedDepartments[locationCode] = [];
                          }
                          groupedDepartments[locationCode]!.add(department);
                        }

                        // Convert grouped map into List<Location>
                        List<Location> locations =
                            groupedDepartments.entries.map((entry) {
                          return Location(
                            locationCode: entry.key,
                            departments: entry.value,
                          );
                        }).toList();

                        // Log the final grouped list of locations
                        log("Grouped Locations: ${locations.map((loc) => loc.toJson()).toList()}");

                        // Perform any additional actions (e.g., save to provider or DB)

                        Navigator.of(context).pop(); // Close the dialog
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Please select at least one item')),
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
