import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/style_variant_model.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/providers/image_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/icon_text_button_widget.dart';
import 'package:jewlease/widgets/image_list.dart';
import 'package:jewlease/widgets/image_upload_dailog_box.dart';
import 'package:jewlease/widgets/item_attribute_widget.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

import '../../procument/screens/procumentBomOprDialog.dart';
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
  final TextEditingController stoneMaxWt = TextEditingController();
  final TextEditingController stoneMinWt = TextEditingController();

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
  ];

  @override
  Widget build(BuildContext context) {
    final selectedContent = ref.watch(formSequenceProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);
    final masterType = ref.watch(masterTypeProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            if (selectedContent == 0) {
              ref.read(formSequenceProvider.notifier).state = 1;
            } else if (selectedContent == 1) {
              ref.read(formSequenceProvider.notifier).state = 2;
            } else if (selectedContent == 2) {
              final bomNotifier = ref.watch(bomProvider);
              final operationNotifier = ref.watch(OperationProvider);
              String generateVariantName() {
                // Extract initials from the fields
                String initials = (textFieldvalues['LINE OF BUSINESS'] ?? "lob")
                    .split(' ')
                    .map((word) => word.isNotEmpty ? word[0] : '')
                    .join()
                    .toUpperCase();

                initials += (textFieldvalues['CATEGORY'] ?? "category")
                    .split(' ')
                    .map((word) => word.isNotEmpty ? word[0] : '')
                    .join()
                    .toUpperCase();

                initials += (textFieldvalues['SUB CATEGORY'] ?? "sub karat")
                    .split(' ')
                    .map((word) => word.isNotEmpty ? word[0] : '')
                    .join()
                    .toUpperCase();

                initials += (textFieldvalues['VARIETY'] ?? "variety")
                    .split(' ')
                    .map((word) => word.isNotEmpty ? word[0] : '')
                    .join()
                    .toUpperCase();

                initials += (textFieldvalues['STYLE KARAT'] ?? "karat")
                    .split(' ')
                    .map((word) => word.isNotEmpty ? word[0] : '')
                    .join()
                    .toUpperCase();

                // Add a unique number (e.g., using current timestamp or an auto-increment logic)
                String uniqueNumber =
                    DateTime.now().millisecondsSinceEpoch.toString();

                return '$initials$uniqueNumber';
              }

              final config = ItemMasterVariant(
                  style: textFieldvalues['Style Name'] ?? 'Style',
                  varientName: generateVariantName(),
                  oldVarient: 'oldVarient',
                  customerVarient: 'customerVarient',
                  baseVarient: 'baseVarient',
                  vendor: textFieldvalues['Vendor Name'] ?? 'Vendor',
                  remark1: 'remark1',
                  vendorVarient: 'vendorVarient',
                  remark2: 'remark2',
                  createdBy: 'createdBy',
                  stdBuyingRate: stdBuyingRate.text,
                  stoneMaxWt: stoneMaxWt.text,
                  remark: 'remark',
                  stoneMinWt: stoneMinWt.text,
                  karatColor: 'karatColor',
                  deliveryDays: 0,
                  forWeb: 'forWeb',
                  rowStatus: dropDownValue['Row Status'] ?? 'Active',
                  verifiedStatus: 'verifiedStatus',
                  length: 0,
                  codegenSrNo: 'codegenSrNo',
                  category: textFieldvalues['CATEGORY'] ?? "category",
                  subCategory: textFieldvalues['SUB CATEGORY'] ?? "sub karat",
                  styleKarat: textFieldvalues['STYLE KARAT'] ?? "karat",
                  varient: textFieldvalues['VARIETY'] ?? " variety",
                  hsnSacCode: textFieldvalues['HSN - SAC CODE'] ?? "",
                  lineOfBusiness: textFieldvalues['LINE OF BUSINESS'] ?? "lob",
                  bom: bomNotifier,
                  operation: operationNotifier,
                  imageDetails: []);

              log(config.toJson().toString());
              log('save button pressed');
              ref
                  .read(itemSpecificControllerProvider.notifier)
                  .submitStyleVariantConfiguration(config, context, ref);
            }
            if (selectedContent == 2) {}
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
          child: !ref.watch(itemSpecificControllerProvider)
              ? Text(
                  selectedContent == 2 ? 'Save' : 'Next',
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
                                'title': 'HSN - SAC CODE',
                                'key': 'HSN - SAC CODE',
                                'value': 'AttributeCode',
                                'endUrl': 'AllAttribute',
                                'query': 'HSN'
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
                        : procumentBomOprDialog(
                          "",
                          0,
                          true,
                          false,
                          isHorizonatal: false,
                        ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget parentForm() {
    final images = ref.watch(imageProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: GridView.count(
            crossAxisCount: 6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 20,
            childAspectRatio: 4.5,
            children: [
              ReadOnlyTextFieldWidget(
                hintText: textFieldvalues['Style Name'] ?? 'Style',
                labelText: 'Style',
                icon: Icons.search,
                onIconPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const ItemTypeDialogScreen(
                      title: 'Style Name',
                      endUrl: 'ItemMasterAndVariants/Style/Style/Item/',
                      value: 'Style Name',
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
                hintText: textFieldvalues['Vendor Name'] ?? 'Vendor',
                labelText: 'Vendor',
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
                      value: 'Metal code',
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
                controller: stoneMaxWt,
                labelText: 'Stone Max wt',
              ),
              TextFieldWidget(
                controller: variantName,
                labelText: 'Remark',
              ),
              TextFieldWidget(
                controller: stoneMinWt,
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
          ),
        ),
        Flexible(
          flex: 1,
          child: OutlinedButton(
            child: const Text('Add Image'),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => const ImageUploadDialog());
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: ImageList(
            images: images,
          ),
        )
      ],
    );
  }
}
