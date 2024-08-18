import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadOnlyTextFieldWidget extends ConsumerWidget {
  final String labelText;
  final String hintText;
  final IconData? icon;
  final VoidCallback? onIconPressed;
  const ReadOnlyTextFieldWidget(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.icon,
      this.onIconPressed});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
        onTap: () {
          // Prevent any interaction with the text field
        },
        //enabled: false,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          suffixIcon: icon != null
              ? IconButton(
                  icon: Icon(icon),
                  onPressed: onIconPressed ?? () {},
                )
              : null,
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keeps the label always at the top
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ));
  }
}
