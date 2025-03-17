import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/customer_model.dart';
import 'package:jewlease/feature/crm/controller/all_attribute_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/check_box.dart';
import 'package:jewlease/widgets/drop_down_text_field.dart';
import 'package:jewlease/widgets/read_only_date_picker_widget.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/search_dailog_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

class AddCustomerScreen extends ConsumerStatefulWidget {
  const AddCustomerScreen({super.key, required this.customer});

  @override
  final CustomerModel? customer;

  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddCustomerScreenState();
  }
}

class AddCustomerScreenState extends ConsumerState<AddCustomerScreen> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNo = TextEditingController();
  final TextEditingController aadharNo = TextEditingController();
  final TextEditingController panNO = TextEditingController();
  final TextEditingController remark = TextEditingController();
  final TextEditingController legalName = TextEditingController();
  final TextEditingController billingAddr2 = TextEditingController();
  final TextEditingController billingAddPincode = TextEditingController();
  final TextEditingController billingAddr1 = TextEditingController();
  final TextEditingController shippingCity = TextEditingController();
  final TextEditingController shippingMobNo = TextEditingController();
  final TextEditingController billingCity = TextEditingController();
  final TextEditingController shippingAddr1 = TextEditingController();
  final TextEditingController shippingAddr2 = TextEditingController();
  final TextEditingController shippingPinCode = TextEditingController();
  final TextEditingController otherNo = TextEditingController();
  final TextEditingController billingPanNo = TextEditingController();
  final TextEditingController billingGstNo = TextEditingController();
  final TextEditingController shippingPanNo = TextEditingController();
  final TextEditingController gstNo = TextEditingController();

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    email.dispose();
    phoneNo.dispose();
    aadharNo.dispose();
    panNO.dispose();
    remark.dispose();
    legalName.dispose();
    billingAddr2.dispose();
    billingAddPincode.dispose();
    billingAddr1.dispose();
    shippingCity.dispose();
    shippingMobNo.dispose();
    billingCity.dispose();
    billingPanNo.dispose();
    otherNo.dispose();
    gstNo.dispose();
    shippingPanNo.dispose();
    billingGstNo.dispose();
    shippingAddr1.dispose();
    shippingAddr2.dispose();
    shippingAddr2.dispose();
    shippingPinCode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    intializeRows();
    super.initState();
  }

  void intializeRows() {
    if (widget.customer != null) {
      print("fname ${widget.customer!.firstName}");
      setState(() {
        firstName.text = widget.customer!.firstName;
        lastName.text = widget.customer!.lastName;
        email.text = widget.customer!.emailId;
        phoneNo.text = widget.customer!.mobileNo;
        aadharNo.text = widget.customer!.aadharNo;
        panNO.text = widget.customer!.panNo;
        remark.text = widget.customer!.remarks;
        otherNo.text = widget.customer!.otherNo;
        // legalName.text =widget.customer!
        billingAddr1.text = widget.customer!.billingAdd1;
        billingAddr2.text = widget.customer!.billingAdd2;
        billingCity.text= widget.customer!.billingCity;
        billingPanNo.text = widget.customer!.billingPanNo;
        billingGstNo.text = widget.customer!.billingGstNo;
        shippingCity.text = widget.customer!.shippingCity;
        shippingAddr1.text =widget.customer!.shippingAdd1;
        shippingAddr2.text =widget.customer!.shippingAdd2;
        shippingPinCode.text =widget.customer!.shippingPincode;
        shippingMobNo.text = widget.customer!.shipMobileNo;

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    //final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);

    return Scaffold(
      persistentFooterButtons: [
        ElevatedButton(
          onPressed: () {
            final config = CustomerModel(
                creationDate: DateTime.timestamp(),
                firstName: firstName.text,
                lastName: lastName.text,
                mobileNo: phoneNo.text,
                emailId: email.text,
                partyCode: '123',
                customerGroup: dropDownValue['Customer Group'] ?? 'DOMESTIC',
                title: dropDownValue['Title'] ?? 'Mr',
                birthDate: DateTime.parse(
                    textFieldvalues['Date of Birth'] ?? "19700101"),
                parentCustomer:
                    textFieldvalues['Parent Customer'] ?? "Parent Customer",
                anniversaryDate: DateTime.parse(
                    textFieldvalues['Anniversary Date'] ?? "19700101"),
                schemeCustomer: dropDownValue['Scheme Customer'] ?? 'Yes',
                aadharNo: aadharNo.text,
                panNo: panNO.text,
                panNoUrl: '',
                gstNo: gstNo.text,
                defaultCurrency:
                    textFieldvalues['Default Currency'] ?? 'Default Currency',
                remarks: remark.text,
                status: dropDownValue['Status'] ?? 'Active',
                giftApplicable: isChecked['GIFT Applicable'] ?? false,
                reverseCharges: dropDownValue['Reverse Charge'] ?? 'Yes',
                billingAdd1: billingAddr1.text,
                salesNature: dropDownValue['Sales Nature'] ?? 'B2B',
                subCategorySales:
                    dropDownValue['Sub Category Sales'] ?? 'Exempt',
                billingAdd2: billingAddr2.text,
                billingPincode: billingAddPincode.text,
                billingCountry: 'India',
                billingState: dropDownValue['Billing State'] ?? 'Uttar Pradesh',
                otherNo: otherNo.text,
                billingCity: billingCity.text,
                billingPanNo: billingPanNo.text,
                billingGstNo: billingGstNo.text,
                copyBillingAddress:
                    isChecked['Copy Billing Address'].toString(),
                shippingAdd1: shippingAddr1.text,
                shippingAdd2: shippingAddr2.text,
                shippingPincode: shippingPinCode.text,
                shippingCountry: 'India',
                shippingState: isChecked['Copy Billing Address'] != null && true
                    ? dropDownValue['Billing State'] ?? 'Uttar Pradesh'
                    : dropDownValue['Shipping State'] ?? 'Uttar Pradesh',
                shippingCity: isChecked['Copy Billing Address'] != null && true
                    ? billingCity.text
                    : shippingCity.text,
                shipMobileNo: shippingMobNo.text,
                cardType: '',
                cardNo: '',
                terms: dropDownValue['Terms'] ?? 'COD',
                religion: '',
                terms2: dropDownValue['Terms 2'] ?? 'COD',
                motherBirthday: DateTime.parse(
                    textFieldvalues['Mother Birthday'] ?? "19700101"),
                fatherBirthday: DateTime.parse(
                    textFieldvalues['Father Birthday'] ?? "19700101"),
                spouseBirthday: DateTime.parse(
                    textFieldvalues['Spouse Birthday'] ?? "19700101"),
                partyAnniversary: DateTime.parse(
                    textFieldvalues['Parent Anniversary'] ?? "19700101"),
                nriCustomer: isChecked['NRI Customer'] ?? false);

            log('config : ${config}');

            ref
                .read(cRMControllerProvider.notifier)
                .submitCustomerConfiguration(
                  config,
                  context,
                );
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
          child: !ref.watch(cRMControllerProvider).isLoading
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
        title: const Text('Add Customer'),
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
          controller: firstName,
          labelText: 'First Name',
        ),
        TextFieldWidget(
          controller: lastName,
          labelText: 'Last Name',
        ),
        TextFieldWidget(
          controller: email,
          labelText: 'Email',
        ),
        TextFieldWidget(
          controller: phoneNo,
          labelText: 'Phone Number',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'DOMESTIC',
          items: [
            'Artisan',
            'Buyers',
            'DATA',
            'DOMESTIC',
            'INTERNATIONAL',
            'Non Buyer',
            'Regular',
            'SUPPLIER FOR EXPENCESS',
            'SUPPLIER FOR GOODS',
            'UNREGISTERED',
            'Other'
          ],
          labelText: 'Customer Group',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Mr',
          items: [
            'Dr',
            'Mr',
            'Mrs',
            'Ms',
            'Prof',
            'Shri',
            'Miss',
            'Other',
          ],
          labelText: 'Title',
        ),
        ReadOnlyDatePickerWidget(
          hintText: textFieldvalues['Date of Birth'] ?? 'Date of Birth',
          labelText: 'Date of Birth',
        ),
        ReadOnlyTextFieldWidget(
          hintText: textFieldvalues['Parent Customer'] ?? 'Parent Customer',
          labelText: 'Parent Customer',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Parent Customer',
                endUrl: 'Global/CustomerMaster',
                value: 'Party Code',
              ),
            );
          },
        ),
        ReadOnlyDatePickerWidget(
          hintText: textFieldvalues['Anniversary Date'] ?? 'Anniversary Date',
          labelText: 'Anniversary Date',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Yes',
          items: ['Yes', 'No'],
          labelText: 'Scheme Customer',
        ),
        TextFieldWidget(
          controller: aadharNo,
          labelText: 'Aadhar Number',
        ),
        TextFieldWidget(
          controller: panNO,
          labelText: 'Pan no',
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
        TextFieldWidget(
          controller: remark,
          labelText: 'REMARKS',
        ),
        TextFieldWidget(
          controller: gstNo,
          labelText: 'GST No',
        ),
        const CheckBoxWidget(
          labelText: 'GIFT Applicable',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Active',
          items: ['InActive', 'Active'],
          labelText: 'Status',
        ),
        TextFieldWidget(
          controller: legalName,
          labelText: 'Legal Name',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Yes',
          items: ['Yes', 'No'],
          labelText: 'Reverse Charge',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'B2B',
          items: ['B2B', 'B2C', 'Export'],
          labelText: 'Sales Nature',
        ),
        TextFieldWidget(
          controller: billingAddr1,
          labelText: 'Billing Add 1',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Exempt',
          items: [
            'Exempt',
            'NilRated',
            'Export',
            'Non GST',
            'RCM Sales',
            'SEZ',
            'Sales Through E-Commerce',
            'Other'
          ],
          labelText: 'Sub Category Sales',
        ),
        TextFieldWidget(
          controller: billingAddr2,
          labelText: 'Billing Add 2',
        ),
        TextFieldWidget(
          controller: billingAddPincode,
          labelText: 'Billing Pincode',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Uttar Pradesh',
          items: [
            'Delhi',
            'Haryana',
            'Punjab',
            'Other',
            'Jammu and Kashmir',
            'Himachal Pradesh',
            'Rajasthan',
            'Uttarakhand',
            'Madhya Pradesh',
            'Chhattisgarh',
            'Gujarat',
            'Daman and Diu',
            'Dadra and Nagar Haveli',
            'Maharashtra',
            'Karnataka',
            'Goa',
            'Lakshadweep',
            'Kerala',
            'Tamil Nadu',
            'Puducherry',
            'Andaman and Nicobar Islands',
            'Telangana',
            'Andhra Pradesh',
            'Odisha',
            'West Bengal',
            'Sikkim',
            'Arunachal Pradesh',
            'Nagaland',
            'Manipur',
            'Mizoram',
            'Tripura',
            'Meghalaya',
            'Assam',
            'Bihar',
            'Jharkhand',
            'Chandigarh',
            'Uttar Pradesh',
            'Ladakh'
          ],
          labelText: 'Billing State',
        ),
        TextFieldWidget(
          controller: otherNo,
          labelText: 'Other No',
        ),
        TextFieldWidget(
          controller: billingCity,
          labelText: 'Billing City',
        ),
        TextFieldWidget(
          controller: billingPanNo,
          labelText: 'Billing Pan no',
        ),
        TextFieldWidget(
          controller: billingGstNo,
          labelText: 'Billing GST No',
        ),
        const CheckBoxWidget(
          labelText: 'Copy Billing Address',
        ),
        TextFieldWidget(
          controller: shippingAddr1,
          labelText: 'Shipping Add 1',
        ),
        TextFieldWidget(
          controller: shippingAddr2,
          labelText: 'Shipping Add 2',
        ),
        TextFieldWidget(
          controller: shippingPinCode,
          labelText: 'Shipping Pincode',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'Uttar Pradesh',
          items: [
            'Delhi',
            'Haryana',
            'Punjab',
            'Other',
            'Jammu and Kashmir',
            'Himachal Pradesh',
            'Rajasthan',
            'Uttarakhand',
            'Madhya Pradesh',
            'Chhattisgarh',
            'Gujarat',
            'Daman and Diu',
            'Dadra and Nagar Haveli',
            'Maharashtra',
            'Karnataka',
            'Goa',
            'Lakshadweep',
            'Kerala',
            'Tamil Nadu',
            'Puducherry',
            'Andaman and Nicobar Islands',
            'Telangana',
            'Andhra Pradesh',
            'Odisha',
            'West Bengal',
            'Sikkim',
            'Arunachal Pradesh',
            'Nagaland',
            'Manipur',
            'Mizoram',
            'Tripura',
            'Meghalaya',
            'Assam',
            'Bihar',
            'Jharkhand',
            'Chandigarh',
            'Uttar Pradesh',
            'Ladakh'
          ],
          labelText: 'Shipping State',
        ),
        TextFieldWidget(
          controller: shippingCity,
          labelText: 'Shipping City',
        ),
        TextFieldWidget(
          controller: shippingMobNo,
          labelText: 'Ship Mobile No',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'COD',
          items: ['COD', 'Credit', 'Other'],
          labelText: 'Terms',
        ),
        const DropDownTextFieldWidget(
          initialValue: 'COD',
          items: ['COD', 'Credit', 'Other'],
          labelText: 'Terms 2',
        ),
        ReadOnlyDatePickerWidget(
          hintText: textFieldvalues['Mother Birthday'] ?? 'Mother Birthday',
          labelText: 'Mother Birthday',
        ),
        ReadOnlyDatePickerWidget(
          hintText: textFieldvalues['Father Birthday'] ?? 'Father Birthday',
          labelText: 'Father Birthday',
        ),
        ReadOnlyDatePickerWidget(
          hintText: textFieldvalues['Spouse Birthday'] ?? 'Spouse Birthday',
          labelText: 'Spouse Birthday',
        ),
        ReadOnlyDatePickerWidget(
          hintText:
              textFieldvalues['Parent Anniversary'] ?? 'Parent Anniversary',
          labelText: 'Parent Anniversary',
        ),
        const CheckBoxWidget(
          labelText: 'NRI Customer',
        ),
      ],
    );
  }
}
