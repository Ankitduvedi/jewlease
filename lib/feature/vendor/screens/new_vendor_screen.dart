import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/item_master_metal.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/check_box.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/icon_text_button_widget.dart';
import 'package:jewlease/widgets/item_attribute_widget.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

import '../../../widgets/search_dailog_widget.dart';

class AddVendor extends ConsumerStatefulWidget {
  const AddVendor({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddMetalItemScreenState();
  }
}

class AddMetalItemScreenState extends ConsumerState<AddVendor> {
  final TextEditingController metalCode = TextEditingController();
  final TextEditingController panNo = TextEditingController();
  final TextEditingController aadharNo = TextEditingController();
  final TextEditingController msmeCertificateNo = TextEditingController();
  final TextEditingController tanNo = TextEditingController();
  final TextEditingController vatNo = TextEditingController();
  final TextEditingController gstNo = TextEditingController();
  final TextEditingController exchangeTerms = TextEditingController();
  final TextEditingController returnTerms = TextEditingController();
  final TextEditingController udyogAdharNumber = TextEditingController();
  final TextEditingController exchangePercentage = TextEditingController();
  final TextEditingController initial = TextEditingController();
  final TextEditingController localFileName = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController logoFileName = TextEditingController();
  final TextEditingController localSalesTaxNo = TextEditingController();
  final TextEditingController salesTaxNo = TextEditingController();
  final TextEditingController msmeRegistration = TextEditingController();
  final TextEditingController allowWastage = TextEditingController();
  final TextEditingController allowLabour = TextEditingController();
  final TextEditingController corresponding = TextEditingController();
  final TextEditingController tds194Q = TextEditingController();
  final TextEditingController defaultCurrency = TextEditingController();
  final TextEditingController agentName = TextEditingController();
  final TextEditingController defaultTerm = TextEditingController();
  final TextEditingController vendorCode = TextEditingController();
  final TextEditingController vendorName = TextEditingController();

  @override
  void dispose() {
    metalCode.dispose();
    description.dispose();
    panNo.dispose();
    aadharNo.dispose();
    msmeCertificateNo.dispose();
    tanNo.dispose();
    vatNo.dispose();
    gstNo.dispose();
    exchangeTerms.dispose();
    returnTerms.dispose();
    udyogAdharNumber.dispose();
    exchangePercentage.dispose();
    initial.dispose();
    localFileName.dispose();
    logoFileName.dispose();
    localSalesTaxNo.dispose();
    salesTaxNo.dispose();
    msmeRegistration.dispose();
    allowWastage.dispose();
    allowLabour.dispose();
    corresponding.dispose();
    tds194Q.dispose();
    defaultCurrency.dispose();
    agentName.dispose();
    defaultTerm.dispose();
    vendorCode.dispose();
    vendorName.dispose();
    super.dispose();
  }

  final List<String> content = [
    'Parent Form',
    'Item Attribute',
    // 'Bank Information',
    // 'Location Mapping',
    // 'Supporting Document',
    // 'Vendor Address',
    // 'Vendor Attribute Mapping',
    // 'Vendor Operation Setting',
  ];
  @override
  Widget build(BuildContext context) {
    final selectedContent = ref.watch(formSequenceProvider);
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            if (selectedContent == 0) {
              ref.read(formSequenceProvider.notifier).state = 1;
            }
            if (selectedContent == 1) {
              final config = ItemMasterMetal(
                  metalCode: metalCode.text,
                  exclusiveIndicator: isChecked['Exclusive Indicator'] ?? false,
                  description: description.text,
                  rowStatus: dropDownValue['Row Status'] ?? 'Active',
                  createdDate: DateTime.timestamp(),
                  updateDate: DateTime.timestamp(),
                  attributeType: 'HSN - SAC CODE',
                  attributeValue: textFieldvalues['Attribute Code']!);

              ref
                  .read(itemSpecificControllerProvider.notifier)
                  .submitMetalItemConfiguration(config, context, 'Metal');
            }
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
          child: !ref.watch(itemConfigurationControllerProvider)
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
        title: const Text('Vendor Master'),
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
                            'title': 'HSN - SAC CODE',
                            'key': 'HSN - SAC CODE',
                            'value': 'AttributeCode',
                            'endUrl': 'AllAttribute',
                            'query': 'HSN'
                          },
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
    return GridView.count(
      crossAxisCount: 6,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      childAspectRatio: 4.5,
      children: [
        ReadOnlyTextFieldWidget(
          hintText: 'GST Registration',
          labelText: 'GST Registration',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        NumberTextFieldWidget(labelText: 'Initials', controller: initial),
        TextFieldWidget(
          controller: vendorCode,
          labelText: 'Vendor Code',
        ),
        TextFieldWidget(
          controller: vendorName,
          labelText: 'Vendor Name',
        ),
        ReadOnlyTextFieldWidget(
          hintText: 'Default Currency',
          labelText: 'Default Currency',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: 'Agent Name',
          labelText: 'Agent Name',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: 'Default Term...',
          labelText: 'Default Term...',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Active',
          items: ['InActive', 'Active'],
          labelText: 'Row Status',
        ),
        TextFieldWidget(
          controller: localFileName,
          labelText: 'Logo File Name',
        ),
        TextFieldWidget(
          controller: localSalesTaxNo,
          labelText: 'Local Sales Tax No',
        ),
        TextFieldWidget(
          controller: salesTaxNo,
          labelText: 'Sales TAX No',
        ),
        TextFieldWidget(labelText: 'PAN No', controller: panNo),
        TextFieldWidget(
          controller: aadharNo,
          labelText: 'Aadhar No',
        ),
        TextFieldWidget(
          controller: msmeCertificateNo,
          labelText: 'MSME Certificate No',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'On Time',
          items: ['On Time', 'Regular'],
          labelText: 'Vendor Type',
        ),
        TextFieldWidget(
          controller: tanNo,
          labelText: 'TAN No',
        ),
        TextFieldWidget(
          controller: vatNo,
          labelText: 'VAT No',
        ),
        TextFieldWidget(
          controller: gstNo,
          labelText: 'GST No',
        ),
        ReadOnlyTextFieldWidget(
            labelText: 'MSME Registration',
            hintText: 'MSME Registration',
            icon: Icons.search),
        ReadOnlyTextFieldWidget(
            labelText: 'Allow Wastage',
            hintText: 'Allow Wastage',
            icon: Icons.search),
        ReadOnlyTextFieldWidget(
            labelText: 'Allow Labour',
            hintText: 'Allow Labour',
            icon: Icons.search),
        ReadOnlyTextFieldWidget(
            labelText: 'Corresponding',
            hintText: 'Corresponding',
            icon: Icons.search),
        CheckBoxWidget(labelText: 'Nominated Agency'),
        NumberTextFieldWidget(
            labelText: 'Exchange %', controller: exchangePercentage),
        TextFieldWidget(labelText: 'Return Terms', controller: returnTerms),
        TextFieldWidget(
            labelText: 'Udyog Adhar Number', controller: udyogAdharNumber),
        TextFieldWidget(labelText: 'Exchange Terms', controller: exchangeTerms),
        ReadOnlyTextFieldWidget(
            labelText: 'TDS194Q', hintText: 'TDS194Q', icon: Icons.search),
      ],
    );
  }
}
