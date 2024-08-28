import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/item_type_model.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/check_box.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

class AddMetalItemScreen extends ConsumerStatefulWidget {
  const AddMetalItemScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddMetalItemScreenState();
  }
}

class AddMetalItemScreenState extends ConsumerState<AddMetalItemScreen> {
  final TextEditingController metalCode = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController inwardRateTollerances = TextEditingController();
  final TextEditingController metalTolleranceDo = TextEditingController();
  final TextEditingController metalTolleranceUp = TextEditingController();
  final TextEditingController alloyTolleranceDo = TextEditingController();
  final TextEditingController alloyTolleranceDow = TextEditingController();

  @override
  void dispose() {
    metalCode.dispose();
    description.dispose();
    inwardRateTollerances.dispose();
    metalTolleranceDo.dispose();
    metalTolleranceUp.dispose();
    alloyTolleranceDo.dispose();
    alloyTolleranceDow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = ref.watch(chechkBoxSelectionProvider);

    final textFieldvalues = ref.watch(dialogSelectionProvider);
    return Scaffold(
        persistentFooterButtons: [
          ElevatedButton(
            onPressed: () {
              final config = ItemConfiguration(
                itemType: textFieldvalues['Item Type']!,
                itemGroup: textFieldvalues['Item Group']!,
                itemNature: textFieldvalues['Item Nature']!,
                lotManagementIndicator:
                    isChecked['LOT Management Indicator'] ?? false,
                customStockReqdInd: isChecked['Custom Stock Reqd Ind'] ?? false,
                bomIndicator: isChecked['BOM Indicator'] ?? false,
                operationReqdInd: isChecked['Operation Reqd Ind'] ?? false,
                metalToleranceDown: double.parse(metalTolleranceDo.text),
                metalToleranceUp: double.parse(metalTolleranceUp.text),
                alloyToleranceDown: double.parse(alloyTolleranceDo.text),
                stockUom: textFieldvalues['Stock UOM']!,
                dependentCriteria: textFieldvalues['Dependent Cr']!,
                otherLossIndicator: '',
                wastagePercentage: double.parse(metalCode.text),
                inwardRateToleranceUp: double.parse(description.text),
                inwardRateToleranceDown:
                    double.parse(inwardRateTollerances.text),
                rowCreationInd: isChecked['Row Creation Ind'] ?? false,
                alloyToleranceUp: double.parse(alloyTolleranceDow.text),
              );
              ref
                  .read(itemConfigurationControllerProvider.notifier)
                  .submitItemConfiguration(config, context);
            },
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
            child: !ref.watch(itemConfigurationControllerProvider)
                ? const Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
          ),
        ],
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('Item Master (Item Group - Gold)'),
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
        body: Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form Title
                const Text(
                  'Parent Form',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 3, 102, 200)),
                ),
                const SizedBox(height: 16),
                // Form Fields
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 4.5,
                    children: [
                      TextFieldWidget(
                        controller: metalCode,
                        labelText: 'Metal Code',
                      ),
                      const CheckBoxWidget(
                        labelText: 'Exclusive Indicator',
                      ),
                      TextFieldWidget(
                        controller: description,
                        labelText: 'Description',
                      ),
                    ],
                  ),
                ),

                // Previous and Next Buttons
              ],
            ),
          ),
        ));
  }
}
