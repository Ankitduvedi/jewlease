import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/feature/item_specific/widgets/left_side_pannel_load_item_master_gold.dart';
import 'package:jewlease/feature/item_specific/widgets/right_side_pannel_load_item_master_stone.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/load_item_attribute_widget.dart';

class ItemMasterStoneScreen extends ConsumerStatefulWidget {
  const ItemMasterStoneScreen({super.key, this.value, this.query});

  final String? value;
  final String? query;

  @override
  ItemMasterStoneScreenState createState() => ItemMasterStoneScreenState();
}

class ItemMasterStoneScreenState extends ConsumerState<ItemMasterStoneScreen> {
  @override
  Widget build(BuildContext context) {
    final masterType = ref.watch(masterTypeProvider);

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text('Variant Master (Item Group- ${masterType[1]})'),
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
                endUrl:
                    'ItemMasterAndVariants/Stone/${masterType[1]!.replaceAll(' ', '')}/Item/',
                title: 'Variant Master (Item Group- ${masterType[1]})',
              ),
            ),
            const Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(child: StoneItemInfoSection()),
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
