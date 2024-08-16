import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/feature/item_specific/widgets/app_bar_buttons.dart';
import 'package:jewlease/feature/item_specific/widgets/header_button_widget.dart';
import 'package:jewlease/feature/item_specific/widgets/select_master_panel_widget.dart';
import 'package:jewlease/feature/item_specific/widgets/variant_master_panel_widget.dart';

class MasterScreen extends ConsumerStatefulWidget {
  const MasterScreen({super.key});

  @override
  MasterScreenState createState() => MasterScreenState();
}

class MasterScreenState extends ConsumerState<MasterScreen> {
  // Define different content for each category
  final Map<String, List<String>> categoryContent = {
    'Style': ['Style', 'Style(Pcs)', 'Style(Wt)'],
    'Metal': ['Gold', 'Platinum', 'Silver', 'Bronze'],
    'Stone': [
      'Diamond',
      'Pearl',
      'Precious Stone',
      'Semi Precious Stone',
      'Zircon',
      'Polki',
      'Diamond Solitaire'
    ],
    'Consumables': ['Consumables(Wt)', 'Consumables-Cts'],
    'Set': ['Set'],
    'Certificate': ['Style Certificate', 'Stone Certificate'],
    'Packing Material': ['Packing Materials'],
  };

  @override
  Widget build(BuildContext context) {
    // Access the current value of the master type from the provider
    final masterType = ref.watch(masterTypeProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('data'),
        actions: const [AppBarButtons()],
      ),
      body: Column(
        children: [
          // Header buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8.0,
              children: categoryContent.keys.map((category) {
                return HeaderButtonWidget(category: category);
              }).toList(),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // Left panel (Select Master)
                Expanded(
                  flex: 2,
                  child: SelectMasterPanelWidget(
                    title: 'Select Master',
                    items: categoryContent[masterType[0]] ?? [],
                  ),
                ),
                // Right panel (Select Item or Variant Master)
                const Expanded(
                  flex: 3,
                  child: VariantMasterPanelWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
