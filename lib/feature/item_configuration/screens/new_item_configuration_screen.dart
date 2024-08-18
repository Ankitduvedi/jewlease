import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/widgets/item_type_widget.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/feature/item_specific/widgets/app_bar_buttons.dart';
import 'package:jewlease/feature/item_specific/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class AddItemConfigurtionScreen extends ConsumerWidget {
  const AddItemConfigurtionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = ref.watch(checkboxProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('Item Configuration'),
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
        body: Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form Title
                const Text(
                  'Parent Form',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 3, 102, 200)),
                ),
                const SizedBox(height: 16),
                // Form Fields
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 4.5,
                    children: [
                      ReadOnlyTextFieldWidget(
                        hintText: textFieldvalues['Item Type'] ?? 'Item Type',
                        labelText: 'Item Type',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemDialogScreen(),
                          );
                        },
                      ),
                      _buildFormField(
                        'Item Type',
                        Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemDialogScreen(),
                          );
                        },
                      ),
                      _buildFormField('Item Group', Icons.search),
                      _buildFormField('Item Nature', Icons.search),
                      _buildFormField('Stock UOM...', Icons.search),
                      _buildFormField('Dependent Cr...', Icons.search),
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
                            child: Text('BOM Indicator'),
                          ),
                        ],
                      ),
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
                            child: Text('LOT Management Indicator'),
                          ),
                        ],
                      ),
                      _buildFormField('Other Loss I...', Icons.search),
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
                            child: Text('Custom Stock Reqd Ind'),
                          ),
                        ],
                      ),
                      _buildNumberInputField('Wastage(%)'),
                      _buildNumberInputField('Inward Rate Tollerance'),
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
                            child: Text('Operation Reqd Ind'),
                          ),
                        ],
                      ),
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
                            child: Text('Row Creation Ind'),
                          ),
                        ],
                      ),
                      _buildNumberInputField('Metal Tollerance(Do..)'),
                      _buildNumberInputField('Metal Tollerance(Up..)'),
                      _buildNumberInputField('Alloy Tollerance(Do..)'),
                      _buildNumberInputField('Alloy Tollerance(Do..)'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Previous and Next Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor:
                              const Color.fromARGB(255, 40, 112, 62)),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
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
        style: const TextStyle(
            color: Colors.black), // Text color for dropdown items
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
