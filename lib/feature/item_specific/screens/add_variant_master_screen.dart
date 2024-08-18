import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/feature/item_specific/widgets/app_bar_buttons.dart';
import 'package:jewlease/feature/item_specific/widgets/read_only_textfield_widget.dart';

class AddVariantMasterScreen extends ConsumerWidget {
  const AddVariantMasterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = ref.watch(checkboxProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text('Variant Master (Item Group - Gold)'),
        actions: [
          AppBarButtons(
            ontap: [
              () {},
              () {},
              () {
                // Reset the provider value to null on refresh
                ref.watch(masterTypeProvider.notifier).state = [
                  'Style',
                  null,
                  null
                ];
              },
              () {}
            ],
          )
        ],
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
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 0,
                      childAspectRatio: 4.5,
                      children: [
                        _buildFormField('Metal Name...', Icons.search),
                        _buildFormField('Metal Variant Name', null),
                        _buildDropdownField(
                            'Manual Code Gen', context, ['No', 'Yes'], 'No'),
                        _buildFormField('Variant Type...', Icons.search),
                        _buildFormField('Base Metal V...', Icons.search),
                        _buildFormField('Vendor Name...', Icons.search),
                        _buildNumberInputField('Std.Selling Rate'),
                        _buildNumberInputField('Std.Buying Rate'),
                        _buildNumberInputField('Reorder Qty'),
                        _buildFormField('Used as BOM...', Icons.search),
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                // Update the state when the checkbox is pressed
                                ref.read(checkboxProvider.notifier).state =
                                    value!;
                              },
                              activeColor: Colors
                                  .green, // Optional: Set the color of the tick
                            ),
                            const Expanded(
                              child: Text('Can Return in Melting'),
                            ),
                          ],
                        ),
                        _buildDropdownField('Row Status', context,
                            ['In Active', 'Active'], 'Active'),
                        _buildFormField(
                          'Verified Status',
                          null,
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
              color: const Color.fromARGB(255, 0, 52, 80),
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
  Widget _buildFormField(String labelText, IconData? icon,
      {VoidCallback? onIconPressed}) {
    return TextField(
      // Set to true if the field is meant to be non-editable
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: icon != null
            ? IconButton(
                icon: Icon(icon),
                onPressed: onIconPressed ?? () {},
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
  // Method to build a form field with an optional icon

  // Method to build a dropdown field
  Widget _buildDropdownField(String labelText, BuildContext context,
      List<String> items, String initialValue) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent, // Removes the grey color on tap
        focusColor: Colors.transparent, // Removes the grey color on focus
      ),
      child: DropdownButtonFormField<String>(
        value: initialValue, // Set the default value here
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        items: items
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(option),
                ))
            .toList(),
        onChanged: (value) {
          // Handle the change here
        },
        dropdownColor: Colors.white, // Set the dropdown menu background color
        style: TextStyle(color: Colors.black), // Text color for dropdown items
      ),
    );
  }

  Widget _buildNumberInputField(String labelText) {
    return TextField(
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right, // Text starts entering from the right
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allows digits
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: '0',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
