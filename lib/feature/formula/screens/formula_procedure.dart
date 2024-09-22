import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/formula/controller/forular_prtocedure_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/data_widget.dart';

class FormulaProcdedureScreen extends ConsumerWidget {
  const FormulaProcdedureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Formula Procedure Master details'),
          actions: [
            AppBarButtons(
              ontap: [
                () {
                  log('new pressed');
                  context.go('/addFormulaProcedureScreen');
                },
                () {},
                () {
                  // Reset the provider value to null on refresh
                  ref.watch(formulaProcedureProvider.notifier).state = [
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
          endUrl: 'AllAttribute/',
        ));
  }
}
