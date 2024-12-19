import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/variant_master_metal.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/check_box.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/icon_text_button_widget.dart';
import 'package:jewlease/widgets/item_attribute_widget.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';

class AddStoneVariantScreen extends ConsumerStatefulWidget {
  const AddStoneVariantScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddStoneVariantScreenState();
  }
}

class AddStoneVariantScreenState extends ConsumerState<AddStoneVariantScreen> {
  final TextEditingController metalCode = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController averageWeight = TextEditingController();
  final TextEditingController stdBuyingRate = TextEditingController();
  final TextEditingController stdSellingRate = TextEditingController();

  @override
  void dispose() {
    metalCode.dispose();
    description.dispose();
    super.dispose();
  }

  final List<String> content = [
    'Parent Form',
    'Item Attribute',
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
                  reorderQty: int.parse(averageWeight.text),
                  usedInBom: dropDownValue['Used As BOM'] ?? 'Yes',
                  canReturnInMelting:
                      isChecked['Can Return In Melting'] ?? false,
                  metalColor: textFieldvalues['METAL COLOR']!,
                  karat: textFieldvalues['KARAT']!);

              ref
                  .read(itemSpecificControllerProvider.notifier)
                  .submitMetalVariantConfiguration(
                      config, context, masterType[1]!);
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
                    : const ItemAttributesScreen(
                        attributeTypes: [
                          {
                            'title': 'METAL COLOR',
                            'key': 'METAL COLOR',
                            'value': 'AttributeCode',
                            'endUrl': 'AllAttribute',
                            'query': 'METAL COLOR'
                          },
                          {
                            'title': 'KARAT',
                            'key': 'KARAT',
                            'value': 'AttributeCode',
                            'endUrl': 'AllAttribute',
                            'query': 'KARAT'
                          }
                        ],
                      ),
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
          hintText: textFieldvalues['Stone code'] ?? 'Stone code',
          labelText: 'Stone Code',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Stone code',
                endUrl: 'ItemMasterAndVariants/Stone/Diamond/Item/',
                value: 'Stone code',
              ),
            );
          },
        ),
        const DropDownTextFieldWidget(
          initialValue: 'STYLE',
          items: ['STYLE', 'STYLEDESIGN'],
          labelText: 'Variant Type',
        ),
        const ReadOnlyTextFieldWidget(
          hintText: '24Kt',
          labelText: 'Base Metal Variant',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Vendor Name'] ?? 'Vendor Name',
          labelText: 'Vendor Name',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Vendor Name',
                endUrl: 'Master/PartySpecific/vendors/',
                value: 'Vendor Name',
              ),
            );
          },
        ),
        NumberTextFieldWidget(
          controller: stdSellingRate,
          labelText: 'Std.Selling Rate',
        ),
        NumberTextFieldWidget(
          controller: stdBuyingRate,
          labelText: 'Std.Buying Rate',
        ),
        NumberTextFieldWidget(
          controller: averageWeight,
          labelText: 'Average Weight',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Yes',
          items: ['No', 'Yes'],
          labelText: 'Used As BOM',
        ),
        const CheckBoxWidget(
          labelText: 'Can Return In Melting',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Active',
          items: ['InActive', 'Active'],
          labelText: 'Row Status',
        )
      ],
    );
  }
}
