import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

class ItemAttributesScreen extends ConsumerWidget {
  const ItemAttributesScreen({super.key, required this.attributeTypes});
  final List<String> attributeTypes;

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
                    attributeType: value,
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

class TableRowItem extends StatelessWidget {
  final String attributeType;
  final String attributeValue;
  final String attributeDesc;

  const TableRowItem({
    super.key,
    required this.attributeType,
    required this.attributeValue,
    required this.attributeDesc,
  });

  @override
  Widget build(BuildContext context) {
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
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(attributeValue),
                IconButton(
                  icon: const Icon(Icons.search, size: 18),
                  onPressed: () {
                    // Handle search icon pressed
                  },
                ),
              ],
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
