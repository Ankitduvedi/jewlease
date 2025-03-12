

import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../widgets/text_field_widget.dart';

class metalIssueDialog extends StatefulWidget {
  final TextEditingController metalWeightController;
  final Function(Map<String, dynamic>, bool) addRow;
  final Map<String, dynamic> row;

  const metalIssueDialog(
      {super.key,
        required this.metalWeightController,
        required this.row,
        required this.addRow});

  @override
  State<metalIssueDialog> createState() => _metalIssueDialogState();
}

class _metalIssueDialogState extends State<metalIssueDialog> {
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
                      child: TextFieldWidget(
                          labelText: "Metal Weight",
                          controller: widget.metalWeightController)),
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
                    widget.addRow(widget.row, false);
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