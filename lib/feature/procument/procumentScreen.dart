import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/formula/controller/formula_prtocedure_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';

import 'dialog.dart';

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

  InAppWebViewController? webViewController;
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
            appBar: AppBar(
              title: const Text('Goods Reciept Note'),
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
            body: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri.uri(Uri.file(
                        "C:/Users/ASUS/StudioProjects/jewlease/lib/procument.html"))),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                  ),
                ),
                onWebViewCreated: (controller) {
                  webViewController = controller;

                  controller.addJavaScriptHandler(
                    handlerName: 'openDialog',
                    callback: (args) {
                      if (args.isNotEmpty) {
                        // Expecting args[0] to be a Map with 'row' and 'col'
                        var cellInfo = args[0];
                        int rowIndex = cellInfo['row'];
                        int colIndex = cellInfo['col'];
                      }
                    },
                  );
                }),
            // SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       // Padding(
            //       //   padding:
            //       //       EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            //       //   child: Row(
            //       //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       //     children: [
            //       //       Text('Load By'),
            //       //       const SizedBox(
            //       //         width: 10,
            //       //       ),
            //       //       Container(
            //       //         width: screenWidth * 0.1,
            //       //         height: screenHeight * 0.04,
            //       //         padding: EdgeInsets.symmetric(horizontal: 12.0),
            //       //         decoration: BoxDecoration(
            //       //           color: Color(0xff28713E),
            //       //           // Green background for the selected item
            //       //           borderRadius: BorderRadius.circular(5.0),
            //       //         ),
            //       //         child: DropdownButton<String>(
            //       //           value: selectedValue,
            //       //           hint: Text(
            //       //             "Select an option",
            //       //             style: TextStyle(color: Colors.white),
            //       //           ),
            //       //           icon: Icon(Icons.arrow_drop_down,
            //       //               color: Colors.white),
            //       //           // Down arrow icon
            //       //           dropdownColor: Colors.white,
            //       //           // Background color of dropdown menu
            //       //           underline: SizedBox(),
            //       //           // Removes the underline
            //       //           isExpanded: true,
            //       //           items: [
            //       //             DropdownMenuItem(
            //       //               value: "Variant",
            //       //               child: Text(
            //       //                 "Variant",
            //       //                 style: TextStyle(
            //       //                     color: Colors
            //       //                         .black), // Dropdown item color
            //       //               ),
            //       //             ),
            //       //             DropdownMenuItem(
            //       //               value: "Reference",
            //       //               child: Text(
            //       //                 "Reference",
            //       //                 style: TextStyle(
            //       //                     color: Colors
            //       //                         .black), // Dropdown item color
            //       //               ),
            //       //             ),
            //       //           ],
            //       //           onChanged: (value) {
            //       //             setState(() {
            //       //               selectedValue = value;
            //       //             });
            //       //           },
            //       //           style: TextStyle(
            //       //             color: Colors.white, // Selected value color
            //       //             fontWeight: FontWeight.w400,
            //       //           ),
            //       //         ),
            //       //       ),
            //       //       SizedBox(
            //       //         height: screenHeight * 0.04,
            //       //         width: screenWidth * 0.15,
            //       //         child: TextField(
            //       //           decoration: InputDecoration(
            //       //             labelText: 'Search',
            //       //             border: OutlineInputBorder(),
            //       //             prefixIcon: Icon(Icons.search),
            //       //           ),
            //       //           onChanged: (query) {
            //       //             setState(() {});
            //       //           },
            //       //         ),
            //       //       ),
            //       //       Container(
            //       //         padding: EdgeInsets.symmetric(
            //       //             horizontal: 10, vertical: 5),
            //       //         decoration: BoxDecoration(
            //       //             borderRadius: BorderRadius.circular(5),
            //       //             color: Color(0xff28713E)),
            //       //         child: Row(
            //       //           children: [
            //       //             Icon(
            //       //               Icons.filter_alt_rounded,
            //       //               color: Colors.white,
            //       //             ),
            //       //             Text(
            //       //               'Filter',
            //       //               style: TextStyle(color: Colors.white),
            //       //             ),
            //       //           ],
            //       //         ),
            //       //       ),
            //       //       SizedBox(
            //       //         width: screenWidth * 0.5,
            //       //       )
            //       //     ],
            //       //   ),
            //       // ),
            //       SizedBox(
            //         height: screenHeight * 0.8,
            //         width: screenWidth,
            //         child: InAppWebView(
            //             initialUrlRequest: URLRequest(
            //                 url: WebUri.uri(Uri.file(
            //                     "C:/Users/ASUS/StudioProjects/jewlease/lib/procument.html"))),
            //             initialOptions: InAppWebViewGroupOptions(
            //               crossPlatform: InAppWebViewOptions(
            //                 javaScriptEnabled: true,
            //               ),
            //             ),
            //             onWebViewCreated: (controller) {
            //               webViewController = controller;
            //
            //               controller.addJavaScriptHandler(
            //                 handlerName: 'openDialog',
            //                 callback: (args) {
            //                   if (args.isNotEmpty) {
            //                     // Expecting args[0] to be a Map with 'row' and 'col'
            //                     var cellInfo = args[0];
            //                     int rowIndex = cellInfo['row'];
            //                     int colIndex = cellInfo['col'];
            //                   }
            //                 },
            //               );
            //             }),
            //       ),
            //     ],
            //   ),
            // ),
          ),
        ),
      ],
    );
  }
}
