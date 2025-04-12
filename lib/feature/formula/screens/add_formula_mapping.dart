import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/formula_mapping_model.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';

import '../controller/formula_prtocedure_controller.dart';

class AddFormulaMappingScreen extends ConsumerStatefulWidget {
  const AddFormulaMappingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddFormulaMappingScreenState();
  }
}

class AddFormulaMappingScreenState
    extends ConsumerState<AddFormulaMappingScreen> {
  final TextEditingController setCode = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  void dispose() {
    setCode.dispose();
    description.dispose();
    super.dispose();
  }

  final List<String> content = [
    'Parent Form',
  ];
  String attributeValue = "";
  String attributeType = "";
  String  operaion = "";
  String operationType = "";

  @override
  Widget build(BuildContext context) {
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);
    final masterType = ref.watch(masterTypeProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            FormulaMappigModel config = FormulaMappigModel(
                procedureType: dropDownValue['Procedure Type']!,
                transactionType: textFieldvalues["Transaction Type"]!,
                documentType: textFieldvalues['Document Type']!,
                transactionCategory: dropDownValue['Trans Category']!,
                partyName: "",
                variantName: "",
                itemGroup: dropDownValue["Item Group"]!,
                attributeType: attributeType,
                attributeValue: attributeValue,
                operation: operaion,
                operationType: operationType,
                procedureName: textFieldvalues['Procedure Name']??"",
                transType: "");
            ref
                .read(formulaProcedureControllerProvider.notifier)
                .addFormulaMapping(config, context);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
          child: !ref.watch(itemSpecificControllerProvider)
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
        title: const Text('Formula Mapping'),
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
          child: Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0), child: parentForm())),
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
      childAspectRatio: 4,
      children: [
        const DropDownTextFieldWidget(
          initialValue: 'Item',
          items: [
            'Finacial Transaction Formula',
            'Item',
            'Transaction',
            'Service charges - Receivable',
            'Service Charges - Payable'
          ],
          labelText: 'Procedure Type',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Transaction Type'] ?? 'Transaction Type',
          labelText: 'Transaction Type',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Transaction Type',
                endUrl: 'FormulaProcedures/TransactionType/FormulaMapping',
                value: 'Config value',
              ),
            );
          },
        ),
        const DropDownTextFieldWidget(
          initialValue: 'READY TO SHIP ORDER (0)',
          items: [
            'READY TO SHIP ORDER (0)',
            'READY TO SHIP ORDER (115)',
          ],
          labelText: 'Trans Category',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Document Type'] ?? 'Document Type',
          labelText: 'Document Type',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Document Type',
                endUrl: 'FormulaProcedures/DocumentType/FormulaMapping',
                value: 'Config value',
              ),
            );
          },
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Style',
          items: [
            'Style',
            'Style(Pcs)',
            'Style(Wt)',
            'Gold',
            'Platinum',
            'Silver',
            'Bronze',
            'Diamond',
            'Pearl',
            'Precious Stone',
            'Semi Precious Stone',
            'Zircon',
            'Polki',
            'Diamond Solitaire',
            'Consumables(Wt)',
            'Consumables-Cts',
            'Set',
            'Style Certificate',
            'Stone Certificate',
            'Packing Materials',
          ],
          labelText: 'Item Group',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Attribute Code'] ?? 'Attribute Code',
          labelText: 'Attribute Code',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => ItemTypeDialogScreen(
                title: 'Attribute Code',
                endUrl: 'AllAttribute/',
                value: 'AttributeCode',
                onSelectdRow: (selectedRow) {
                  setState(() {
                    attributeType = selectedRow["AttributeType"];
                    attributeValue = selectedRow["AttributeCode"];
                  });
                },
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Operation'] ?? 'Operation',
          labelText: 'Operation',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) =>  ItemTypeDialogScreen(
                title: 'Operation',
                endUrl: 'Global/operations/',
                value: 'OPERATION_NAME',
                onSelectdRow: (selectedRow) {
                  setState(() {
                    operaion= selectedRow["OPERATION_NAME"];
                    operationType = selectedRow["OPERATION_TYPE"];
                  });

                },
              ),
            );
          },
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Na',
          items: [
            'Hand Setting',
            'Wax Setting',
            'Machine Setting',
            'Manual Setting',
            'Paste Setting',
            'Na',
            'Stringing',
            'Glue',
            'Ghantan',
          ],
          labelText: 'Trans Category',
        ),
        ReadOnlyTextFieldWidget(
          hintText:
              textFieldvalues['Procedure Name'] ?? 'Formula Procedure Name',
          labelText: 'Procedure Name',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Procedure Name',
                endUrl: 'FormulaProcedures/table',
                value: 'Formula Procedure Name',
              ),
            );
          },
        ),
      ],
    );
  }
}
