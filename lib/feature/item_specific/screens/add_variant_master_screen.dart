import 'package:flutter/material.dart';

class AddVariantMasterScreen extends StatelessWidget {
  const AddVariantMasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Variant Master (Item Group - Gold)'),
      ),
      body: Row(
        children: [
          // Left side: Form
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Form Title
                  const Text(
                    'Variant Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Form Fields
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3.5,
                      children: [
                        _buildFormField('Metal Name...', Icons.search, context),
                        _buildFormField('Metal Variant Name', null, context),
                        _buildFormField(
                            'Base Metal V...', Icons.search, context),
                        _buildFormField(
                            'Vendor Name...', Icons.search, context),
                        _buildFormField('Reorder Qty', null, context),
                        _buildFormField(
                            'Used as BOM...', Icons.search, context),
                        _buildFormField('Verified Status', null, context),
                        _buildDropdownField('Manual Code Gen', context),
                        _buildDropdownField('Variant Type...', context),
                        _buildFormField('Std. Selling Rate', null, context),
                        _buildFormField('Std. Buying Rate', null, context),
                        _buildDropdownField('Row Status', context),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (bool? value) {}),
                            Expanded(child: Text('Can Return in Melting')),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Previous and Next Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Next'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Right side: View Catalog
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue[900],
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'View Catalog',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Fill your variant details to view summary here',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build a form field with an optional icon
  Widget _buildFormField(
      String labelText, IconData? icon, BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: icon != null ? Icon(icon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  // Method to build a dropdown field
  Widget _buildDropdownField(String labelText, BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      items: ['Option 1', 'Option 2', 'Option 3']
          .map((option) => DropdownMenuItem(
                child: Text(option),
                value: option,
              ))
          .toList(),
      onChanged: (value) {},
    );
  }
}
