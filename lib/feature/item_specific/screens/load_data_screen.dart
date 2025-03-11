import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/feature/item_specific/widgets/dynamic_ui.dart';
import 'package:jewlease/feature/item_specific/widgets/left_side_pannel_load_data_widget.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

class LoadDataScreen extends ConsumerStatefulWidget {
  const LoadDataScreen({super.key, this.value, this.query});

  final String? value;
  final String? query;

  @override
  LoadDataScreenState createState() => LoadDataScreenState();
}

class LoadDataScreenState extends ConsumerState<LoadDataScreen> {
  @override
  Widget build(BuildContext context) {
    final masterType = ref.watch(masterTypeProvider);
    final title = '${masterType[2]} Master (Item Group- ${masterType[1]})';
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text(title),
          actions: [
            AppBarButtons(
              ontap: [
                () {},
                () {},
                () {
                  // Reset the provider value to null on refresh
                  ref.read(selectedItemDataProvider.notifier).state = null;
                  ref
                      .read(dialogSelectionProvider.notifier)
                      .clearSelection(title);
                },
                () {}
              ],
            )
          ],
        ),
        body: const Row(
          children: [
            Expanded(
              child: LeftPannelSearchWidget(),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(child: DynamicItemDetailsScreen()),
                ],
              ),
            ),
          ],
        ));
  }
}
