import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';

class HeaderButtonWidget extends ConsumerWidget {
  final String category;
  const HeaderButtonWidget({super.key, required this.category});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Update the provider value, which automatically triggers UI rebuild
        ref.read(masterTypeProvider.notifier).state = [category, null, null];
      },
      style: ElevatedButton.styleFrom(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: ref.watch(masterTypeProvider)[0] == category
            ? const Color.fromARGB(255, 0, 52, 80)
            : Colors.white,
      ),
      child: Text(
        category,
        style: TextStyle(
          color: ref.watch(masterTypeProvider)[0] == category
              ? Colors.white
              : Colors.black,
        ),
      ),
    );
  }
}
