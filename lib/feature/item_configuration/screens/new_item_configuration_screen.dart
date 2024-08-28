import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/item_type_model.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_configuration/widgets/item_dailog_widget.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/check_box.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class AddItemConfigurtionScreen extends ConsumerStatefulWidget {
  const AddItemConfigurtionScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddItemConfigurtionScreenState();
  }
}

class AddItemConfigurtionScreenState
    extends ConsumerState<AddItemConfigurtionScreen> {
  final TextEditingController wastage = TextEditingController();
  final TextEditingController inwardRateTollerance = TextEditingController();
  final TextEditingController inwardRateTollerances = TextEditingController();
  final TextEditingController metalTolleranceDo = TextEditingController();
  final TextEditingController metalTolleranceUp = TextEditingController();
  final TextEditingController alloyTolleranceDo = TextEditingController();
  final TextEditingController alloyTolleranceDow = TextEditingController();

  @override
  void dispose() {
    wastage.dispose();
    inwardRateTollerance.dispose();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('Item Configuration'),
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
                      ReadOnlyTextFieldWidget(
                        hintText: textFieldvalues['Item Type'] ?? 'Item Type',
                        labelText: 'Item Type',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemTypeDialogScreen(
                              title: 'Item Type',
                              endUrl: 'ItemConfiguration/ItemType/',
                            ),
                          );
                        },
                      ),
                      ReadOnlyTextFieldWidget(
                        hintText: textFieldvalues['Item Group'] ?? 'Item Group',
                        labelText: 'Item Group',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemTypeDialogScreen(
                              title: 'Item Group',
                              endUrl: 'ItemConfiguration/ItemGroup/',
                            ),
                          );
                        },
                      ),
                      ReadOnlyTextFieldWidget(
                        hintText:
                            textFieldvalues['Item Nature'] ?? 'Item Nature',
                        labelText: 'Item Nature',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemTypeDialogScreen(
                              title: 'Item Nature',
                              endUrl: 'ItemConfiguration/ItemNature/',
                            ),
                          );
                        },
                      ),
                      ReadOnlyTextFieldWidget(
                        hintText: textFieldvalues['Stock UOM'] ?? 'Stock UOM',
                        labelText: 'Stock UOM',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemTypeDialogScreen(
                              title: 'Stock UOM',
                              endUrl: 'ItemConfiguration/StockUOM/',
                            ),
                          );
                        },
                      ),
                      ReadOnlyTextFieldWidget(
                        hintText:
                            textFieldvalues['Dependent Cr'] ?? 'Dependent Cr',
                        labelText: 'Dependent Cr',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemTypeDialogScreen(
                              title: 'Dependent Cr',
                              endUrl: 'ItemConfiguration/DependentCriteria/',
                            ),
                          );
                        },
                      ),
                      const CheckBoxWidget(
                        labelText: 'BOM Indicator',
                      ),
                      const CheckBoxWidget(
                        labelText: 'LOT Management Indicator',
                      ),
                      _buildFormField('Other Loss I...', Icons.search),
                      const CheckBoxWidget(
                        labelText: 'Custom Stock Reqd Ind',
                      ),
                      _buildNumberInputField('Wastage(%)', wastage),
                      _buildNumberInputField(
                          'Inward Rate Tollerance', inwardRateTollerance),
                      _buildNumberInputField(
                          'Inward Rate Tollerance', inwardRateTollerances),
                      const CheckBoxWidget(
                        labelText: 'Operation Reqd Ind',
                      ),
                      const CheckBoxWidget(
                        labelText: 'Row Creation Ind',
                      ),
                      NumberTextFieldWidget(
                        controller: metalTolleranceDo,
                        labelText: 'Metal Tollerance(Do..)',
                      ),
                      NumberTextFieldWidget(
                        controller: metalTolleranceUp,
                        labelText: 'Metal Tollerance(Up..)',
                      ),
                      NumberTextFieldWidget(
                        controller: alloyTolleranceDo,
                        labelText: 'Alloy Tollerance(Do..)',
                      ),
                      NumberTextFieldWidget(
                        controller: alloyTolleranceDow,
                        labelText: 'Alloy Tollerance(Do..)',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Previous and Next Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final config = ItemConfiguration(
                          itemType: textFieldvalues['Item Type']!,
                          itemGroup: textFieldvalues['Item Group']!,
                          itemNature: textFieldvalues['Item Nature']!,
                          lotManagementIndicator:
                              isChecked['LOT Management Indicator'] ?? false,
                          customStockReqdInd:
                              isChecked['Custom Stock Reqd Ind'] ?? false,
                          bomIndicator: isChecked['BOM Indicator'] ?? false,
                          operationReqdInd:
                              isChecked['Operation Reqd Ind'] ?? false,
                          metalToleranceDown:
                              double.parse(metalTolleranceDo.text),
                          metalToleranceUp:
                              double.parse(metalTolleranceUp.text),
                          alloyToleranceDown:
                              double.parse(alloyTolleranceDo.text),
                          stockUom: textFieldvalues['Stock UOM']!,
                          dependentCriteria: textFieldvalues['Dependent Cr']!,
                          otherLossIndicator: '',
                          wastagePercentage: double.parse(wastage.text),
                          inwardRateToleranceUp:
                              double.parse(inwardRateTollerance.text),
                          inwardRateToleranceDown:
                              double.parse(inwardRateTollerances.text),
                          rowCreationInd:
                              isChecked['Row Creation Ind'] ?? false,
                          alloyToleranceUp:
                              double.parse(alloyTolleranceDow.text),
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
                          backgroundColor:
                              const Color.fromARGB(255, 40, 112, 62)),
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
                ),
              ],
            ),
          ),
        ));
  }

  // Method to build a form field with an optional icon
  Widget _buildFormField(String labelText, IconData? icon,
      {VoidCallback? onIconPressed}) {
    return TextField(
      // Set to true if the field is meant to be non-editable
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: icon != null
            ? IconButton(
                icon: Icon(icon),
                onPressed: onIconPressed ?? () {},
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildNumberInputField(
      String labelText, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.right, // Text starts entering from the right
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allows digits
      ],
      decoration: InputDecoration(
        labelText: labelText,
        hintText: '0',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
