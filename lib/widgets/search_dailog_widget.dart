// import 'dart:developer';

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/custom_app_bar_finder.dart';
import '../feature/formula/controller/heirarchy_controller.dart';

class ItemTypeDialogScreen extends ConsumerStatefulWidget {
  const ItemTypeDialogScreen(
      {super.key,
      required this.title,
      required this.endUrl,
      required this.value,
      this.keyOfMap,
      this.query,
      this.onOptionSelectd,
      this.queryMap,
      this.onSelectdRow});

  final String title;
  final String endUrl;
  final String value;
  final String? query;
  final String? keyOfMap;
  final Map<String, dynamic>? queryMap;
  final Function(String)? onOptionSelectd;
  final Function(Map<String, dynamic>)? onSelectdRow;

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
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: [
            CustomAppBarExample(title: widget.title),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
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
                      Expanded(
                        flex: 1,
                        child: Consumer(
                          builder: (context, ref, child) {
                            final key = ref.watch(dropDownValueProvider);
                            return DropdownButtonFormField<String>(
                              value: key[0],
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
                            );
                          },
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          ref
                              .read(dialogSelectionProvider.notifier)
                              .clearSelection(widget.title);
                          ref.invalidate(itemTypeFutureProvider);
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
                ],
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: itemDataAsyncValue.when(
                data: (item) {
                  List<Map<String, dynamic>> items;

                  if (widget.query != null) {
                    items = item.where((item) {
                      return item.values.any(
                          (value) => value.toString().contains(widget.query!));
                    }).toList();
                  } else {
                    items = item;
                    //log("item list is $items");
                  }
                  if (widget.queryMap != null) {
                    print("query map ${item.length}");

                    items = item.where((item) {
                      return widget.queryMap!.entries.every((queryEntry) =>
                          item.containsKey(queryEntry.key) &&
                          item[queryEntry.key] == queryEntry.value);
                    }).toList();
                    print("query map2 ${items}");
                  }
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
                  // for(Map<String,dynamic>item in _filteredItems)
                  //   item["Stock ID"] ="STC- ${_filteredItems.indexOf(item)}";
                  //
                  //
                  //  print("filtered items ${_filteredItems.length}");

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
                          final isSelected =
                              selectedItem[widget.keyOfMap ?? widget.title]
                                      .toString() ==
                                  item[widget.value].toString();

                          return DataRow(
                            selected: isSelected,
                            onSelectChanged: (bool? selected) {
                              if (selected == true) {
                                //log("runtype is ${widget.value.runtimeType} $item ${item[widget.value]}");
                                ref
                                    .read(dialogSelectionProvider.notifier)
                                    .updateSelection(
                                        widget.keyOfMap ?? widget.title,
                                        item[(widget.value).toString()]
                                            .toString());
                              }
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
                      final selectedItemID = ref.read(dialogSelectionProvider)[
                          widget.keyOfMap ?? widget.title];

                      if (selectedItemID != null) {
                        Map<String, dynamic> selectedRow =
                            _filteredItems.firstWhere(
                          (map) {
                            //log("map $map");
                            return map[widget.value].toString() ==
                                selectedItemID.toString();
                          },
                          orElse: () => {},
                        );
                        if (widget.title == "Add Varient") {
                          selectedRow = _filteredItems.firstWhere(
                            (map) {
                              print("map $map");
                              return map["Varient Name"].toString() ==
                                  selectedItemID.toString();
                            },
                            orElse: () => {},
                          );
                        }
                        // log("selected id $selectedItemID");
                        if (widget.title == "Depd Field") {
                          // log("depd field selected $selectedItemID");
                          if (widget.value == 'ConfigValue') {
                            ref
                                .read(valueProvider.notifier)
                                .setValue(selectedItemID);
                          } else {
                            ref
                                .read(valueProvider.notifier)
                                .setValue(selectedRow["Config value"]);
                          }
                        }
                        if (widget.title == "Data Type") {
                          ref
                              .read(itemProvider.notifier)
                              .setItem(selectedRow["Config value"]);
                        }
                        if (widget.onOptionSelectd != null) {
                          // log("hello");
                          if (widget.title == 'Range Type') {
                            // log("selected Row $selectedRow");
                            widget.onOptionSelectd!(
                                selectedRow["Range Hierarchy Name"]);
                          } else {
                            widget.onOptionSelectd!(selectedItemID);
                          }
                        }
                        if (widget.onSelectdRow != null) {
                          log("selected row $selectedRow");
                          widget.onSelectdRow!(selectedRow);
                        }

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
