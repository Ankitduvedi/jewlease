import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/utils/utils.dart';
import 'package:jewlease/data/model/transaction_model.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/feature/transaction/controller/transaction_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

import '../../../core/routes/go_router.dart';
import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentVarientFormula.dart';
import '../controller/procumentVendorDailog.dart';
import '../controller/procumentcController.dart';
import 'procumentSummeryScreen.dart';
import 'procumentVendorDialog.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class procumentScreen extends ConsumerStatefulWidget {
  @override
  _procumentScreenState createState() => _procumentScreenState();
}

class _procumentScreenState extends ConsumerState<procumentScreen> {
  List<String> _tabs = [
    'Goods Reciept Note',
    'Purchase Order',
    'Purchase Return',
  ];
  late Function(Map<String, dynamic>) addRowToGrid;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
        Duration(milliseconds: 500),
        () => showDialog(
            context: context,
            builder: (context) => Dialog(child: procumentVendorDialog())));
    // showDialog(context: context, builder: (context) => procumentDialog());
    super.initState();
  }

  Map<String, dynamic> convertToSchema(Map<String, dynamic> input) {
    return {
      "style": input["Style"],
      "varientName": input["Varient Name"],
      "oldVarient": input["Old Varient"],
      "customerVarient": input["Customer Varient"],
      "baseVarient": input["Base Varient"],
      "vendor": input["Vendor"],
      "remark1": input["Remark 1"],
      "vendorVarient": input["Vendor Varient"],
      "remark2": input["Remark 2"],
      "createdBy": input["Created By"],
      "stdBuyingRate": input["Std Buying Rate"],
      "stoneMaxWt": input["Stone Max Wt"],
      "remark": input["Remark"],
      "stoneMinWt": input["Stone Min Wt"],
      "karatColor": input["Karat Color"],
      "deliveryDays": input["Delivery Days"],
      "forWeb": input["For Web"],
      "rowStatus": input["Row Status"],
      "verifiedStatus": input["Verified Status"],
      "length": input["Length"],
      "codegenSrNo": input["Codegen Sr No"],
      "category": input["CATEGORY"],
      "subCategory": input["Sub-Category"],
      "styleKarat": input["STYLE KARAT"],
      "varient": input["Varient"],
      "hsnSacCode": input["HSN - SAC CODE"],
      "lineOfBusiness": input["LINE OF BUSINESS"],
      "bom": input["BOM"],
      "operation": input["Operation"],
      "imageDetails": input["Image Details"],
      "formulaDetails": input["Formula Details"],
      "pieces": input["Pieces"],
      "weight": (input["Weight"] ?? 0) - (input["Stone Wt"] ?? 0),
      "netWeight": input["Weight"] ?? 0,
      "diaWeight": input["Stone Wt"] ?? 0,
      "diaPieces": input["Stone Pieces"] ?? 0,
      "loactionCode": input["Location Code"],
    };
  }

  String? selectedValue = 'Variant';

  @override
  Widget build(
    BuildContext context,
  ) {
    final selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Container(
          height: screenHeight * 0.1,
        ),
        Container(
            height: screenHeight * 0.06,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
            child: Container(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                    children: List.generate(
                  3,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(tabIndexProvider.notifier).state = index;
                      },
                      child: Container(
                        color: index == selectedIndex
                            ? Color(0xff28713E)
                            : Colors.white,
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.007),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.005),
                          decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? Color(0xff28713E)
                                : Color(0xffF0F4F8),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                  color: index == selectedIndex
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )))),
        Container(
          height: 10,
        ),
        Expanded(
          child: Scaffold(

              // Container(
              //   width: double.infinity,
              //   height: 50,
              //   color: Colors.green,
              // ),
              appBar: AppBar(
                actions: [
                  AppBarButtons(
                    ontap: [
                      () {
                        if (selectedIndex == 1)
                          showDialog(
                              context: context,
                              builder: (context) => procumentScreen());
                        log('new pressed');
                        if (selectedIndex == 3)
                          context.go('/addFormulaProcedureScreen');
                      },
                      () async {
                        List<Map<String, dynamic>>? varientList =
                            ref.read(procurementVariantProvider);
                        print("varientList = $varientList ");

                        Map<dynamic, dynamic> allFormualMap =
                            ref.read(varientAllFormulaProvider);

                        print("allFormulas = $allFormualMap");

                        List<Map<String, dynamic>> reqstBodeis = [];

                        for (int i = 0; i < varientList!.length; i++) {
                          List<dynamic> allFormulas = [];
                          String formulaName =
                              "$i${varientList[i]["Varient Name"]}";
                          for (String formula in allFormualMap.keys) {
                            if (formula.contains(formulaName)) {
                              allFormulas.add(allFormualMap[formula]);
                            }
                          }
                          Map<dynamic, dynamic> formulaJsonMap = {};
                          for (int i = 0; i < allFormulas.length; i++) {
                            formulaJsonMap["row$i"] = allFormulas[i];
                          }
                          print(
                              "$i th row len ${allFormulas.length} all formula are $allFormulas");

                          varientList[i]["Formula Details"] = formulaJsonMap;
                          allFormulas = [];
                          print("varientList is ${varientList[i]}");
                          Map<String, dynamic> reuestBody =
                              convertToSchema(varientList[i]);
                          reuestBody["vendor"] =
                              ref.read(pocVendorProvider)["Vendor Name"];

                          reuestBody["vendorCode"] =
                              ref.read(pocVendorProvider)["Vendor Code"];
                          reuestBody["location"] = "warehouse";
                          reuestBody["department"] = "MH_CASH";
                          reuestBody["itemGroup"] = reuestBody["style"];
                          reuestBody["metalColor"] = reuestBody["Karat Color"];
                          reuestBody["styleMetalColor"] =
                              reuestBody["Karat Color"];

                          print("req body is $reuestBody");

                          reqstBodeis.add(reuestBody);
                        }

                        TransactionModel transaction = TransactionModel(
                            transType: "Opening Stock",
                            subType: "OPS",
                            transCategory: "GENERAL",
                            docNo: "bsjbcs",
                            transDate: DateTime.now().toIso8601String(),
                            source: "WareHouse",
                            destination: "MH_CASH",
                            customer: "ankit",
                            sourceDept: "Warehouse",
                            destinationDept: "MH_CASH",
                            exchangeRate: "0.0",
                            currency: "RS",
                            salesPerson: "Arun",
                            term: "term",
                            remark: "Creating GRN",
                            createdBy: DateTime.now().toIso8601String(),
                            postingDate: DateTime.now().toIso8601String(),
                            varients: reqstBodeis);
                        String? transactionID = await ref
                            .read(TransactionControllerProvider.notifier)
                            .sentTransaction(transaction);
                        print("transactionID is $transactionID");
                        for (var reqstBody in reqstBodeis) {
                          // reqstBody[]
                          // await ref
                          //     .read(procurementControllerProvider.notifier)
                          //     .sendGRN(reqstBody);
                        }

                        Utils.snackBar("Varient Aadded", context);
                        goRouter.go("/");
                        // Navigator.pop(context);
                      },
                      () {
                        // Reset the provider value to null on refresh
                        ref.watch(formulaProcedureProvider.notifier).state = [
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
              body: ProcumentSummaryScreen()),
        ),
      ],
    );
  }
}
