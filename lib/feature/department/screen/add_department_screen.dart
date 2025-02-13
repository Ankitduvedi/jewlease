import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/departments_model.dart';
import 'package:jewlease/feature/department/controller/department_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

class AddDepartmentScreen extends ConsumerStatefulWidget {
  const AddDepartmentScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddDepartmentScreenState();
  }
}

class AddDepartmentScreenState extends ConsumerState<AddDepartmentScreen> {
  final TextEditingController departmentCode = TextEditingController();
  final TextEditingController departmentName = TextEditingController();
  final TextEditingController description = TextEditingController();

  @override
  void dispose() {
    departmentCode.dispose();
    departmentName.dispose();

    description.dispose();
    super.dispose();
  }

  final List<String> content = [
    'Parent Form',
    'Item Attribute',
  ];
  @override
  Widget build(BuildContext context) {
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final masterType = ref.watch(masterTypeProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            final config = Departments(
                departmentCode: departmentCode.text,
                departmentName: departmentName.text,
                departmentDescription: description.text,
                locationName: textFieldvalues['Location Name']!);

            log(config.toJson().toString());

            ref
                .read(departmentsControllerProvider.notifier)
                .submitDepartmentsConfiguration(config, context);
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
          child: !ref.watch(departmentsControllerProvider)
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
      childAspectRatio: 4.5,
      children: [
        TextFieldWidget(
          controller: departmentCode,
          labelText: 'Department Code',
        ),
        TextFieldWidget(
          controller: departmentName,
          labelText: 'Department Name',
        ),
        TextFieldWidget(
          controller: description,
          labelText: 'Department Description',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Location Name'] ?? 'Location Name',
          labelText: 'Location Name',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Location Name',
                endUrl: 'Global/Location',
                value: 'Location Name',
              ),
            );
          },
        ),
      ],
    );
  }
}
