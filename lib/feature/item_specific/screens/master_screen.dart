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
                  ),
                ),
                // Right panel (Select Item or Variant Master)
                Expanded(
                  flex: 3,
                  child: _buildSelectItemVariantMasterPanel(),
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
                    mainAxisSize: MainAxisSize
                        .min, // Ensures the Row takes only as much space as needed
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Item',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8), // Adding space between buttons
                      Flexible(
                        child: TextButton(
                          onPressed: () {},
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

  Widget _buildSelectItemVariantMasterPanel() {
    return Card(
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
                  _buildTextField('Item Type...*'),
                  _buildTextField('Item Group...*'),
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

  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        labelText: hintText,
        //hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
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
        backgroundColor: selectedCategory == title ? Colors.blue : Colors.white,
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
