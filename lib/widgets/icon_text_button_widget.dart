import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class IconTextButtonWidget extends ConsumerWidget {
  final String labelText;
  final int index;

  const IconTextButtonWidget(
      {super.key, required this.labelText, required this.index});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(formSequenceProvider);
    return TextButton.icon(
      onPressed: () {
        ref.read(formSequenceProvider.notifier).state = index;
      },
      label: Text(
        labelText,
        style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 3, 102, 200)),
      ),
      icon: Icon(selected == index ? Icons.circle : Icons.circle_outlined),
    );
  }
}
