import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/main.dart';

import '../../../providers/dailog_selection_provider.dart';
import '../../../widgets/read_only_textfield_widget.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../../../widgets/text_field_widget.dart';
import '../controller/heirarchy_controller.dart';
import 'hierarchyDetailsList.dart';

final boolProvider = StateProvider<bool>((ref) => false);

class rangeDialog extends ConsumerStatefulWidget {
  const rangeDialog({super.key});

  @override
  _rangeDialogState createState() => _rangeDialogState();
}

class _rangeDialogState extends ConsumerState<rangeDialog> {
  @override
  TextEditingController rangeHierarchy = TextEditingController();
  TextEditingController rangeType = TextEditingController();
  InAppWebViewController? webViewController;
  bool showExcel = false;

  String _getColumnName(int index) {
    String column = '';
    int temp = index;
    while (temp >= 0) {
      column = String.fromCharCode((temp % 26) + 65) + column;
      temp = (temp ~/ 26) - 1;
    }
    return column;
  }

  void _showOptionsDialog(BuildContext context, String title,
      List<String> options, Function(String) onOptionSelected) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Value of ${excelMap[title]}"),
          content: SizedBox(
            // Adjust height as needed
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                String option = options[index];
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    Navigator.of(context).pop(); // Close the dialog
                    onOptionSelected(option); // Handle the selection
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _handleOpenDialog(int row, int col, Map<String, dynamic> selectedItems,
      Map<String, dynamic> itemValues) {
    String columnName = _getColumnName(col);
    List<String> options = [];
    List<String> headerValues = selectedItems.entries.map((entry) {
      final item = entry.key;
      final isSelected = entry.value;
      final String itemValue = itemValues[item] ?? '';

      return itemValue;
    }).toList();
    print("no is ${columnName.codeUnitAt(0)}");

    switch (headerValues[columnName.codeUnitAt(0) - "A".codeUnitAt(0) + 1]) {
      case "vjhvhjv": // Column 'C'
        options = [
          'Range',
          'Calculation',
          'Amount',
          'Total',
          'Variable',
          'Column'
        ];
        break;
      case 'D':
        options = ['GST TAX', 'HST TAX', 'QST TAX', 'AMOUNT BEFORE TAX'];
      case 'G': // Column 'G'
        options = ['GST TAX', 'HST TAX', 'QST TAX', 'AMOUNT BEFORE TAX'];
        break;
      default:
        // Handle other columns or ignore
        print('No dialog defined for column: $columnName');
        return;
    }

    // Show the dialog with the options
    _showOptionsDialog(context, columnName, options, (selectedOption) {
      // Handle the selected option
      print('Selected option: $selectedOption in column: $columnName');

      // Optionally, send the selected option back to the WebView
      // For example, update the cell with the selected option
      _sendSelectedValueToWebView(selectedOption);
    });
  }

  void _sendSelectedValueToWebView(String value) {
    if (webViewController != null) {
      // Escape the value to prevent JavaScript injection
      String escapedValue = jsonEncode(value);
      webViewController?.evaluateJavascript(
        source: 'updateCellWithDialogValue($escapedValue);',
      );
    } else {
      print('WebView controller is null.');
    }
  }

  Map<String, String> excelMap = {
    "B": 'Description',
    "C": "Data Type",
    "D": "Variable Name",
    "E": "Range Value",
    "F": "Formula",
    "G": "Row Type",
    "H": "Round Off",
    "I": "Account Name",
    "J": "Editable",
    "I": "Visible",
  };

  @override
  Widget build(BuildContext context) {
    final selectedItems = ref.watch(selectedItemProvider);
    final itemValues = ref.watch(itemValueProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    bool isToggled = ref.watch(boolProvider);
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
                                hintText: 'Item',
                                labelText: 'Range Type',
                                icon: Icons.search,
                                onIconPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                        const ItemTypeDialogScreen(
                                      title: 'Attribute Type',
                                      endUrl: 'AllAttribute/AttributeType',
                                      value: 'ConfigValue',
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
                                    builder: (context) => ItemTypeDialogScreen(
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
                                final currentVal =
                                    ref.read(valueProvider.notifier).getValue();
                                print(
                                    "cuurent item is $currentItem and value is $currentVal");
                                ref.read(addItemProvider)(
                                    currentItem, false, currentVal);

                                String jsCode = """
      addCustomHeaderRow("$currentVal");
    """;
                                if (webViewController != null) {
                                  await webViewController!
                                      .evaluateJavascript(source: jsCode);
                                }
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
                                ref.read(boolProvider.notifier).state =
                                    !isToggled;

                                Future.delayed(Duration(seconds: 7), () {
                                  List<String> headerValues =
                                      selectedItems.entries.map((entry) {
                                    final item = entry.key;
                                    final isSelected = entry.value;
                                    final String itemValue =
                                        itemValues[item] ?? '';

                                    return itemValue;
                                  }).toList();
                                  print("header values is $headerValues");
                                  headerValues.insert(0, "Output");
                                  _callAddHeaderRow(headerValues);
                                });
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
                                    'Create excel',
                                    style: TextStyle(color: Colors.white),
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
                            child: SizedBox(
                              height: screenHeight * 0.53,
                              child: ref.read(boolProvider) == false
                                  ? HierarchyDetailsList()
                                  : InAppWebView(
                                      initialUrlRequest: URLRequest(
                                          url: WebUri.uri(Uri.file(
                                              "D:\flutter projectjewleaselib\range.html"))),
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

                                              _handleOpenDialog(
                                                  rowIndex,
                                                  colIndex,
                                                  selectedItems,
                                                  itemValues);
                                            }
                                          },
                                        );
                                      }),
                            )),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.005),
                              height: screenHeight * 0.05,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(child: Text('Add Another')),
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
                                color: Colors.green,
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  'Done',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  // Function to call the JavaScript function and pass header values
  void _callAddHeaderRow(List<String> headerValues) async {
    String jsCode = """
    addCustomHeaderRow(${headerValues.map((e) => '"$e"').toList()});
  """;
    if (webViewController != null) {
      await webViewController!.evaluateJavascript(source: jsCode);
    }
  }
}
