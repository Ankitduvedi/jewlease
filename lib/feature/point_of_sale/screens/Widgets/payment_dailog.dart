import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/payment.dart';
import 'package:jewlease/feature/point_of_sale/controllers/pos_controller.dart';

import '../../../../providers/dailog_selection_provider.dart';
import '../../../../widgets/drop_down_text_field.dart';
import '../../../../widgets/read_only_textfield_widget.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../../barcoding/screens/invantory_transaction_screeen.dart';
import '../../../procument/controller/procumentVendorDailog.dart';

class PaymentDialog extends ConsumerStatefulWidget {
  PaymentDialog({
    super.key,
    required this.totalAmount,
  });

  double totalAmount;

  @override
  ConsumerState<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<PaymentDialog> {
  @override
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController panNo = TextEditingController();
  double totalAmount = 0;

  @override
  void initState() {
    // TODO: implement initState
    totalAmount = widget.totalAmount;
    super.initState();
  }

  List<Map<String, dynamic>> paymentDetails = [];

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
                        InkWell(
                          onTap: () {
                            String paymentType =
                                dropDownValue['Payment Method'] ?? "CASH";
                            Map<String, dynamic> newPayment = {};
                            double amount = double.parse(amountController.text);
                            newPayment[paymentType] = amount;
                            widget.totalAmount -= amount;
                            amountController.text =
                                widget.totalAmount.toString();
                            paymentDetails.add(newPayment);
                            setState(() {});
                          },
                          child: Container(
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
                            Text(totalAmount.toString())
                          ],
                        ),
                        DashedLine(),
                        Container(
                          height: 300,
                          child: ListView.builder(
                              itemCount: paymentDetails.length,
                              itemBuilder: (context, index) {
                                // List<dynamic>values= paymentDetails[index].
                                return Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          widget.totalAmount +=
                                              paymentDetails[index]
                                                  .values
                                                  .first;
                                          paymentDetails.removeAt(index);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.cancel)),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Text(paymentDetails[index]
                                              .keys
                                              .first
                                              .toString()),
                                          SizedBox(
                                            width: 180,
                                          ),
                                          Text(paymentDetails[index]
                                              .values
                                              .first
                                              .toString()),
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                    )
                                  ],
                                );
                              }),
                        ),
                        // Spacer(),
                        Row(
                          children: [
                            Text("Payble Amt"),
                            Spacer(),
                            Text(widget.totalAmount.toString())
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            List<PaymentModel> paymentModels = [];
                            double localAMount = 0;
                            for (int i = 0; i < paymentDetails.length; i++) {
                              print("total amoint $totalAmount");
                              localAMount += paymentDetails[i].values.first;
                              PaymentModel payment = PaymentModel(
                                faRecPayHdrId: -461,
                                locationId: 1,
                                location: "HO",
                                yearId: 5826,
                                payMode:
                                    paymentDetails[i].keys.first.toString(),
                                transAmount: paymentDetails[i].values.first,
                                localAmount: paymentDetails[i].values.first,
                                particulars:
                                    paymentDetails[i].keys.first.toString(),
                                drAmount: 0,
                                crAmount: paymentDetails[i].values.first,
                                runningBal:totalAmount - localAMount,
                                payerAccountNo: 3213213131,
                                voucherNo: "HO-INV-2-2025-2026",
                                transDate: "24/05/2025",
                                issuingParty: ref.read(pocVendorProvider)["Sales Person"],
                                partyId: 1212,
                                partyName: ref.read(pocVendorProvider)["Customer Name"],
                                remarks: "sdndscdsc",
                                rowStatus: 1,
                                oldTransAmount: 30.34,
                                refTransId: 0,
                                currencyId: 0,
                                currencyCode: "INDIAN RUPEES",
                                ifscCode: "21312313",
                                cardNumber: "0121322",
                                expiryMonth: 12,
                                expiryYear: 2023,
                                panNo: "CDXDD",
                                id: i+1,
                              );


                              paymentModels.add(payment);
                            }
                            PaymentModel salesPayment = PaymentModel(
                              faRecPayHdrId: -461,
                              locationId: 1,
                              location: "HO",
                              yearId: 5826,
                              payMode:"SALES ACCOUNT",
                              transAmount: totalAmount,
                              localAmount: totalAmount,
                              particulars:"SALES ACCOUNT",
                              drAmount: totalAmount,
                              crAmount: 0,
                              runningBal:totalAmount,
                              payerAccountNo: 3213213131,
                              voucherNo: "HO-INV-2-2025-2026",
                              transDate: "24/05/2025",
                              issuingParty: ref.read(pocVendorProvider)["Sales Person"],
                              partyId: 1212,
                              partyName: ref.read(pocVendorProvider)["Customer Name"],
                              remarks: "sdndscdsc",
                              rowStatus: 1,
                              oldTransAmount: 30.34,
                              refTransId: 0,
                              currencyId: 0,
                              currencyCode: "INDIAN RUPEES",
                              ifscCode: "21312313",
                              cardNumber: "0121322",
                              expiryMonth: 12,
                              expiryYear: 2023,
                              panNo: "CDXDD",
                              id: 0,
                            );
                            paymentModels.insert(0, salesPayment);
                            Map<String, dynamic> reqdata = {
                              "Data": paymentModels
                                  .map((row) => row.toJson())
                                  .toList()
                            };
                            Utils.printJsonFormat(reqdata);
                            ref
                                .read(posControllerProvider.notifier)
                                .addPayment(reqdata);

                          },
                          child: Container(
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
