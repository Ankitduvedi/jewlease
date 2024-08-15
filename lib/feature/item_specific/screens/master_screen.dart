import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define a provider to manage the state of the selected master type
final masterTypeProvider =
    StateProvider<List<String?>>((ref) => ['Style', null, null]);

class MasterScreen extends ConsumerStatefulWidget {
  const MasterScreen({super.key});

  @override
  MasterScreenState createState() => MasterScreenState();
}

class MasterScreenState extends ConsumerState<MasterScreen> {
  String selectedCategory = 'Style';

  // Define different content for each category
  final Map<String, List<String>> categoryContent = {
    'Style': ['Style', 'Style(Pcs)', 'Style(Wt)'],
    'Metal': ['Gold', 'Platinum', 'Silver', 'Bronze'],
    'Stone': [
      'Diamond',
      'Pearl',
      'Precious Stone',
      'Semi Precious Stone',
      'Zircon',
      'Polki',
      'Diamond Solitaire'
    ],
    'Consumables': ['Consumables(Wt)', 'Consumables-Cts'],
    'Set': ['Set'],
    'Certificate': ['Style Certificate', 'Stone Certificate'],
    'Packing Material': ['Packing Materials'],
  };

  @override
  Widget build(BuildContext context) {
    // Access the current value of the master type from the provider
    final masterType = ref.watch(masterTypeProvider);
    log(masterType.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Handle new action
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Handle save action
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Reset the provider value to null on refresh
              ref.watch(masterTypeProvider.notifier).state = [
                'Style',
                null,
                null
              ];
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              // Handle close action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: categoryContent.keys.map((category) {
                return _buildHeaderButton(category);
              }).toList(),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Left panel (Select Master)
                Expanded(
                  flex: 2,
                  child: _buildPanel(
                    'Select Master',
                    categoryContent[masterType[0]] ?? [],
                  ),
                ),
                // Right panel (Select Item or Variant Master)
                Expanded(
                  flex: 3,
                  child: _buildSelectItemVariantMasterPanel(masterType[2]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to create a panel with dynamic content
  Widget _buildPanel(
    String title,
    List<String> items,
  ) {
    final masterType = ref.watch(masterTypeProvider);

    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            ref.watch(masterTypeProvider.notifier).state = [
                              masterType[0],
                              items[index],
                              'item master'
                            ];
                          },
                          child: const Text(
                            'Item',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            ref.watch(masterTypeProvider.notifier).state = [
                              masterType[0],
                              items[index],
                              'variant master'
                            ];
                          },
                          child: const Text(
                            'Variant',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Modify this method to show different content based on the master type
  Widget _buildSelectItemVariantMasterPanel(String? masterType) {
    if (masterType == 'variant master') {
      return _buildVariantMasterPanel();
    } else if (masterType == 'item master') {
      return _buildItemMasterPanel();
    } else {
      return const Center(
        child: Text('Please select a master type.'),
      );
    }
  }

  Widget _buildVariantMasterPanel() {
    final masterType = ref.watch(masterTypeProvider);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Item or Variant Master',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Form HDR ID: 327',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[100],
                  ),
                  child: const Text(
                    'Item Master',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[100],
                  ),
                  child: const Text(
                    'Variant Master',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('View Catalog'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3.5,
                children: [
                  _buildReadOnlyTextField(
                      'Item Type', masterType[0] ?? 'Item Type'),
                  _buildReadOnlyTextField(
                      'Item Group...*', masterType[1] ?? 'Item Group...*'),
                  _buildTextField('Variant Name'),
                  _buildTextField('Item Name'),
                  _buildTextField('Old Variant Name'),
                  _buildTextField('Attribute Description'),
                  _buildTextField('Variant Remark'),
                  _buildTextField('Customer Variant Name'),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 25, 167, 72),
                    ),
                    child: const Text('Load'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemMasterPanel() {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Master Panel',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Form HDR ID: 327',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter Item Information',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          // Add more widgets as needed
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Additional Info',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Utility method to build a text field
  Widget _buildReadOnlyTextField(String labelText, String hintText) {
    return TextField(
        onTap: () {
          // Prevent any interaction with the text field
        },
        //enabled: false,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keeps the label always at the top
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ));
  }

  Widget _buildTextField(String labelText) {
    return TextField(
        decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    ));
  }

  // Method to build header buttons
  Widget _buildHeaderButton(String category) {
    return ElevatedButton(
      onPressed: () {
        // Update the provider value, which automatically triggers UI rebuild
        ref.read(masterTypeProvider.notifier).state = [category, null, null];
      },
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: ref.watch(masterTypeProvider)[0] == category
            ? const Color.fromARGB(255, 0, 52, 80)
            : Colors.white,
      ),
      child: Text(
        category,
        style: TextStyle(
          color: ref.watch(masterTypeProvider)[0] == category
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
