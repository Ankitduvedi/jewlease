import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/feature/formula/screens/newRangeDialog.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/data_widget.dart';

import 'addFormulaProcedure.dart';

final tabIndexProvider = StateProvider<int>((ref) => 1);

class FormulaProcdedureScreen extends ConsumerWidget {
  FormulaProcdedureScreen({super.key});

  final List<String> _tabs = [
    'Formula Mapping',
    'Rate Structure',
    'Fomula Procedure',
        'Fomula Procedure'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    screenWidth = MediaQuery.of(context).size.width;
    final selectedIndex = ref.watch(tabIndexProvider);
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
            child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Row(
                    children: List.generate(
                  4,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(tabIndexProvider.notifier).state = index;
                      },
                      child: Container(
                        color: index == selectedIndex
                            ? const Color(0xff28713E)
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
                                ? const Color(0xff28713E)
                                : const Color(0xffF0F4F8),
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
          appBar: AppBar(
            title: const Text('Formula Procedure Master details'),
            actions: [
              AppBarButtons(
                ontap: [
                  () {
                    if (selectedIndex == 0) {
                      context.go('/addformulaMapping');
                    }
                    if (selectedIndex == 1) {
                      showDialog(
                          context: context,
                          builder: (context) => rangeDialog());
                    }
                    log('new pressed');
                    if (selectedIndex == 2) {
                      context.go('/addFormulaProcedureScreen');
                    }
                  },
                  () {},
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
          body: selectedIndex == 1
              ? SizedBox(
                  width: screenWidth,
                  child: ItemDataScreen(
                    title: '',
                    endUrl:
                        'FormulaProcedures/RateStructure/FormulaRangeMaster/',
                    canGo: true,
                    onDoubleClick: (Map<String, dynamic> intialData) {
                      showDialog(
                          context: context,
                          builder: (context) => rangeDialog(
                                intialData: intialData,
                              ));
                    },
                  ),
                )
              : ItemDataScreen(
                  title: '',
                  endUrl: 'FormulaProcedures/table',
                  canGo: true,
                  onDoubleClick: (Map<dynamic, dynamic> intialData) {
                    print("intialData fromula procedure is$intialData ");

                    context.go('/addFormulaProcedureScreen', extra: intialData);
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => AddFormulaProcedure(
                    //     FormulaProcedureName:
                    //         intialData['Formula Procedure Name'],
                    //     ProcedureType: intialData['Procedure Type'],
                    //   ),
                    // );

                    showDialog(
                      context: context,
                      builder: (context) => const AddFormulaProcedure(
                          FormulaProcedureName: '', ProcedureType: ''),
                    );
                  },
                ),
        )),
      ],
    );
  }
}
