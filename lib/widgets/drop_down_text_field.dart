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
          ref
              .read(dropDownProvider.notifier)
              .updateSelection(labelText, value!);
        },
        dropdownColor: Colors.white, // Set the dropdown menu background color
        style: const TextStyle(
            color: Colors.black), // Text color for dropdown items
      ),
    );
  }
}
