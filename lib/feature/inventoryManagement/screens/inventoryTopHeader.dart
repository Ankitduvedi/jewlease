import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/read_only_textfield_widget.dart';
import '../controllers/inventoryController.dart';
import '../controllers/inventorySummery.dart';

class inventoryTopHeader extends ConsumerStatefulWidget {
  @override
  ConsumerState<inventoryTopHeader> createState() => _inventoryTopHeaderState();
}

class _inventoryTopHeaderState extends ConsumerState<inventoryTopHeader> {
  @override
  Widget build(BuildContext context) {
    bool showGraph = ref.watch(showGraphProvider);
    Map<String, dynamic> summery = ref.watch(inventorySummaryProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Hide Graph Button
          ElevatedButton(
            onPressed: () {
              ref.read(showGraphProvider.notifier).toggle();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: showGraph ? Colors.black : Colors.grey,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              'Hide Graph',
              style: TextStyle(
                  color: showGraph ? Colors.white : Colors.black, fontSize: 14),
            ),
          ),
          SizedBox(
            width: 5,
          ),

          // Details - Total: 213
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Details -',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
              Text(
                'Total: ${summery["TotalRows"]}',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            width: 5,
          ),
          // Select Option Button with Icon
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.refresh, size: 16),
            label: Text(
              'Select Option',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          // Selected Row Text
          Text(
            'Selected Row',
            style: TextStyle(
              fontSize: 14,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),

          // Dropdown for Variant Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: DropdownButton<String>(
              value: 'Variant Name',
              items: ['Variant Name', 'Option 1', 'Option 2']
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {},
              underline: SizedBox(),
              icon: Icon(Icons.arrow_drop_down),
            ),
          ),

          // Search TextField
          SizedBox(
            width: 200,
            child: ReadOnlyTextFieldWidget(
                labelText: "Search Styles", hintText: "Search Styles"),
          ),
        ],
      ),
    );
  }
}
