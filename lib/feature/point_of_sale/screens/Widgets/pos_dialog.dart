import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jewlease/main.dart';

import '../../../../providers/dailog_selection_provider.dart';
import '../../../../widgets/read_only_textfield_widget.dart';
import '../../../../widgets/search_dailog_widget.dart';
import '../../../procument/controller/procumentVendorDailog.dart';

class posVendorDialog extends ConsumerStatefulWidget {
  @override
  _procumentDialogState createState() => _procumentDialogState();
}

class _procumentDialogState extends ConsumerState<posVendorDialog> {
  String getCurrentDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    print("txtfield values are $textFieldvalues");
    // print("")
    return Container(
      height: screenHeight * 0.3,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: screenHeight * 0.08,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Estimation POS'),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Text('Esc to Close'),
                      Icon(Icons.close),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: screenHeight * 0.12,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text('Estimation No'),
                      ),
                      SizedBox(
                        width: screenWidth * 0.1,
                        height: screenHeight * 0.05,
                        child: TextField(
                          style: TextStyle(fontSize: 12),
                          controller: TextEditingController(
                            text: getCurrentDate(),
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date*',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.1,
                        child: ReadOnlyTextFieldWidget(
                          labelText: 'Category',
                          hintText: 'Category',
                          icon: Icons.search,
                          onIconPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const ItemTypeDialogScreen(
                                title: 'Data Type',
                                endUrl:
                                    'FormulaProcedures/RateStructure/DataType',
                                value: 'Config Id',
                                keyOfMap: 'ConfigValue',
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.1,
                          child: ReadOnlyTextFieldWidget(
                            labelText: 'Customer',
                            hintText: textFieldvalues['Vendor Name'] ?? 'Customer',
                            icon: Icons.search,
                            onIconPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ItemTypeDialogScreen(
                                  title: 'Customer',
                                  endUrl: 'Master/PartySpecific/vendors/',
                                  value: 'Vendor Name',
                                  keyOfMap: 'Vendor Name',
                                  onSelectdRow: (selectedRow) {
                                    print("selected Row $selectedRow");

                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry("Customer Name",
                                            selectedRow["Vendor Name"]);
                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry("Customer Code",
                                            selectedRow["Vendor Code"]);

                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry( "Billing Address",
                                        selectedRow["billingAddress"]);
                                    setState(() {

                                    });
                                  },

                                ),
                              );
                            },
                          )),
                      SizedBox(
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.1,
                          child: ReadOnlyTextFieldWidget(
                            labelText: 'Source',
                            hintText: textFieldvalues['Source'] ?? 'Source',
                            icon: Icons.search,
                            onIconPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ItemTypeDialogScreen(
                                  title: 'Source',
                                  endUrl: 'Master/PartySpecific/vendors/',
                                  value: 'Vendor Name',
                                  keyOfMap: 'Vendor Name',
                                  onSelectdRow: (selectedRow) {
                                    print("selected Row $selectedRow");
                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry("Source",
                                        selectedRow["Vendor Name"]);
                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry("Source Code",
                                        selectedRow["Source Code"]);
                                  },
                                ),
                              );
                            },
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      SizedBox(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.2,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(

                            ),
                            enabled: false,
                            hintText: ref.read(pocVendorProvider)["Billing Address"] ??
                                'Billing Address',
                          ),
                        ),
                      ),
                      SizedBox(
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.1,
                          child: ReadOnlyTextFieldWidget(
                            labelText: 'Sales Person',
                            hintText: textFieldvalues['Employee Name'] ??
                                'Sales Person',
                            icon: Icons.search,
                            onIconPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ItemTypeDialogScreen(
                                  title: 'Sales Person',
                                  endUrl: 'EmployeeMaster/',
                                  value: 'Employee Name',
                                  keyOfMap: 'Employee Name',
                                  onSelectdRow: (selectedRow) {
                                    print("selected Row $selectedRow");
                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry("Sales Person",
                                            selectedRow["Employee Name"]);
                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry("Sales Person Code",
                                            selectedRow["Employee Code"]);
                                    print('mao is ${ ref
                                        .read(pocVendorProvider)}');
                                  },
                                ),
                              );
                            },
                          )),
                      SizedBox(
                          height: screenHeight * 0.05,
                          width: screenWidth * 0.15,
                          child: ReadOnlyTextFieldWidget(
                            labelText: 'Place of Delivery',
                            hintText: textFieldvalues['Place of Delivery'] ??
                                'Place of Delivery',
                            icon: Icons.search,
                            onIconPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => ItemTypeDialogScreen(
                                  title: 'Place of Delivery',
                                  endUrl: 'Master/PartySpecific/vendors/',
                                  value: 'Vendor Name',
                                  keyOfMap: 'Vendor Name',
                                  onSelectdRow: (selectedRow) {
                                    print("selected Row $selectedRow");
                                    ref
                                        .read(pocVendorProvider.notifier)
                                        .updateEntry("Place of Delivery",
                                        selectedRow["Place of Delivery"]);
                                  },
                                ),
                              );
                            },
                          )),
                      SizedBox(
                        width: screenWidth * 0.1,
                        height: screenHeight * 0.05,
                        child: TextField(
                          style: TextStyle(fontSize: 12),
                          controller: TextEditingController(

                            text: getCurrentDate(),
                          ),
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Due Date*',
                            suffixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.2,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(

                            ),
                            enabled: true,
                            hintText: textFieldvalues['Remarks'] ??
                                'Remarks',
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: screenWidth * 0.4,
                      // )
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            height: screenHeight * 0.07,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.grey.shade300,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // if (textFieldvalues['Sales Person'] == null ||
                    //     textFieldvalues['Customer'] == null) {
                    //   return;
                    // }
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: screenWidth * 0.07,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.green,
                    ),
                    child: Center(
                        child: Text(
                      'Done',
                      style: TextStyle(fontSize: 12),
                    )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
