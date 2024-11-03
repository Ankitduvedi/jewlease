import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jewlease/main.dart';

import '../../widgets/read_only_textfield_widget.dart';
import '../../widgets/search_dailog_widget.dart';

class procumentDialog extends ConsumerStatefulWidget {
  @override
  _procumentDialogState createState() => _procumentDialogState();
}

class _procumentDialogState extends ConsumerState<procumentDialog> {
  String getCurrentDate() {
    return DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
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
                        hintText: 'Vendor',
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
                Container(
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
              ],
            ),
          )
        ],
      ),
    );
  }
}
