import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
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
        actions: [
          AppBarButtons(
            ontap: [
              () {
                log('new pressed');
                if (masterType[1] != null && masterType[2] == 'item master') {
                  if (masterType[0] == 'Style') {
                    context.push('/masterScreen/addStyleItemScreen');
                  } else if (masterType[0] == 'Metal') {
                    context.push('/masterScreen/addMetalItemScreen');
                  } else if (masterType[0] == 'Stone') {
                    context.push('/masterScreen/addStoneItemScreen');
                  } else if (masterType[0] == 'Consumables') {
                    context.push('/masterScreen/addConsumablesItemScreen');
                  } else if (masterType[0] == 'Set') {
                    context.push('/masterScreen/addSetItemScreen');
                  } else if (masterType[0] == 'Certificate') {
                    context.push('/masterScreen/addCertificateItemScreen');
                  } else if (masterType[0] == 'Packing Material') {
                    context.push('/masterScreen/addPackingMaterialItemScreen');
                  }
                } else if (masterType[1] != null &&
                    masterType[2] == 'variant master') {
                  if (masterType[0] == 'Metal') {
                    context.push('/masterScreen/addMetalVariantScreen');
                  }
                }
              },
              () {},
              () {
                // Reset the provider value to null on refresh
                ref.watch(masterTypeProvider.notifier).state = [
                  'Style',
                  null,
                  null
                ];
              },
              () {}
            ],
          )
        ],
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
                Expanded(
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
