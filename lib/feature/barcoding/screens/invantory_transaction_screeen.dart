import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/inventoryItem.dart';
import 'package:jewlease/feature/transaction/screens/transaction_details.dart';
import 'package:jewlease/feature/transaction/screens/widgets/formula_dialog.dart';

import '../../procument/screens/formulaGrid.dart';
import '../../transaction/controller/transaction_list_controller.dart';
import 'barcoding_screen.dart';

class InvantoryTransactionScreeen extends ConsumerStatefulWidget {
  const InvantoryTransactionScreeen({super.key});

  @override
  ConsumerState<InvantoryTransactionScreeen> createState() =>
      _InvantoryTransactionScreeenState();
}

class _InvantoryTransactionScreeenState
    extends ConsumerState<InvantoryTransactionScreeen> {
  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionProvider);

    print("transactionState summery is ${transactionState.summedValues}");
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TransactionDetailsCard()),
        ),
        Expanded(
          flex: 3,
          child: Container(
            color: Colors.white,
            height: 1600,
            child: Column(
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Color(0xff001A28),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Transaction Details",
                            style: TextStyle(color: Colors.white),
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert))
                        ],
                      ),
                      Expanded(
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xff003450),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Gross",
                                      style:
                                      TextStyle(color: Color(0xff9DD1FE)),
                                    ),
                                    Text(
                                      "${transactionState
                                          .summedValues["totalPieces"]} Pcs | ${transactionState
                                          .summedValues["netWt"]} gms",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xff003450),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Metal",
                                      style:
                                      TextStyle(color: Color(0xff9DD1FE)),
                                    ),
                                    Text(
                                      " -  | ${transactionState
                                          .summedValues["metalWt"]} gms",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xff003450),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Dia",
                                      style:
                                      TextStyle(color: Color(0xff9DD1FE)),
                                    ),
                                    Text(
                                      "${transactionState
                                          .summedValues["diaPieces"]} Pcs | ${transactionState
                                          .summedValues["diaWt"]} gms",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xff003450),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Labour",
                                      style:
                                      TextStyle(color: Color(0xff9DD1FE)),
                                    ),
                                    Text(
                                      " - ",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Color(0xff003450),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.all(7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Wastage",
                                      style:
                                      TextStyle(color: Color(0xff9DD1FE)),
                                    ),
                                    Text(
                                      " - ",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      // height: 800,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black)),
                      child: Expanded(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,

                            // physics: NeverScrollableScrollPhysics(),
                            itemCount: transactionState.transaction != null
                                ? transactionState.transaction!.varients.length
                                : 0,
                            itemBuilder: (context, index) {
                              InventoryItemModel item =
                              InventoryItemModel.fromJson2(transactionState
                                  .transaction!.varients[index]);
                              print("item varient ${item.varientName}");
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "STYLE ",
                                          style: TextStyle(
                                              color: Color(0xff1990FF)),
                                        ),
                                        Text("| "),
                                        Text(item.varientName),
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            return;
                                            showDialog(context: context,
                                              builder: (context) =>
                                                  Dialog(
                                                      child: FormulaDialog(
                                                          item.formulaDetails),

                                                  ),);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                              horizontal: 5,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Color(0xffe1dada),
                                                borderRadius:
                                                BorderRadius.circular(3)),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            child: Center(
                                              child: Text("F"),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  Dialog(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                    child: SizedBox(
                                                      height: 600,
                                                      child: Column(
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Row(
                                                              // mainAxisSize: MainAxisSize.min,
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                              children: [
                                                                IconButton(
                                                                    onPressed: () {
                                                                      Navigator
                                                                          .pop(
                                                                          context);
                                                                    },
                                                                    icon: Icon(
                                                                        Icons
                                                                            .close))
                                                              ],
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 9,
                                                            child: Padding(
                                                              padding:
                                                              EdgeInsets.all(
                                                                  10),
                                                              child: ItemDetails(
                                                                  bom: item.bom,
                                                                  operation: item
                                                                      .operation),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                            );
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: Color(0xffe1dada),
                                                borderRadius:
                                                BorderRadius.circular(3)),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            child: Center(
                                              child: Text("B"),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                              color: Color(0xffe1dada),
                                              borderRadius:
                                              BorderRadius.circular(3)),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          child: Center(
                                            child: Text("A"),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          // height: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xffe1dada),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Item Description",
                                                style: TextStyle(
                                                    color: Color(0xff024D8B)),
                                              ),
                                              Row(
                                                children: [
                                                  Text("${item.pieces} Pcs "),
                                                  Text("| "),
                                                  Text("${item.netWeight} gms")
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              )
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Container(
                                          // height: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xffe1dada),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Metal",
                                                style: TextStyle(
                                                    color: Colors.teal),
                                              ),
                                              Row(
                                                children: [
                                                  Text(" - "),
                                                  Text("| "),
                                                  Text(
                                                      "${item.metalWeight} gms")
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              )
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Container(
                                          // height: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xffe1dada),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Dia",
                                                style: TextStyle(
                                                    color: Colors.purple),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                      "${item.diaPieces} Pcs "),
                                                  Text("| "),
                                                  Text("${item.diaWeight} gms")
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              )
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Container(
                                          // height: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xffe1dada),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Labour",
                                                style: TextStyle(
                                                    color: Colors.pink),
                                              ),
                                              Row(
                                                children: [
                                                  Text(" - "),
                                                  Text("| "),
                                                  Text(" - ")
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              )
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                          padding: EdgeInsets.all(10),
                                        ),
                                        Container(
                                          // height: 100,
                                          decoration: BoxDecoration(
                                            color: Color(0xffe1dada),
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                "Wastage",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                              Row(
                                                children: [
                                                  Text(" - "),
                                                  Text("| "),
                                                  Text("0")
                                                ],
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                              )
                                            ],
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                          ),
                                          padding: EdgeInsets.all(10),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 30,),
                                    DashedLine()

                                  ],

                                ),
                              );
                            },
                            ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DashedLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, 2),
      painter: DashedLinePainter(),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 5,
        dashSpace = 5,
        startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
