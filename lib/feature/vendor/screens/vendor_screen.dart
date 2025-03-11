import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/data_widget.dart';

class VendorScreen extends ConsumerWidget {
  const VendorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Vendor Master'),
          actions: [
            AppBarButtons(
              ontap: [
                () {
                  log('new pressed');
                  context.push('/addVendorScreen');
                },
                () {},
                () {
                  // Reset the provider value to null on refresh
                  ref.invalidate(itemTypeFutureProvider);
                },
                () {}
              ],
            )
          ],
        ),
        body: const ItemDataScreen(
          title: '',
          endUrl: 'Master/PartySpecific/vendors/',
        ));
  }
}
