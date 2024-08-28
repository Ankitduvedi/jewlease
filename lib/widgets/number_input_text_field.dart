import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NumberTextFieldWidget extends ConsumerWidget {
  final String labelText;
  final TextEditingController controller;

  const NumberTextFieldWidget(
      {super.key, required this.labelText, required this.controller});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      controller: controller,
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
