import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/vendor_model.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/feature/vendor/controller/vendor_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/check_box.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/icon_text_button_widget.dart';
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
    defaultTerm.dispose();
    vendorCode.dispose();
    vendorName.dispose();
    super.dispose();
  }

  final List<String> content = [
    'Parent Form',
    //'Item Attribute',
    // 'Bank Information',
    // 'Location Mapping',
    // 'Supporting Document',
    // 'Vendor Address',
    // 'Vendor Attribute Mapping',
    // 'Vendor Operation Setting',
  ];
  @override
  Widget build(BuildContext context) {
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            final config = Vendor(
                gstRegistrationType: textFieldvalues['GST Registration Type']!,
                initials: initial.text,
                vendorCode: vendorCode.text,
                vendorName: vendorName.text,
                defaultCurrency: textFieldvalues['Default Currency']!,
                agentName: '',
                defaultTerms: textFieldvalues['Default Term']!,
                rowStatus: dropDownValue['Row Status'] ?? 'Active',
                logoFileName: logoFileName.text,
                localSalesTaxNo: localSalesTaxNo.text,
                salesTaxNo: salesTaxNo.text,
                panNo: panNo.text,
                aadharNo: aadharNo.text,
                msmeCertificateNo: msmeCertificateNo.text,
                vendorType: dropDownValue['Vendor Type'] ?? 'On Time',
                tanNo: tanNo.text,
                vanNo: vatNo.text,
                gstNo: gstNo.text,
                msmeRegistered: dropDownValue['MSME Registred'] ?? 'Yes',
                allowWastage: dropDownValue['MSME Wastage'] ?? 'No',
                allowLabour: dropDownValue['Allow Labour'] ?? 'None',
                correspondingLocation: 'To be replaced',
                nominatedAgency: isChecked['Nominated Agency'] ?? false,
                exchangePercent: exchangePercentage.text,
                returnsTerm: returnTerms.text,
                udyogAdharNo: udyogAdharNumber.text,
                exchangeTerms: dropDownValue['Exchange Terms'] ?? 'No Exchange',
                tds194Q: dropDownValue['TDS194Q'] ?? 'No');

            ref
                .read(vendorControllerProvider.notifier)
                .submitVendorConfiguration(config, context);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
          child: !ref.watch(vendorControllerProvider)
              ? const Text(
                  'Save',
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
                      padding: const EdgeInsets.all(8.0), child: parentForm())),
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
          hintText: textFieldvalues['GST Registration Type'] ??
              'GST Registration Type',
          labelText: 'GST Registration',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'GST Registration Type',
                endUrl: 'Global/GstRegistration',
                value: 'CONFIG CODE',
              ),
            );
          },
        ),
        TextFieldWidget(
          controller: initial,
          labelText: 'Initials',
        ),
        TextFieldWidget(
          controller: vendorCode,
          labelText: 'Vendor Code',
        ),
        TextFieldWidget(
          controller: vendorName,
          labelText: 'Vendor Name',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Default Currency'] ?? 'Default Currency',
          labelText: 'Default Currency',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Default Currency',
                endUrl: 'Global/DefaultCurrency',
                value: 'CURRENCY NAME',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Default Term'] ?? 'Default Term',
          labelText: 'Default Term',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Default Term',
                endUrl: 'Global/TermsMaster',
                value: 'TERMS TYPE',
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
          controller: logoFileName,
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
        TextFieldWidget(
          labelText: 'PAN No',
          controller: panNo,
        ),
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
        const DropDownTextFieldWidget(
          initialValue: 'Yes',
          items: ['Yes', 'No'],
          labelText: 'MSME Registred',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'No',
          items: ['Yes', 'No', 'Manual'],
          labelText: 'Allow Wastage',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'None',
          items: ['Automatic', 'None', 'Manual'],
          labelText: 'Allow Labour',
        ),
        const ReadOnlyTextFieldWidget(
            labelText: 'Corresponding',
            hintText: 'Corresponding',
            icon: Icons.search),
        const CheckBoxWidget(labelText: 'Nominated Agency'),
        NumberTextFieldWidget(
            labelText: 'Exchange %', controller: exchangePercentage),
        TextFieldWidget(labelText: 'Return Terms', controller: returnTerms),
        TextFieldWidget(
            labelText: 'Udyog Adhar Number', controller: udyogAdharNumber),
        const DropDownTextFieldWidget(
          initialValue: 'No Exchange',
          items: [
            'No Exchange',
            'Not Applicable',
            'With Making',
            'Without Making'
          ],
          labelText: 'Exchange Terms',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'No',
          items: [
            'Yes',
            'No',
          ],
          labelText: 'TDS194Q',
        ),
      ],
    );
  }
}
