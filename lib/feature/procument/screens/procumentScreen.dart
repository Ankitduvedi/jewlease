import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

import '../../vendor/controller/procumentVendor_controller.dart';
import '../controller/procumentVarientFormula.dart';
import '../controller/procumentVendorDailog.dart';
import '../controller/procumentcController.dart';
import 'dialog.dart';
import 'procumentSummeryScreen.dart';

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
        Duration(seconds: 2),
        () => showDialog(
            context: context,
            builder: (context) => Dialog(child: procumentDialog())));
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
      "weight": input["Weight"],
      "netWeight": input["Net Weight"],
      "diaWeight": input["Dia Weight"],
      "diaPieces": input["Dia Pieces"],
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
                          Map<String, dynamic> reuestBody =
                              convertToSchema(varientList[i]);
                          reuestBody["vendor"] =
                              ref.read(pocVendorProvider)["Vendor Name"];
                          reuestBody["vendorCode"] =
                              ref.read(pocVendorProvider)["Vendor Code"];
                          reuestBody["location"] = "warehouse";
                          reuestBody["department"] = "";
                          reuestBody["itemGroup"] = reuestBody["style"];
                          reuestBody["metalColor"] = reuestBody["Karat Color"];
                          reuestBody["styleMetalColor"] =
                              reuestBody["Karat Color"];
                          reuestBody["pieces"] = 5;
                          reuestBody["netWeight"] = reuestBody["weight"];

                          print("req body is $reuestBody");

                          await ref
                              .read(procurementControllerProvider.notifier)
                              .sendGRN(reuestBody);
                        }
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
