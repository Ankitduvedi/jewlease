import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class LeftPannelSearchWidget extends ConsumerStatefulWidget {
  const LeftPannelSearchWidget({super.key, this.value, this.query});

  final String? value;
  final String? query;

  @override
  LeftPannelSearchWidgetState createState() => LeftPannelSearchWidgetState();
}

class LeftPannelSearchWidgetState
    extends ConsumerState<LeftPannelSearchWidget> {
  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredItems = [];
  List<String> _keys = []; // List to store the keys from the first item

  @override
  Widget build(BuildContext context) {
    final masterType = ref.watch(masterTypeProvider);
    final title = '${masterType[2]} Master (Item Group- ${masterType[1]})';
    final url =
        'ItemMasterAndVariants/${masterType[0]}/${masterType[1]}/${masterType[2]}/';
    log('url $url, title $title');
    final itemDataAsyncValue = ref.watch(itemTypeFutureProvider(url));

    final selectedItem = ref.watch(dialogSelectionProvider);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
        const SizedBox(height: 18),
        Expanded(
          child: itemDataAsyncValue.when(
            data: (items) {
              // If a query is provided, filter items by query
              if (widget.query != null) {
                items = items.where((item) {
                  return item.values.any((value) =>
                      value.toString().toLowerCase().contains(widget.query!));
                }).toList();
              }

              if (items.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              // Populate keys and dropdown values
              if (_keys.isEmpty) {
                _keys = items.first.keys.toList();
                //_keys.insert(0, 'All');
                Future(() {
                  ref.read(dropDownValueProvider.notifier).state = _keys;
                });
              }

              // Filter items based on search query
              _filteredItems = items.where((item) {
                if (_searchQuery.isEmpty) {
                  return true;
                }
                return item.values.any((value) =>
                    value != null &&
                    value.toString().toLowerCase().contains(_searchQuery));
              }).toList();

              // Display DataTable with a single column
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  headingRowColor: WidgetStateColor.resolveWith((states) {
                    return const Color.fromARGB(255, 0, 52, 80);
                  }),
                  columns: [
                    DataColumn(
                      label: Text(
                        _keys[0],
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                  rows: _filteredItems.map((item) {
                    final isSelected = selectedItem[title] == item[_keys[0]];

                    return DataRow(
                      selected: isSelected,
                      onSelectChanged: (bool? selected) {
                        if (selected == true) {
                          ref
                              .read(dialogSelectionProvider.notifier)
                              .updateSelection(title, item[_keys[0]]);

                          // Unified Provider Update
                          ref.read(selectedItemDataProvider.notifier).state =
                              item;
                        }
                      },
                      cells: [DataCell(Text(item[_keys[0]].toString()))],
                    );
                  }).toList(),
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

final selectedItemDataProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);
