import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/formula/screens/rangeGrid.dart';
import 'package:jewlease/main.dart';

import '../../../providers/dailog_selection_provider.dart';
import '../../../widgets/read_only_textfield_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../controller/formula_prtocedure_controller.dart';
import '../controller/heirarchy_controller.dart';
import 'hierarchyDetailsList.dart';

final boolProvider = StateProvider<bool>((ref) => false);
final excelLoadingProvider = StateProvider<bool>((ref) => false);

class rangeDialog extends ConsumerStatefulWidget {
  rangeDialog({this.intialData = const {}, super.key});

  Map<String, dynamic> intialData;

  @override
  _rangeDialogState createState() => _rangeDialogState();
}

class _rangeDialogState extends ConsumerState<rangeDialog> {
  @override
  TextEditingController rangeHierarchy = TextEditingController();
  TextEditingController rangeType = TextEditingController();

  bool showExcel = false;
  List<List<dynamic>> excelData = [];
  List<dynamic> excelHeaders = [];

  @override
  void initState() {
    // TODO: implement initState
    // ref.read(itemListProvider.notifier).resetDepdList();
    print("intial data is ${widget.intialData}");
    // webViewController = InAppWebViewContr
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(itemListProvider.notifier).resetDepdList();
      intializeExcel();
      initializeItemList();
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  void initializeItemList() async {
    final itemListNotifier = ref.read(itemListProvider.notifier);
    if (widget.intialData["Range Hierarchy Name"] != null) {
      List<Map<String, dynamic>> itemList = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .fetchRangeMasterList(widget.intialData["Range Hierarchy Name"], "");
      print("item list is $itemList");

      for (var item in itemList) {
        final currentItem = item["Data Type"];
        final currentVal = item["Depd Field"];

        if (currentItem != null && currentVal != null) {
          itemListNotifier.addItemToList(currentItem, currentVal);
        }
      }
      setState(() {});
    }
  }

  //<--------------------Intialize Range Excel-------------------------->
  void intializeExcel() async {
    if (widget.intialData["Range Hierarchy Name"] != null) {
      ref.read(excelLoadingProvider.notifier).state = true;
      Map<dynamic, dynamic> excel = await ref
          .read(formulaProcedureControllerProvider.notifier)
          .fetchRangeMasterExcel(
              widget.intialData["Range Hierarchy Name"], context);

      List<dynamic> excelRows1 = excel["Details"]["excelData"];
      excelHeaders = excel["Details"]["Headers"];
      for (var row in excelRows1) {
        List<dynamic> newRow = [];
        for (var cell in row) newRow.add(cell);
        excelData.add(newRow);
      }

      ref.read(excelLoadingProvider.notifier).state = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    final selectedItems = ref.watch(selectedItemProvider);
    final itemListNotifier = ref.watch(itemListProvider.notifier);
    final itemMap = ref.watch(itemListProvider);
    final itemValues = ref.watch(itemValueProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    bool isToggled = ref.watch(boolProvider);
    bool isLoadingExcel = false;
    // TODO: implement build
    FocusNode focusNode = FocusNode();
    return RawKeyboardListener(
        focusNode: focusNode,
        onKey: (RawKeyEvent event) {
          if (event.isKeyPressed(LogicalKeyboardKey.altLeft) &&
              event.isKeyPressed(LogicalKeyboardKey.keyO)) {
            print('Alt+O pressed!');
          }
        },
        child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Range Master',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Esc to close',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              SizedBox(width: 10),
                              Icon(
                                Icons.close,
                                size: 25,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.13,
                                child: TextFieldWidget(
                                    labelText: 'Range Hierechy Name',
                                    controller: rangeHierarchy),
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              SizedBox(
                                width: screenWidth * 0.13,
                                child: ReadOnlyTextFieldWidget(
                                  hintText: ref.read(dialogSelectionProvider)[
                                          'Attribute Type'] ??
                                      'Item',
                                  labelText: 'Range Type',
                                  icon: Icons.search,
                                  onIconPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ItemTypeDialogScreen(
                                        title: 'Attribute Type',
                                        endUrl:
                                            'FormulaProcedures/RateStructure/RangeType',
                                        value: 'Config value',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          Text(
                            'Formula Range Hierarchy details',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: screenWidth * 0.13,
                                height: screenHeight * 0.05,
                                child: ReadOnlyTextFieldWidget(
                                  hintText: ref.watch(itemProvider) == ''
                                      ? 'Data Type'
                                      : ref.watch(itemProvider),
                                  labelText: 'Data Type',
                                  icon: Icons.search,
                                  onIconPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const ItemTypeDialogScreen(
                                        title: 'Data Type',
                                        endUrl:
                                            'FormulaProcedures/RateStructure/DataType',
                                        value: 'Config Id',
                                        keyOfMap: 'ConfigValue',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              SizedBox(
                                width: screenWidth * 0.13,
                                height: screenHeight * 0.05,
                                child: ReadOnlyTextFieldWidget(
                                  hintText: ref.watch(valueProvider) == ''
                                      ? 'Depd Field'
                                      : ref.watch(valueProvider),
                                  labelText: 'Depd Field',
                                  icon: Icons.search,
                                  onIconPressed: () {
                                    String item = ref.read(itemProvider);
                                    String endUrl = '';
                                    if (item == 'Number') {
                                      endUrl =
                                          'FormulaProcedures/RateStructure/NumberDepdField';
                                    } else {
                                      endUrl = 'AllAttribute/AttributeType';
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          ItemTypeDialogScreen(
                                        title: 'Depd Field',
                                        endUrl: endUrl,
                                        value: item == 'Number'
                                            ? 'Config Id'
                                            : 'ConfigValue',
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02,
                                    vertical: screenHeight * 0.005),
                                height: screenHeight * 0.05,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(child: Text('Clear')),
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              InkWell(
                                onTap: () async {
                                  final currentItem =
                                      ref.read(itemProvider.notifier).getItem();
                                  final currentVal = ref
                                      .read(valueProvider.notifier)
                                      .getValue();
                                  ref.read(itemProvider.notifier).setItem('');
                                  ref.read(valueProvider.notifier).setValue('');
                                  //Category: CHAIN, Sub-Category: sub karat, Style Karat: 24, Varient: CAS, HSN-SAC Code: 12, Line of Business: GL1
                                  itemListNotifier.addItemToList(
                                      currentItem, currentVal);
                                  print(
                                      "cuurent item is $currentItem and value is $currentVal");

                                  // String jsCode =
                                  //     """addCustomHeaderRow("$currentVal");""";
                                  // if (webViewController != null) {
                                  //   await webViewController!
                                  //       .evaluateJavascript(source: jsCode);
                                  // }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02,
                                      vertical: screenHeight * 0.005),
                                  height: screenHeight * 0.05,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                              InkWell(
                                onTap: () async {
                                  ref
                                      .read(excelLoadingProvider.notifier)
                                      .state = true;
                                  ref.read(boolProvider.notifier).state =
                                      !isToggled;

                                  Future.delayed(Duration(seconds: 0), () {
                                    final headerValues = itemMap.entries
                                        .expand((entry) => entry.key == 'Number'
                                            ? entry.value.expand((value) =>
                                                ['$value start', '$value end'])
                                            : entry.value.map((value) => value))
                                        .toList();
                                    print("header values is $headerValues");
                                    headerValues.insert(0, "Output");
                                    _callAddHeaderRow(headerValues);
                                  });
                                  Future.delayed(Duration(seconds: 0), () {
                                    ref
                                        .read(excelLoadingProvider.notifier)
                                        .state = false;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.02,
                                      vertical: screenHeight * 0.005),
                                  height: screenHeight * 0.05,
                                  decoration: BoxDecoration(
                                    color: ref.read(boolProvider)
                                        ? Colors.grey
                                        : Colors.green,
                                    border: Border.all(
                                        color: ref.read(boolProvider)
                                            ? Colors.grey
                                            : Colors.green),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Create excel',
                                      style: TextStyle(
                                          color: ref.read(boolProvider)
                                              ? Colors.black
                                              : Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Container(
                              height: screenHeight * 0.5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        child: HierarchyDetailsList()),
                                    if (ref.watch(excelLoadingProvider))
                                      SizedBox(
                                        height: 50,
                                        width: 600,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: CupertinoColors.systemBlue,
                                          ),
                                        ),
                                      ),
                                    if (ref.read(boolProvider) == true)
                                      SizedBox(
                                        height: screenHeight,
                                        width: screenWidth,
                                        child: Rangegrid(
                                            headers: excelHeaders,
                                            excelData: excelData,
                                            rangeHierarchy:
                                                rangeHierarchy.text),

                                        // InAppWebView(
                                        //   initialFile: "assets/range.html",
                                        //     // initialUrlRequest: URLRequest(
                                        //     //     url: WebUri.uri(Uri.file(
                                        //     //         "/Users/arpitverma/StudioProjects/jwelease/lib/range.html",windows: false))),
                                        //     initialSettings:
                                        //         InAppWebViewSettings(
                                        //       javaScriptEnabled: true,
                                        //     ),
                                        //     onLoadStop:
                                        //         (controller, url) async {
                                        //       // webViewController = controller;
                                        //       setState(() {});
                                        //       // intializeExcel();
                                        //       final itemListNotifier = ref.read(
                                        //           itemListProvider.notifier);
                                        //       Map<dynamic, dynamic> excel = await ref
                                        //           .read(
                                        //               formulaProcedureControllerProvider
                                        //                   .notifier)
                                        //           .fetchRangeMasterExcel(
                                        //               widget.intialData[
                                        //                   "Range Hierarchy Name"],
                                        //               context);
                                        //
                                        //       final String jsonData2 =
                                        //           jsonEncode(excel["Details"]
                                        //               ["excelData"]);
                                        //       Future.delayed(
                                        //           Duration(seconds: 1), () {
                                        //         webViewController
                                        //             ?.evaluateJavascript(
                                        //           source:
                                        //               "updateHandsontableData('$jsonData2');",
                                        //         );
                                        //       });
                                        //       final String excelHeaders =
                                        //           jsonEncode(excel["Details"]
                                        //               ["Headers"]);
                                        //       Future.delayed(
                                        //           Duration(seconds: 1), () {
                                        //         webViewController
                                        //             ?.evaluateJavascript(
                                        //           source:
                                        //               "addCustomHeaderRow('$excelHeaders');",
                                        //         );
                                        //       });
                                        //     },
                                        //     onWebViewCreated: (controller) {
                                        //       webViewController = controller;
                                        //
                                        //
                                        //       controller.addJavaScriptHandler(
                                        //         handlerName: 'openDialog',
                                        //         callback: (args) {
                                        //           if (args.isNotEmpty) {
                                        //             // Expecting args[0] to be a Map with 'row' and 'col'
                                        //             var cellInfo = args[0];
                                        //             int rowIndex =
                                        //                 cellInfo['row'];
                                        //             int colIndex =
                                        //                 cellInfo['col'];
                                        //
                                        //             _handleOpenDialog(
                                        //                 rowIndex,
                                        //                 colIndex,
                                        //                 selectedItems,
                                        //                 itemMap);
                                        //           }
                                        //         },
                                        //       );
                                        //     }),
                                      ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              //
                              SizedBox(
                                width: screenWidth * 0.01,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  // Function to call the JavaScript function and pass header values
  void _callAddHeaderRow(List<String> headerValues) async {
    setState(() {
      excelHeaders = headerValues;
    });
  }
}
