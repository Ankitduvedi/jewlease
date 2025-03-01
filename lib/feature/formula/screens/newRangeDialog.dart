// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:jewlease/main.dart';
//
// import '../../../providers/dailog_selection_provider.dart';
// import '../../../widgets/read_only_textfield_widget.dart';
// import '../../../widgets/search_dailog_widget.dart';
// import '../../../widgets/text_field_widget.dart';
// import '../controller/formula_prtocedure_controller.dart';
// import '../controller/heirarchy_controller.dart';
// import 'hierarchyDetailsList.dart';
//
// final boolProvider = StateProvider<bool>((ref) => false);
// final excelLoadingProvider = StateProvider<bool>((ref) => false);
//
// class rangeDialog extends ConsumerStatefulWidget {
//   rangeDialog({this.intialData = const {}, super.key});
//
//   Map<String, dynamic> intialData;
//
//   @override
//   _rangeDialogState createState() => _rangeDialogState();
// }
//
// class _rangeDialogState extends ConsumerState<rangeDialog> {
//   @override
//   TextEditingController rangeHierarchy = TextEditingController();
//   TextEditingController rangeType = TextEditingController();
//   InAppWebViewController? webViewController;
//   bool showExcel = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     // ref.read(itemListProvider.notifier).resetDepdList();
//     print("intial data is ${widget.intialData}");
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(itemListProvider.notifier).resetDepdList();
//       intializeExcel();
//       initializeItemList();
//     });
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//
//     super.dispose();
//   }
//
//   void initializeItemList() async {
//     final itemListNotifier = ref.read(itemListProvider.notifier);
//     if (widget.intialData["Range Hierarchy Name"] != null) {
//       List<Map<String, dynamic>> itemList = await ref
//           .read(formulaProcedureControllerProvider.notifier)
//           .fetchRangeMasterList(widget.intialData["Range Hierarchy Name"], "");
//       print("item list is $itemList");
//
//       for (var item in itemList) {
//         final currentItem = item["Data Type"];
//         final currentVal = item["Depd Field"];
//
//         if (currentItem != null && currentVal != null) {
//           itemListNotifier.addItemToList(currentItem, currentVal);
//         }
//       }
//       setState(() {});
//     }
//   }
//
//   void intializeExcel() async {
//     if (widget.intialData["Range Hierarchy Name"] != null) {
//       ref.read(excelLoadingProvider.notifier).state = true;
//       // setState(() {
//       ref.read(boolProvider.notifier).state = true;
//       // });
//       final itemListNotifier = ref.read(itemListProvider.notifier);
//       Map<dynamic, dynamic> excel = await ref
//           .read(formulaProcedureControllerProvider.notifier)
//           .fetchRangeMasterExcel(
//               widget.intialData["Range Hierarchy Name"], context);
//
//       final String jsonData2 = jsonEncode(excel["Details"]["excelData"]);
//       Future.delayed(Duration(seconds: 1), () {
//         print("initializing excel $jsonData2");
//         webViewController?.evaluateJavascript(
//           source: "updateHandsontableData('$jsonData2');",
//         );
//       });
//       ref.read(excelLoadingProvider.notifier).state = false;
//
//       ref.read(excelLoadingProvider.notifier).state = false;
//       setState(() {});
//     }
//   }
//
//   String _getColumnName(int index) {
//     String column = '';
//     int temp = index;
//     while (temp >= 0) {
//       column = String.fromCharCode((temp % 26) + 65) + column;
//       temp = (temp ~/ 26) - 1;
//     }
//     return column;
//   }
//
//   void _showOptionsDialog(BuildContext context, String title,
//       List<String> options, Function(String) onOptionSelected) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Select Value of ${excelMap[title]}"),
//           content: SizedBox(
//             // Adjust height as needed
//             width: double.maxFinite,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: options.length,
//               itemBuilder: (BuildContext context, int index) {
//                 String option = options[index];
//                 return ListTile(
//                   title: Text(option),
//                   onTap: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                     onOptionSelected(option); // Handle the selection
//                   },
//                 );
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _handleOpenDialog(int row, int col, Map<String, dynamic> selectedItems,
//       Map<String, List<String>> itemMap) {
//     String columnName = _getColumnName(col);
//     List<String> options = [];
//     final headerValues = itemMap.entries
//         .expand((entry) => entry.key == 'Number'
//             ? entry.value.expand((value) => ['$value start', '$value end'])
//             : entry.value.map((value) => value))
//         .toList();
//
//     int index = (columnName.codeUnitAt(0) - 'A'.codeUnitAt(0)).abs();
//     print("index is $index");
//     final item = headerValues[index - 1];
//
//     final isNonNumber = !headerValues
//         .sublist(0, index - 1)
//         .any((element) => element.contains('start') || element.contains('end'));
//
//     print("showing dailog $item");
//     final selectedItemID = ref.read(dialogSelectionProvider)[item];
//
//     if (isNonNumber)
//       showDialog(
//         context: context,
//         builder: (context) => ItemTypeDialogScreen(
//           value: 'AttributeCode',
//           title: item,
//           endUrl: 'AllAttribute',
//           query: item,
//           onOptionSelectd: (selectedOption) {
//             // Handle the selected option
//             print('Selected option: $selectedOption in column: $columnName');
//
//             // Optionally, send the selected option back to the WebView
//             // For example, update the cell with the selected option
//             _sendSelectedValueToWebView(selectedOption);
//           },
//         ),
//       );
//   }
//
//   void _sendSelectedValueToWebView(String value) {
//     if (webViewController != null) {
//       // Escape the value to prevent JavaScript injection
//       String escapedValue = jsonEncode(value);
//       webViewController?.evaluateJavascript(
//         source: 'updateCellWithDialogValue($escapedValue);',
//       );
//     } else {
//       print('WebView controller is null.');
//     }
//   }
//
//   Map<String, String> excelMap = {
//     "B": 'Description',
//     "C": "Data Type",
//     "D": "Variable Name",
//     "E": "Range Value",
//     "F": "Formula",
//     "G": "Row Type",
//     "H": "Round Off",
//     "I": "Account Name",
//     "J": "Editable",
//     "I": "Visible",
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.of(context).size.width;
//     screenHeight = MediaQuery.of(context).size.height;
//     final selectedItems = ref.watch(selectedItemProvider);
//     final itemListNotifier = ref.watch(itemListProvider.notifier);
//     final itemMap = ref.watch(itemListProvider);
//     final itemValues = ref.watch(itemValueProvider);
//     final textFieldvalues = ref.watch(dialogSelectionProvider);
//     bool isToggled = ref.watch(boolProvider);
//     bool isLoadingExcel = false;
//     // TODO: implement build
//     FocusNode focusNode = FocusNode();
//     return RawKeyboardListener(
//         focusNode: focusNode,
//         onKey: (RawKeyEvent event) {
//           if (event.isKeyPressed(LogicalKeyboardKey.altLeft) &&
//               event.isKeyPressed(LogicalKeyboardKey.keyO)) {
//             print('Alt+O pressed!');
//           }
//         },
//         child: Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'Range Master',
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600, fontSize: 20),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             Navigator.pop(context);
//                           },
//                           child: Row(
//                             children: [
//                               Text(
//                                 'Esc to close',
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600, fontSize: 18),
//                               ),
//                               SizedBox(width: 10),
//                               Icon(
//                                 Icons.close,
//                                 size: 25,
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Divider(),
//                   Padding(
//                     padding: EdgeInsets.all(20),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: screenWidth * 0.13,
//                                 child: TextFieldWidget(
//                                     labelText: 'Range Hierechy Name',
//                                     controller: rangeHierarchy),
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.01,
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.13,
//                                 child: ReadOnlyTextFieldWidget(
//                                   hintText: ref.read(dialogSelectionProvider)[
//                                           'Attribute Type'] ??
//                                       'Item',
//                                   labelText: 'Range Type',
//                                   icon: Icons.search,
//                                   onIconPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) =>
//                                           const ItemTypeDialogScreen(
//                                         title: 'Attribute Type',
//                                         endUrl:
//                                             'FormulaProcedures/RateStructure/RangeType',
//                                         value: 'Config value',
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: screenHeight * 0.01,
//                           ),
//                           Text(
//                             'Formula Range Hierarchy details',
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w600, fontSize: 18),
//                           ),
//                           SizedBox(
//                             height: screenHeight * 0.02,
//                           ),
//                           Row(
//                             children: [
//                               SizedBox(
//                                 width: screenWidth * 0.13,
//                                 height: screenHeight * 0.05,
//                                 child: ReadOnlyTextFieldWidget(
//                                   hintText: ref.watch(itemProvider) == ''
//                                       ? 'Data Type'
//                                       : ref.watch(itemProvider),
//                                   labelText: 'Data Type',
//                                   icon: Icons.search,
//                                   onIconPressed: () {
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) =>
//                                           const ItemTypeDialogScreen(
//                                         title: 'Data Type',
//                                         endUrl:
//                                             'FormulaProcedures/RateStructure/DataType',
//                                         value: 'Config Id',
//                                         keyOfMap: 'ConfigValue',
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.01,
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.13,
//                                 height: screenHeight * 0.05,
//                                 child: ReadOnlyTextFieldWidget(
//                                   hintText: ref.watch(valueProvider) == ''
//                                       ? 'Depd Field'
//                                       : ref.watch(valueProvider),
//                                   labelText: 'Depd Field',
//                                   icon: Icons.search,
//                                   onIconPressed: () {
//                                     String item = ref.read(itemProvider);
//                                     String endUrl = '';
//                                     if (item == 'Number') {
//                                       endUrl =
//                                           'FormulaProcedures/RateStructure/NumberDepdField';
//                                     } else {
//                                       endUrl = 'AllAttribute/AttributeType';
//                                     }
//                                     showDialog(
//                                       context: context,
//                                       builder: (context) =>
//                                           ItemTypeDialogScreen(
//                                         title: 'Depd Field',
//                                         endUrl: endUrl,
//                                         value: item == 'Number'
//                                             ? 'Config Id'
//                                             : 'ConfigValue',
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.01,
//                               ),
//                               Container(
//                                 padding: EdgeInsets.symmetric(
//                                     horizontal: screenWidth * 0.02,
//                                     vertical: screenHeight * 0.005),
//                                 height: screenHeight * 0.05,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: Colors.green),
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Center(child: Text('Clear')),
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.01,
//                               ),
//                               InkWell(
//                                 onTap: () async {
//                                   final currentItem =
//                                       ref.read(itemProvider.notifier).getItem();
//                                   final currentVal = ref
//                                       .read(valueProvider.notifier)
//                                       .getValue();
//                                   ref.read(itemProvider.notifier).setItem('');
//                                   ref.read(valueProvider.notifier).setValue('');
//                                   //Category: CHAIN, Sub-Category: sub karat, Style Karat: 24, Varient: CAS, HSN-SAC Code: 12, Line of Business: GL1
//                                   itemListNotifier.addItemToList(
//                                       currentItem, currentVal);
//                                   print(
//                                       "cuurent item is $currentItem and value is $currentVal");
//
//                                   String jsCode =
//                                       """addCustomHeaderRow("$currentVal");""";
//                                   if (webViewController != null) {
//                                     await webViewController!
//                                         .evaluateJavascript(source: jsCode);
//                                   }
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.02,
//                                       vertical: screenHeight * 0.005),
//                                   height: screenHeight * 0.05,
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     border: Border.all(color: Colors.green),
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'Add',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: screenWidth * 0.01,
//                               ),
//                               InkWell(
//                                 onTap: () async {
//                                   ref
//                                       .read(excelLoadingProvider.notifier)
//                                       .state = true;
//                                   ref.read(boolProvider.notifier).state =
//                                       !isToggled;
//
//                                   Future.delayed(Duration(seconds: 2), () {
//                                     final headerValues = itemMap.entries
//                                         .expand((entry) => entry.key == 'Number'
//                                             ? entry.value.expand((value) =>
//                                                 ['$value start', '$value end'])
//                                             : entry.value.map((value) => value))
//                                         .toList();
//                                     print("header values is $headerValues");
//                                     headerValues.insert(0, "Output");
//                                     _callAddHeaderRow(headerValues);
//                                   });
//                                   Future.delayed(Duration(seconds: 1), () {
//                                     ref
//                                         .read(excelLoadingProvider.notifier)
//                                         .state = false;
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.02,
//                                       vertical: screenHeight * 0.005),
//                                   height: screenHeight * 0.05,
//                                   decoration: BoxDecoration(
//                                     color: ref.read(boolProvider)
//                                         ? Colors.grey
//                                         : Colors.green,
//                                     border: Border.all(
//                                         color: ref.read(boolProvider)
//                                             ? Colors.grey
//                                             : Colors.green),
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'Create excel',
//                                       style: TextStyle(
//                                           color: ref.read(boolProvider)
//                                               ? Colors.black
//                                               : Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(
//                             height: screenHeight * 0.02,
//                           ),
//                           Container(
//                               height: screenHeight * 0.5,
//                               width: double.infinity,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: Colors.grey.shade400),
//                                 borderRadius: BorderRadius.circular(15),
//                               ),
//                               child: SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     Container(
//                                         width: double.infinity,
//                                         child: HierarchyDetailsList()),
//                                     if (ref.watch(excelLoadingProvider))
//                                       SizedBox(
//                                         height: 50,
//                                         width: 600,
//                                         child: Center(
//                                           child: CircularProgressIndicator(
//                                             color: CupertinoColors.systemBlue,
//                                           ),
//                                         ),
//                                       ),
//                                     if (ref.read(boolProvider) == true)
//                                       SizedBox(
//                                         height: screenHeight,
//                                         width: screenWidth,
//                                         child: InAppWebView(
//                                             initialUrlRequest: URLRequest(
//                                                 url: WebUri.uri(Uri.file(
//                                                     "C:/Users/ASUS/StudioProjects/jewlease/lib/range.html"))),
//                                             initialOptions:
//                                                 InAppWebViewGroupOptions(
//                                               crossPlatform:
//                                                   InAppWebViewOptions(
//                                                 javaScriptEnabled: true,
//                                               ),
//                                             ),
//                                             onLoadStop:
//                                                 (controller, url) async {
//                                               // webViewController = controller;
//                                               setState(() {});
//                                               // intializeExcel();
//                                               final itemListNotifier = ref.read(
//                                                   itemListProvider.notifier);
//                                               Map<dynamic, dynamic> excel = await ref
//                                                   .read(
//                                                       formulaProcedureControllerProvider
//                                                           .notifier)
//                                                   .fetchRangeMasterExcel(
//                                                       widget.intialData[
//                                                           "Range Hierarchy Name"],
//                                                       context);
//
//                                               final String jsonData2 =
//                                                   jsonEncode(excel["Details"]
//                                                       ["excelData"]);
//                                               Future.delayed(
//                                                   Duration(seconds: 1), () {
//                                                 webViewController
//                                                     ?.evaluateJavascript(
//                                                   source:
//                                                       "updateHandsontableData('$jsonData2');",
//                                                 );
//                                               });
//                                               final String excelHeaders =
//                                                   jsonEncode(excel["Details"]
//                                                       ["Headers"]);
//                                               Future.delayed(
//                                                   Duration(seconds: 1), () {
//                                                 webViewController
//                                                     ?.evaluateJavascript(
//                                                   source:
//                                                       "addCustomHeaderRow('$excelHeaders');",
//                                                 );
//                                               });
//                                             },
//                                             onWebViewCreated: (controller) {
//                                               webViewController = controller;
//
//                                               controller.addJavaScriptHandler(
//                                                 handlerName: 'openDialog',
//                                                 callback: (args) {
//                                                   if (args.isNotEmpty) {
//                                                     // Expecting args[0] to be a Map with 'row' and 'col'
//                                                     var cellInfo = args[0];
//                                                     int rowIndex =
//                                                         cellInfo['row'];
//                                                     int colIndex =
//                                                         cellInfo['col'];
//
//                                                     _handleOpenDialog(
//                                                         rowIndex,
//                                                         colIndex,
//                                                         selectedItems,
//                                                         itemMap);
//                                                   }
//                                                 },
//                                               );
//                                             }),
//                                       ),
//                                   ],
//                                 ),
//                               )),
//                           SizedBox(
//                             height: screenHeight * 0.02,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               //
//                               SizedBox(
//                                 width: screenWidth * 0.01,
//                               ),
//                               InkWell(
//                                 onTap: () async {
//                                   final dataList =
//                                       itemMap.entries.expand((entry) {
//                                     if (entry.key == 'Number') {
//                                       // For 'Number', add two maps for each value
//                                       return entry.value.expand((value) => [
//                                             {
//                                               'dataType': entry.key,
//                                               'depdField': '$value start'
//                                             },
//                                             {
//                                               'dataType': entry.key,
//                                               'depdField': '$value end'
//                                             },
//                                           ]);
//                                     } else {
//                                       // For other keys, just create a map for each value
//                                       return entry.value.map(
//                                         (value) => {
//                                           'dataType': entry.key,
//                                           'depdField': value
//                                         },
//                                       );
//                                     }
//                                   }).toList();
//                                   print("data list is $dataList");
//                                   print(
//                                       "selcted range is ${ref.read(dialogSelectionProvider)['Attribute Type']}");
//                                   Map<String, dynamic> reqBody = {
//                                     "rangeHierarchyName": rangeHierarchy.text,
//                                     "rangeType":
//                                         ref.read(dialogSelectionProvider)[
//                                             'Attribute Type'],
//                                     "details": dataList,
//                                   };
//                                   print("add range mamster body $reqBody");
//                                   ref
//                                       .read(formulaProcedureControllerProvider
//                                           .notifier)
//                                       .addRangeMasterDepdField(
//                                           reqBody, context);
//
//                                   // save excel data
//                                   List<dynamic> data = jsonDecode(
//                                       await webViewController
//                                           ?.evaluateJavascript(
//                                     source: "getHandsontableData()",
//                                   ));
//                                   List<List<dynamic>> excelData = [];
//                                   for (int i = 0; i < data.length; i++) {
//                                     List<dynamic> row = [];
//                                     for (int j = 0; j < data[i].length; j++) {
//                                       if (data[i][j] == null ||
//                                           data[i][j] == '' ||
//                                           data[i][j] == "") {
//                                         // print("enter");
//                                         data[i][j] = " ";
//                                         // print("new value is ${data[i][j]}");
//                                       } else
//                                         row.add(data[i][j]);
//                                     }
//                                     if (!row.isEmpty) excelData.add(row);
//                                   }
//                                   print("excel data is $excelData");
//                                   final headerValues = itemMap.entries
//                                       .expand((entry) => entry.key == 'Number'
//                                           ? entry.value.expand((value) =>
//                                               ['$value start', '$value end'])
//                                           : entry.value.map((value) => value))
//                                       .toList();
//                                   headerValues.insert(0, "Output");
//                                   Map<String, dynamic> excelReqBody = {
//                                     "rangeHierarchyName": rangeHierarchy.text,
//                                     "details": {
//                                       "excelData": excelData,
//                                       "Headers": headerValues
//                                     },
//                                   };
//                                   print(
//                                       "excel body is ${jsonEncode(excelReqBody)}");
//
//                                   ref
//                                       .read(formulaProcedureControllerProvider
//                                           .notifier)
//                                       .addRangeMasterExcel(
//                                           excelReqBody, context);
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: screenWidth * 0.02,
//                                       vertical: screenHeight * 0.005),
//                                   height: screenHeight * 0.05,
//                                   decoration: BoxDecoration(
//                                     color: Colors.green,
//                                     border: Border.all(color: Colors.green),
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: Center(
//                                     child: Text(
//                                       'Done',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             )));
//   }
//
//   // Function to call the JavaScript function and pass header values
//   void _callAddHeaderRow(List<String> headerValues) async {
//     String excelHeaders = jsonEncode(headerValues);
//     print("header values $headerValues");
//     String jsCode = "addCustomHeaderRow('$excelHeaders');";
//     if (webViewController != null) {
//       print("js code is $jsCode");
//       await webViewController!.evaluateJavascript(source: jsCode);
//     }
//   }
// }
