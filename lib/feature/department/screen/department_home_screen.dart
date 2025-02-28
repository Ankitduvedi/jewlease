import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/data_widget.dart';

class DepartmentHomeScreen extends ConsumerWidget {
  const DepartmentHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Departments'),
          actions: [
            AppBarButtons(
              ontap: [
                () {
                  log('new pressed');
                  context.push('/departmentHomeScreen/adddDepartmentScreen');
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
        body: ItemDataScreen(
          title: '',
          endUrl: 'Global/Department',
        ));
  }
}
