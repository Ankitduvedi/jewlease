import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class CheckBoxWidget extends ConsumerWidget {
  final String labelText;

  const CheckBoxWidget({super.key, required this.labelText});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    return Row(
      children: [
        Checkbox(
          value: isChecked[labelText] ?? false,
          onChanged: (bool? value) {
            //Update the state when the checkbox is pressed
            ref
                .read(chechkBoxSelectionProvider.notifier)
                .updateSelection(labelText, value!);
          },
          activeColor: Colors.green, // Optional: Set the color of the tick
        ),
        Expanded(
          child: Text(labelText),
        ),
      ],
    );
  }
}
