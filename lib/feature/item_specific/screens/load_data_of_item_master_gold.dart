import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/feature/item_specific/widgets/left_side_pannel_load_item_master_gold.dart';
import 'package:jewlease/feature/item_specific/widgets/right_side_pannel_load_item_master_gold.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

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
          title: Text(widget.title),
          actions: [
            AppBarButtons(
              ontap: [
                () {
                  log('new pressed');
                  context.push('/addAttributeScreen');
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
        body: Row(
          children: [
            Expanded(
              child: LeftPannelSearchWidget(
                endUrl: widget.endUrl,
                title: widget.title,
              ),
            ),
            const Expanded(flex: 3, child: CustomInfoSection())
          ],
        ));
  }
}
