import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/main.dart';

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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return TextField(
        onTap: () {
          // Prevent any interaction with the text field
        },

        //enabled: false,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 12),
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 13),

          suffixIcon: icon != null
              ? IconButton(
                  icon: Icon(
                    icon,
                    size: 17,
                  ),
                  onPressed: onIconPressed ?? () {},
                )
              : null,
          floatingLabelBehavior:
              FloatingLabelBehavior.always, // Keeps the label always at the top
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        ));
  }
}
