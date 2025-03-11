import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';

class ItemAttributesScreen extends ConsumerWidget {
  const ItemAttributesScreen({
    super.key,
    required this.attributeTypes,
  });
  final List<Map<String, String>> attributeTypes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF0F3057), // Dark blue color
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Attrib Type',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Attrib Value',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      'Attrib Desc',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            // Table rows
            Expanded(
              child: ListView(
                children: attributeTypes.map((value) {
                  return TableRowItem(
                    attributeData: value,
                    attributeType: value['title'] ?? '',
                    attributeValue: '',
                    attributeDesc: '',
                  );
                }).toList(),

                // Add more TableRowItems here
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TableRowItem extends ConsumerWidget {
  final Map<String, String> attributeData;
  final String attributeType;
  final String attributeValue;
  final String attributeDesc;

  const TableRowItem({
    super.key,
    required this.attributeType,
    required this.attributeValue,
    required this.attributeDesc,
    required this.attributeData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textFieldvalues = ref.watch(dialogSelectionProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(attributeType),
            ),
          ),
          Expanded(
            child: ReadOnlyTextFieldWidget(
              hintText: textFieldvalues[attributeData['key']] ?? attributeType,
              labelText: attributeType,
              icon: Icons.search,
              onIconPressed: () {
                // log("value is ${attributeData['value']!}");
                // log("title is ${attributeData["title"]}");
                // log("end url  is ${attributeData['endUrl']!}");
                // log("query is ${attributeData['query']!}");

                showDialog(
                  context: context,
                  builder: (context) => ItemTypeDialogScreen(
                    value: attributeData['value']!,
                    title: attributeData['title']!,
                    endUrl: attributeData['endUrl']!,
                    query: attributeData['query'],
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(attributeDesc),
          ),
        ],
      ),
    );
  }
}
