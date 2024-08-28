import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

class VariantMasterPanelWidget extends ConsumerWidget {
  VariantMasterPanelWidget({super.key});
  final TextEditingController itemType = TextEditingController();
  final TextEditingController itemGroup = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final masterType = ref.watch(masterTypeProvider);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 12, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Item or Variant Master',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Form HDR ID: 327',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const Divider(color: Color.fromARGB(160, 158, 158, 158)),
          if (masterType[2] == null)
            const Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  'Select master to load filter',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
          if (masterType[2] != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12, 12, 12),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ref.read(masterTypeProvider.notifier).state = [
                        masterType[0],
                        masterType[1],
                        'item master'
                      ];
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: masterType[2] == 'item master'
                          ? const Color.fromARGB(255, 0, 52, 80)
                          : Colors.white,
                    ),
                    child: Text(
                      'Item Master',
                      style: TextStyle(
                        color: masterType[2] == 'item master'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      ref.read(masterTypeProvider.notifier).state = [
                        masterType[0],
                        masterType[1],
                        'variant master'
                      ];
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: masterType[2] == 'variant master'
                          ? const Color.fromARGB(255, 0, 52, 80)
                          : Colors.white,
                    ),
                    child: Text(
                      'Variant Master',
                      style: TextStyle(
                        color: masterType[2] == 'variant master'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: const Color.fromARGB(255, 5, 168, 84),
                    ),
                    child: const Text(
                      'View Catalog',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          if (masterType[2] != null) const SizedBox(height: 10),
          if (masterType[2] != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3.5,
                  children: [
                    ReadOnlyTextFieldWidget(
                        labelText: 'Item Type',
                        hintText: masterType[0] ?? 'Item Type'),
                    ReadOnlyTextFieldWidget(
                        labelText: 'Item Group...*',
                        hintText: masterType[1] ?? 'Item Group...*'),
                    if (masterType[2] == 'variant master')
                      const TextFieldWidget(labelText: 'Variant Name'),
                    const TextFieldWidget(labelText: 'Item Name'),
                    if (masterType[2] == 'variant master')
                      const TextFieldWidget(labelText: 'Old Variant Name'),
                    if (masterType[2] == 'variant master')
                      const TextFieldWidget(labelText: 'Attribute Description'),
                    if (masterType[2] == 'variant master')
                      const TextFieldWidget(labelText: 'Variant Remark'),
                    if (masterType[2] == 'variant master')
                      const TextFieldWidget(labelText: 'Customer Variant Name'),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: const Color.fromARGB(255, 40, 112, 62),
                      ),
                      child: const Text(
                        'Load',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
