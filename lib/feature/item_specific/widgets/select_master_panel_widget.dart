import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';

class SelectMasterPanelWidget extends ConsumerWidget {
  final String title;
  final List<String> items;
  const SelectMasterPanelWidget(
      {super.key, required this.title, required this.items});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterType = ref.watch(masterTypeProvider);
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12.0, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Color.fromARGB(160, 158, 158, 158)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            ref.watch(masterTypeProvider.notifier).state = [
                              masterType[0],
                              items[index],
                              'item master'
                            ];
                          },
                          child: const Text(
                            'Item',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            ref.watch(masterTypeProvider.notifier).state = [
                              masterType[0],
                              items[index],
                              'variant master'
                            ];
                          },
                          child: const Text(
                            'Variant',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
