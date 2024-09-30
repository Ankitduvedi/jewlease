import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/item_master_stone.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/icon_text_button_widget.dart';
import 'package:jewlease/widgets/item_attribute_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

class AddStoneItemScreen extends ConsumerStatefulWidget {
  const AddStoneItemScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddStoneItemScreenState();
  }
}

class AddStoneItemScreenState extends ConsumerState<AddStoneItemScreen> {
  final TextEditingController stoneCode = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  void dispose() {
    stoneCode.dispose();
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
              log('pressed');
              final config = ItemMasterStone(
                  stoneCode: stoneCode.text,
                  description: description.text,
                  rowStatus: dropDownValue['Row Status'] ?? 'Active',
                  createdDate: DateTime.timestamp(),
                  updateDate: DateTime.timestamp(),
                  attributeType: 'HSN - SAC CODE',
                  attributeValue: textFieldvalues['HSN - SAC CODE']!);
              log(config.toJson().toString());

              ref
                  .read(itemSpecificControllerProvider.notifier)
                  .submitStoneItemConfiguration(
                      config, context, masterType[1]!.replaceAll(' ', ''));
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
        title: Text('Item Master (Item Group - ${masterType[1]})'),
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
        TextFieldWidget(
          controller: stoneCode,
          labelText: 'Stone Code',
        ),
        TextFieldWidget(
          controller: description,
          labelText: 'Description',
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
