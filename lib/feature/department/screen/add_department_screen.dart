import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/item_code_generation_model.dart';
import 'package:jewlease/feature/item_code_generation/controller/all_attribute_controller.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';

class AddDepartmentScreen extends ConsumerStatefulWidget {
  const AddDepartmentScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddDepartmentScreenState();
  }
}

class AddDepartmentScreenState extends ConsumerState<AddDepartmentScreen> {
  final TextEditingController codeGenFormat = TextEditingController();
  final TextEditingController startWith = TextEditingController();
  final TextEditingController incrBy = TextEditingController();
  final TextEditingController srNoSeperator = TextEditingController();

  @override
  void dispose() {
    codeGenFormat.dispose();
    startWith.dispose();
    incrBy.dispose();
    srNoSeperator.dispose();

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
          title: const Text('Add Department'),
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
                        hintText: textFieldvalues['Item Group'] ?? 'Item Group',
                        labelText: 'Item Group',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => const ItemTypeDialogScreen(
                              title: 'Item Group',
                              endUrl: 'ItemConfiguration/',
                              value: 'ItemGroup',
                            ),
                          );
                        },
                      ),
                      _buildFormField('Code Gen Format', codeGenFormat),
                      NumberTextFieldWidget(
                        controller: startWith,
                        labelText: 'Start With',
                      ),
                      NumberTextFieldWidget(
                        controller: incrBy,
                        labelText: 'Incr By',
                      ),
                      _buildFormField('SrNo Seperator', srNoSeperator),
                      Row(
                        children: [
                          Checkbox(
                            value: isChecked['Master Variant Ind'] ?? false,
                            onChanged: (bool? value) {
                              //Update the state when the checkbox is pressed
                              ref
                                  .read(chechkBoxSelectionProvider.notifier)
                                  .updateSelection(
                                      'Master Variant Ind', value!);
                            },
                            activeColor: Colors
                                .green, // Optional: Set the color of the tick
                          ),
                          const Expanded(
                            child: Text('Master Variant Ind'),
                          ),
                        ],
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
                        final config = ItemCodeGeneration(
                          itemGroup: textFieldvalues['Item Group']!,
                          codeGenFormat: codeGenFormat.text,
                          startWith: int.parse(startWith.text),
                          incrBy: int.parse(startWith.text),
                          srNoSeparator: srNoSeperator.text,
                          masterVariantInd:
                              isChecked['Master Variant Ind'] ?? false,
                        );
                        ref
                            .read(itemCodeGenerationProvider.notifier)
                            .submitItemCodeGenerationConfiguration(
                                config, context);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor:
                              const Color.fromARGB(255, 40, 112, 62)),
                      child: !ref.watch(itemCodeGenerationProvider)
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
  Widget _buildFormField(
    String labelText,
    TextEditingController? controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
