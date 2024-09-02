import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';

import 'package:jewlease/providers/dailog_selection_provider.dart';

class LeftPannelSearchWidget extends ConsumerStatefulWidget {
  const LeftPannelSearchWidget(
      {super.key,
      required this.title,
      required this.endUrl,
      this.value,
      this.query});
  final String title;
  final String endUrl;
  final String? value;
  final String? query;

  @override
  LeftPannelSearchWidgetState createState() => LeftPannelSearchWidgetState();
}

class LeftPannelSearchWidgetState
    extends ConsumerState<LeftPannelSearchWidget> {
  String _searchQuery = '';
  final String _selectedColumn = 'All'; // Default column is "All"

  List<Map<String, dynamic>> _filteredItems = [];
  List<String> _keys = []; // List to store the keys from the first item

  @override
  Widget build(BuildContext context) {
    final itemDataAsyncValue = ref.watch(itemTypeFutureProvider(widget.endUrl));

    final selectedItem = ref.watch(dialogSelectionProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Expanded(
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
        const SizedBox(height: 18),
        Expanded(
          child: itemDataAsyncValue.when(
            data: (item) {
              final List<Map<String, dynamic>> items;
              if (widget.query != null) {
                items = item.where((item) {
                  return item.values
                      .any((value) => value.toString().contains(widget.query!));
                }).toList();
              } else {
                items = item;
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
                      value.toString().toLowerCase().contains(_searchQuery));
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
                      final isSelected = selectedItem[widget.title] ==
                          item[widget.value ?? 'ConfigValue'];

                      return DataRow(
                        selected: isSelected,
                        onSelectChanged: (bool? selected) {
                          if (selected == true) {
                            ref
                                .read(dialogSelectionProvider.notifier)
                                .updateSelection(widget.title,
                                    item[widget.value ?? 'ConfigValue']);
                          }
                        },
                        cells: _keys.where((key) => key != 'All').map((key) {
                          return DataCell(Text(item[key]?.toString() ?? ''));
                        }).toList(),
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }
}
