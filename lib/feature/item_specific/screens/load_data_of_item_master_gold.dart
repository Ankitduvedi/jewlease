import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/feature/item_specific/widgets/left_side_pannel_load_item_master_gold.dart';
import 'package:jewlease/feature/item_specific/widgets/right_side_pannel_load_item_master_gold.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/item_attribute_widget.dart';
import 'package:jewlease/widgets/load_item_attribute_widget.dart';

class ItemMasterGoldScreen extends ConsumerStatefulWidget {
  const ItemMasterGoldScreen(
      {super.key,
      required this.title,
      required this.endUrl,
      this.value,
      this.query});
  final String title;
  final String endUrl;
  final String? value;
  final String? query;

  @override
  ItemMasterGoldScreenState createState() => ItemMasterGoldScreenState();
}

class ItemMasterGoldScreenState extends ConsumerState<ItemMasterGoldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(widget.title),
          actions: [
            AppBarButtons(
              ontap: [
                () {},
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
        body: Row(
          children: [
            Expanded(
              child: LeftPannelSearchWidget(
                endUrl: widget.endUrl,
                title: widget.title,
              ),
            ),
            const Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(child: CustomInfoSection()),
                  Expanded(
                    child: LoadItemAttributesScreen(
                      attributeTypes: [
                        'HSN - SAC CODE',
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
