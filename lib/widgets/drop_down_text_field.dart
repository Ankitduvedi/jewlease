import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class DropDownTextFieldWidget extends ConsumerWidget {
  final String labelText;

  final List<String> items;
  final String initialValue;
  const DropDownTextFieldWidget(
      {super.key,
      required this.labelText,
      required this.initialValue,
      required this.items});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: Colors.transparent, // Removes the grey color on tap
        focusColor: Colors.transparent, // Removes the grey color on focus
      ),
      child: DropdownButtonFormField<String>(
        value: initialValue, // Set the default value here

        decoration: InputDecoration(
          labelStyle: const TextStyle(fontSize: 12),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0.0, // Adjust the vertical padding
            horizontal: 12.0, // Adjust the horizontal padding if necessary
          ), // Ensure enough space for the content
        ),

        items: items
            .map((option) => DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 13),
                  ),
                ))
            .toList(),
        onChanged: (value) {
          // Handle the change here
          ref
              .read(dropDownProvider.notifier)
              .updateSelection(labelText, value!);
        },
        dropdownColor: Colors.white, // Set the dropdown menu background color
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black, // Text color for dropdown items
        ),
      ),
    );
  }
}
