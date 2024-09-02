import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/all_attribute_model.dart';
import 'package:jewlease/feature/all_attributes/controller/all_attribute_controller.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

class AddAttributeScreen extends ConsumerStatefulWidget {
  const AddAttributeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddAttributeScreenState();
  }
}

class AddAttributeScreenState extends ConsumerState<AddAttributeScreen> {
  final TextEditingController attributeCode = TextEditingController();
  final TextEditingController attributeDescription = TextEditingController();

  @override
  void dispose() {
    attributeCode.dispose();
    attributeDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);

    final textFieldvalues = ref.watch(dialogSelectionProvider);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          title: const Text('All Attribute'),
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
                        hintText: textFieldvalues['Attribute Type'] ??
                            'Attribute Type',
                        labelText: 'Attribute Type',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemTypeDialogScreen(
                              title: 'Attribute Type',
                              endUrl: 'AllAttribute/AttributeType',
                            ),
                          );
                        },
                      ),
                      TextFieldWidget(
                          labelText: 'Attribute Code',
                          controller: attributeCode),
                      TextFieldWidget(
                          labelText: 'Attribute Description',
                          controller: attributeDescription),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked['Default Indicator'] ?? false,
                            onChanged: (bool? value) {
                              //Update the state when the checkbox is pressed
                              ref
                                  .read(chechkBoxSelectionProvider.notifier)
                                  .updateSelection('Default Indicator', value!);
                            },
                            activeColor: Colors
                                .green, // Optional: Set the color of the tick
                          ),
                          const Expanded(
                            child: Text('Default Indicator'),
                          ),
                        ],
                      ),
                      const DropDownTextFieldWidget(
                        labelText: 'Row Status',
                        initialValue: 'Active',
                        items: ['Active', 'InActive'],
                      )
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
                        final config = AllAttribute(
                          attributeType: textFieldvalues['Attribute Type']!,
                          attributeCode: attributeCode.text,
                          attributeDescription: attributeDescription.text,
                          defaultIndicator:
                              isChecked['Default Indicator'] ?? false,
                          rowStatus: dropDownValue['Row Status'] ?? 'Active',
                        );
                        ref
                            .read(allAttributeControllerProvider.notifier)
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
}
