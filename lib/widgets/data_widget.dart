import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class ItemDataScreen extends ConsumerStatefulWidget {
  ItemDataScreen(
      {super.key,
      required this.title,
      required this.endUrl,
      this.canGo = false,
      this.onDoubleClick});

  final String title;
  final String endUrl;
  bool canGo;
  final Function(Map<String, dynamic>)? onDoubleClick;

  @override
  ItemDataScreenState createState() => ItemDataScreenState();
}

class ItemDataScreenState extends ConsumerState<ItemDataScreen> {
  String _searchQuery = '';
  String _selectedColumn = 'All'; // Default column is "All"

  List<Map<String, dynamic>> _filteredItems = [];
  List<String> _keys = []; // List to store the keys from the first item

  @override
  Widget build(BuildContext context) {
    final itemDataAsyncValue = ref.watch(itemTypeFutureProvider(widget.endUrl));

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Background color of the container
          borderRadius: BorderRadius.circular(12.0), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              spreadRadius: 1, // How far the shadow spreads
              blurRadius: 8, // Softens the shadow
              offset: const Offset(
                  4, 4), // Moves the shadow horizontally and vertically
            ),
          ],
          border: Border.all(
            color: const Color.fromARGB(
                255, 219, 219, 219), // Outline (border) color
            width: 2.0, // Border width
          ),
        ),
        //color: Colors.white,
        child: Column(
          children: [
            // Search Bar and Dropdown Menu
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
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
                ),
                const SizedBox(width: 10),
                Consumer(
                  builder: (context, ref, child) {
                    final key = ref.watch(dropDownValueProvider);
                    return Expanded(
                      flex: 1,
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                        ),
                        child: DropdownButtonFormField<String>(
                          value: key[0],
                          // Set the default value here
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
                          dropdownColor: Colors.white,
                          style: const TextStyle(color: Colors.black),
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
            Expanded(
              child: itemDataAsyncValue.when(
                data: (items) {
                  if (items.isEmpty) {
                    return const Center(child: Text('No data available'));
                  }
                  if (items.isNotEmpty && _keys.isEmpty) {
                    _keys = items.first.keys.toList();
                    _keys.insert(0, 'All');
                    Future(
                      () {
                        ref.read(dropDownValueProvider.notifier).state = _keys;
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

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        showCheckboxColumn: true,
                        headingRowColor: WidgetStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 0, 52, 80),
                        ),
                        columns: _keys.where((key) => key != 'All').map((key) {
                          return DataColumn(
                            numeric: false,
                            label: Text(
                              key.toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        rows: _filteredItems.map((item) {
                          return DataRow(
                            cells:
                                _keys.where((key) => key != 'All').map((key) {
                              return DataCell(GestureDetector(
                                  onDoubleTap: () {
                                    if (widget.canGo) {
                                      List<String> keys = _keys
                                          .where((key) => key != 'All')
                                          .map((key) {
                                        return key;
                                      }).toList();
                                      List<String> values = _keys
                                          .where((key) => key != 'All')
                                          .map((key) {
                                        return item[key]?.toString() ?? '';
                                      }).toList();
                                      Map<String, dynamic> intialData =
                                          Map.fromIterables(keys, values);

                                      widget.onDoubleClick!(intialData);
                                    }
                                  },
                                  child: Text(item[key]?.toString() ?? '')));
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
          ],
        ),
      ),
    );
  }
}
