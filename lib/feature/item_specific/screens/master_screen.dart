import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  MasterScreenState createState() => MasterScreenState();
}

class MasterScreenState extends State<MasterScreen> {
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
              // Handle refresh action
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
                    categoryContent[selectedCategory] ?? [],
                    isSearchable: true,
                  ),
                ),
                // Right panel (Select Item or Variant Master)
                Expanded(
                  flex: 3,
                  child: _buildPanel(
                    'Select Item or Variant Master',
                    ['Select master to load filter'],
                    isSearchable: false,
                    hasFormHeader: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to create a panel with dynamic content
  Widget _buildPanel(String title, List<String> items,
      {bool isSearchable = false, bool hasFormHeader = false}) {
    return Card(
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
                if (hasFormHeader)
                  const Text(
                    'Form HDR ID:',
                    style: TextStyle(fontSize: 16),
                  ),
              ],
            ),
          ),
          if (isSearchable)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  onTap: () {
                    // Handle item tap
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to create header buttons
  Widget _buildHeaderButton(String title) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedCategory = title;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            selectedCategory == title ? Colors.blue : Colors.grey[200],
        foregroundColor:
            selectedCategory == title ? Colors.white : Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(title),
    );
  }
}
