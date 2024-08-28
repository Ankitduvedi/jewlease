import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/widgets/data_widget.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

class ItemCodeGenerationScreen extends ConsumerWidget {
  const ItemCodeGenerationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Item Code Generation'),
          actions: [
            AppBarButtons(
              ontap: [
                () {
                  log('new pressed');
                  context.push('/addItemCodeGenerationScreen');
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
        body: const ItemDataScreen(
          title: '',
          endUrl: 'ItemCodeGeneration/',
        ));
  }
}
