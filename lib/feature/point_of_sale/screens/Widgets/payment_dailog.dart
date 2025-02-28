
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/dailog_selection_provider.dart';
import '../../../../widgets/drop_down_text_field.dart';
import '../../../../widgets/read_only_textfield_widget.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../../barcoding/screens/invantory_transaction_screeen.dart';


class PaymentDialog extends ConsumerStatefulWidget {
  const PaymentDialog({super.key});

  @override
  ConsumerState<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<PaymentDialog> {
  @override
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController panNo = TextEditingController();

  Widget build(BuildContext context) {
    final dropDownValue = ref.watch(dropDownProvider);
    return Container(
      width: 1200,
      height: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xff024D8B),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  "Payment Details",
                  style: TextStyle(color: Colors.white),
                ),
                Spacer(),
                Text(
                  "Esc to close",
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Payment Method",
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 200,
                              child: const DropDownTextFieldWidget(
                                labelText: 'Payment Method',
                                initialValue: 'CASH',
                                items: [
                                  'CASH',
                                  'CHEQUE',
                                  'CREDIT CARD',
                                  'RTGS',
                                  'UPI'
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 200,
                              child: TextFieldWidget(
                                controller: amountController,
                                labelText: 'Amount',
                              ),
                            ),
                            SizedBox(
                                height: 50,
                                width: 200,
                                child: TextFieldWidget(
                                  controller: panNo,
                                  labelText: 'PAN NO',
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        if (dropDownValue['Payment Method'] == 'CREDIT CARD')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: TextFieldWidget(
                                  controller: amountController,
                                  labelText: 'Card No',
                                ),
                              ),
                              SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: ReadOnlyTextFieldWidget(
                                      labelText: 'Card Type',
                                      hintText: 'Card Type')),
                              SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: ReadOnlyTextFieldWidget(
                                      labelText: 'Bank Name',
                                      hintText: 'Bank Name')),
                            ],
                          ),
                        if (dropDownValue['Payment Method'] == 'CHEQUE' ||
                            dropDownValue['Payment Method'] == 'RTGS' ||
                            dropDownValue['Payment Method'] == 'UPI')
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: ReadOnlyTextFieldWidget(
                                      labelText: 'Bank Name',
                                      hintText: 'Bank Name')),
                              SizedBox(
                                  height: 50,
                                  width: 200,
                                  child: ReadOnlyTextFieldWidget(
                                      labelText: 'Cash Counter',
                                      hintText: 'Cash Counter')),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: TextFieldWidget(
                                  controller: remarkController,
                                  labelText: 'Remarks',
                                ),
                              ),
                            ],
                          ),
                        Spacer(),
                        Container(
                          height: 80,
                          decoration: BoxDecoration(),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      "+ ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Spacer()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 2,
                  color: Colors.grey,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    // color: Colors.red,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.event_note_outlined),
                            Text("Bill Amount"),
                            Spacer(),
                            Text("646600")
                          ],
                        ),
                        DashedLine(),
                        Spacer(),
                        Row(
                          children: [
                            Text("Payble Amt"),
                            Spacer(),
                            Text("6278274")
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.green),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Save",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}