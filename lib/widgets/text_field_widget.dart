import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldWidget extends ConsumerWidget {
  final String labelText;
  final TextEditingController controller;
  const TextFieldWidget(
      {super.key, required this.labelText, required this.controller});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ));
  }
}
