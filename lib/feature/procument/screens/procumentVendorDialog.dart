import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jewlease/main.dart';

import '../../../providers/dailog_selection_provider.dart';
import '../../../widgets/read_only_textfield_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../controller/procumentVendorDailog.dart';

class procumentVendorDialog extends ConsumerStatefulWidget {
  @override
  _procumentDialogState createState() => _procumentDialogState();
}

class _procumentDialogState extends ConsumerState<procumentVendorDialog> {
  String getCurrentDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    // print("txtfld $textFieldvalues");
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
                Text('Goods Reciept Note'),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Text('Document No'),
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
                            endUrl: 'FormulaProcedures/RateStructure/DataType',
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
                        labelText: 'Vendor',
                        hintText:
                            textFieldvalues['Vendor Name'] ?? 'Choose Vendor',
                        icon: Icons.search,
                        onIconPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ItemTypeDialogScreen(
                              title: 'Choose Vendor',
                              endUrl: 'Master/PartySpecific/vendors/',
                              value: 'Vendor Name',
                              keyOfMap: 'Vendor Name',
                              onSelectdRow: (selectedRow) {
                                print("selected Row $selectedRow");
                                ref
                                    .read(pocVendorProvider.notifier)
                                    .updateEntry("Vendor Name",
                                        selectedRow["Vendor Name"]);
                                ref
                                    .read(pocVendorProvider.notifier)
                                    .updateEntry("Vendor Code",
                                        selectedRow["Vendor Code"]);
                              },
                            ),
                          );
                        },
                      )),
                  SizedBox(
                    width: screenWidth * 0.4,
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
