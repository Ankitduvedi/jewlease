import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

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
              body: ProcumentSummaryScreen()),
        ),
      ],
    );
  }
}
