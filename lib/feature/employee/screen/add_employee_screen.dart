import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/employee_and_location_model.dart';
import 'package:jewlease/feature/employee/controller/employee_controller.dart';
import 'package:jewlease/feature/employee/screen/dailog_screen.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

class AddEmployeeScreen extends ConsumerStatefulWidget {
  const AddEmployeeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddEmployeeScreenState();
  }
}

class AddEmployeeScreenState extends ConsumerState<AddEmployeeScreen> {
  final TextEditingController employeeCode = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController employeeName = TextEditingController();
  final TextEditingController loginName = TextEditingController();
  final TextEditingController loginPassword = TextEditingController();
  final TextEditingController pfAccountNumber = TextEditingController();
  final TextEditingController esicNumber = TextEditingController();
  final TextEditingController emergencyContactName = TextEditingController();
  final TextEditingController emergencyContact = TextEditingController();
  final TextEditingController salaryInstr = TextEditingController();
  final TextEditingController accountName = TextEditingController();

  @override
  void dispose() {
    employeeCode.dispose();
    description.dispose();
    employeeName.dispose();
    loginName.dispose();
    loginPassword.dispose();
    pfAccountNumber.dispose();
    esicNumber.dispose();
    emergencyContactName.dispose();
    emergencyContact.dispose();
    salaryInstr.dispose();
    accountName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    //final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);
    final masterType = ref.watch(masterTypeProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            final configs = Employee(
                employeeCode: employeeCode.text,
                employeeName: employeeName.text,
                employeeType: dropDownValue['Employee Type'] ?? 'Admin',
                defaultLocation: textFieldvalues['Location Name'] ?? 'Location',
                defaultDepartment:
                    textFieldvalues['Department Name'] ?? 'Department',
                locations: ref.watch(locationProvider.notifier).state,
                canChangeGlobalSetting: 0,
                loginName: loginName.text,
                pfAccountNo: pfAccountNumber.text,
                esicNo: esicNumber.text,
                rowStatus: dropDownValue['Row Status'] ?? 'Active',
                remark: '',
                grade: '',
                weighterName: '',
                password: loginPassword.text,
                passwordExpired: 0,
                isLocked: 0,
                noOfFailedAttempts: 0,
                passwordExpiresOn: DateTime.timestamp(),
                allowAccessFromMainURL: 0,
                emergencyContactName: emergencyContactName.text,
                emergencyContact: emergencyContact.text,
                salaryInstr: salaryInstr.text,
                accountName: accountName.text,
                lastLoginDate: DateTime.timestamp());

            log(configs.toJson().toString());

            ref
                .read(employeeControllerProvider.notifier)
                .submitEmployeeConfiguration(
                  configs,
                  context,
                );
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
          controller: employeeCode,
          labelText: 'Employee Code',
        ),
        TextFieldWidget(
          controller: employeeName,
          labelText: 'Employee Name',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Admin',
          items: ['Admin', 'SalesMan', 'Manager', 'Accountant', 'Other'],
          labelText: 'Employee Type',
        ),
        TextFieldWidget(
          controller: loginName,
          labelText: 'Login Name',
        ),
        TextFieldWidget(
          controller: loginPassword,
          labelText: 'Login Password',
        ),
        TextFieldWidget(
          controller: pfAccountNumber,
          labelText: 'PF account Number',
        ),
        TextFieldWidget(
          controller: esicNumber,
          labelText: 'ESIC Number',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Active',
          items: ['InActive', 'Active'],
          labelText: 'Row Status',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Location Name'] ?? 'Location Name',
          labelText: 'Default Location',
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
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Department Name'] ?? 'Department',
          labelText: 'Default Department',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Department Name',
                endUrl: 'Global/Department',
                value: 'Department Name',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Department Code'] ?? 'Department Code',
          labelText: 'Allowed Departments',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const MultipleItemTypeDialogScreen(
                title: 'Department Code',
                endUrl: 'Global/Department',
                value: 'Department Code',
              ),
            );
          },
        ),
        TextFieldWidget(
          controller: emergencyContactName,
          labelText: 'Emergency Contact Name',
        ),
        TextFieldWidget(
          controller: emergencyContact,
          labelText: 'Emergency Contact',
        ),
        TextFieldWidget(
          controller: salaryInstr,
          labelText: 'Salary Instruction',
        ),
        TextFieldWidget(
          controller: accountName,
          labelText: 'Account Name',
        ),
      ],
    );
  }
}
