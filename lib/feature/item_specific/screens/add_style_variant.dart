import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/feature/vendor/screens/Bom&Operation.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/icon_text_button_widget.dart';
import 'package:jewlease/widgets/item_attribute_widget.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

import '../../vendor/controller/bom_controller.dart';

class AddStyleVariantScreen extends ConsumerStatefulWidget {
  const AddStyleVariantScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddStyleVariantScreenState();
  }
}

class AddStyleVariantScreenState extends ConsumerState<AddStyleVariantScreen> {
  final TextEditingController metalCode = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController reorderQty = TextEditingController();
  final TextEditingController stdBuyingRate = TextEditingController();
  final TextEditingController stdSellingRate = TextEditingController();
  final TextEditingController variantName = TextEditingController();

  @override
  void dispose() {
    metalCode.dispose();
    description.dispose();
    super.dispose();
  }

  final List<String> content = [
    'Parent Form',
    'Item Attribute',
    'BOM & Operation',
    'Attachment'
  ];
  @override
  Widget build(BuildContext context) {
    final selectedContent = ref.watch(formSequenceProvider);
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);
    final masterType = ref.watch(masterTypeProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            if (selectedContent == 0) {
              ref.read(formSequenceProvider.notifier).state = 1;
            }
            if (selectedContent == 1) {
              final config = VariantMasterMetal(
                  rowStatus: dropDownValue['Row Status'] ?? 'Active',
                  createdDate: DateTime.timestamp(),
                  updateDate: DateTime.timestamp(),
                  metalName: textFieldvalues['Metal code']!,
                  variantType: dropDownValue['Variant Type'] ?? 'STYLE',
                  baseMetalVariant: '24Kt',
                  stdSellingRate: double.parse(stdSellingRate.text),
                  stdBuyingRate: double.parse(stdBuyingRate.text),
                  reorderQty: int.parse(reorderQty.text),
                  usedInBom: dropDownValue['Used As BOM'] ?? 'Yes',
                  canReturnInMelting:
                      isChecked['Can Return In Melting'] ?? false,
                  metalColor: textFieldvalues['METAL COLOR']!,
                  karat: textFieldvalues['KARAT']!);

              ref
                  .read(itemSpecificControllerProvider.notifier)
                  .submitMetalVariantConfiguration(config, context);
            }
            if (selectedContent == 2) {
              final bomNotifier = ref.read(bomProvider.notifier);
              final operationNotifier = ref.read(OperationProvider.notifier);
            }
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
          child: !ref.watch(itemSpecificControllerProvider)
              ? Text(
                  selectedContent == 0 ? 'Next' : 'Save',
                  style: const TextStyle(color: Colors.white),
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
        title: Text('Variant Master (Item Group - ${masterType[1]})'),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color of the container
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow color
                spreadRadius: 1, // How far the shadow spreads
                blurRadius: 8, // Softens the shadow
                offset: const Offset(
                    4, 4), // Moves the shadow horizontally and vertically
              ),
            ],
            border: Border.all(
              color: const Color.fromARGB(
                  255, 219, 219, 219), // Outline (border) color
              width: 2.0, // Border width
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 8,
              ),
              Wrap(
                direction: Axis.vertical,
                spacing: 8.0,
                children: content.asMap().entries.map((entry) {
                  return IconTextButtonWidget(
                    labelText: entry.value,
                    index: entry.key, // Passing the index to the widget
                  );
                }).toList(),
              ),
              const SizedBox(
                width: 8,
              ),
              const VerticalDivider(),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectedContent == 0
                    ? parentForm()
                    : selectedContent == 1
                        ? const ItemAttributesScreen(
                            attributeTypes: [
                              {
                                'title': 'CATEGORY',
                                'key': 'CATEGORY',
                                'value': 'AttributeCode',
                                'endUrl': 'AllAttribute',
                                'query': 'CATEGORY'
                              },
                              {
                                'title': 'SUB CATEGORY',
                                'key': 'SUB CATEGORY',
                                'value': 'AttributeCode',
                                'endUrl': 'AllAttribute',
                                'query': 'SUB CATEGORY'
                              },
                              {
                                'title': 'STYLE KARAT',
                                'key': 'STYLE KARAT',
                                'value': 'AttributeCode',
                                'endUrl': 'AllAttribute',
                                'query': 'STYLE KARAT'
                              },
                              {
                                'title': 'VARIETY',
                                'key': 'VARIETY',
                                'value': 'AttributeCode',
                                'endUrl': 'AllAttribute',
                                'query': 'VARIETY'
                              },
                              {
                                'title': 'HSN-SAC CODE',
                                'key': 'HSN-SAC CODE',
                                'value': 'AttributeCode',
                                'endUrl': 'AllAttribute',
                                'query': 'HSN-SAC CODE'
                              },
                              {
                                'title': 'LINE OF BUSINESS',
                                'key': 'LINE OF BUSINESS',
                                'value': 'AttributeCode',
                                'endUrl': 'AllAttribute',
                                'query': 'LINE OF BUSINESS'
                              },
                            ],
                          )
                        : selectedContent == 2
                            ? SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: screenHeight * 0.7,
                                    child: MyDataGrid()),
                              )
                            : Text('data'),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget parentForm() {
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    return GridView.count(
      crossAxisCount: 6,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      childAspectRatio: 4.5,
      children: [
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Style'] ?? 'Style',
          labelText: 'Style',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Style',
                endUrl: 'ItemMasterAndVariants/Metal/Gold/Item/',
                value: 'Style',
              ),
            );
          },
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Variant Name',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Old Variant',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Customer Variant',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Vendor'] ?? 'Vendor',
          labelText: 'Vendor',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Vendor',
                endUrl: 'ItemMasterAndVariants/Metal/Gold/Item/',
                value: 'Vendor',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Base Variant'] ?? 'Base Variant',
          labelText: 'Base Variant',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Base Variant',
                endUrl: 'ItemMasterAndVariants/Metal/Gold/Item/',
                value: 'Base Variant',
              ),
            );
          },
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Remark 1',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Vendor Variant',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Remark 2',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Created By'] ?? 'Created By',
          labelText: 'Created By',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Created By',
                endUrl: 'ItemMasterAndVariants/Metal/Gold/Item/',
                value: 'Created By',
              ),
            );
          },
        ),
        NumberTextFieldWidget(
          controller: stdBuyingRate,
          labelText: 'Std.Buying Rate',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Stone Max wt',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Remark',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Stone Min wt',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Karat color',
        ),
        NumberTextFieldWidget(
          controller: stdBuyingRate,
          labelText: 'Delivery Days',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'No',
          items: ['Yes', 'No'],
          labelText: 'For Web',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Active',
          items: ['InActive', 'Active'],
          labelText: 'Row Status',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Verified Status',
        ),
        NumberTextFieldWidget(
          controller: stdSellingRate,
          labelText: 'Length',
        ),
        TextFieldWidget(
          controller: variantName,
          labelText: 'Codegen Sr no',
        ),
      ],
    );
  }
}
