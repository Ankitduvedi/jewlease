import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

import '../../../main.dart';
import '../../../providers/excelProvider.dart';
import '../../../widgets/search_dailog_widget.dart';

class AddFormulaProcedure extends ConsumerStatefulWidget {
  const AddFormulaProcedure({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return AddMetalItemScreenState();
  }
}

class AddMetalItemScreenState extends ConsumerState<AddFormulaProcedure> {
  final TextEditingController procedureTy = TextEditingController();
  final TextEditingController formulaProcdureNa = TextEditingController();
  final TextEditingController calculateOne = TextEditingController();
  final TextEditingController minimumValue = TextEditingController();
  final TextEditingController midRangeTy = TextEditingController();
  final TextEditingController maxValue = TextEditingController();
  final TextEditingController maxRangeTy = TextEditingController();
  final TextEditingController procedureSet = TextEditingController();
  final TextEditingController defaultTerm = TextEditingController();
  final TextEditingController initial = TextEditingController();

  InAppWebViewController? webViewController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    procedureTy.dispose();

    maxValue.dispose();

    calculateOne.dispose();
    minimumValue.dispose();
    midRangeTy.dispose();

    super.dispose();
  }

  final List<String> content = [
    'Parent Form',
    'Item Attribute',
  ];

  Future<void> _uploadData() async {
    await Future.delayed(Duration(seconds: 1)); // Allow time for JS to load
    String temdata = await webViewController?.evaluateJavascript(
      source: "getHandsontableData()",
    );
    print("tem data is $temdata");
    List<dynamic> data = jsonDecode(await webViewController?.evaluateJavascript(
      source: "getHandsontableData()",
    ));
    List<List<dynamic>> newlist = [];
    for (int i = 0; i < data.length; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < data[i].length; j++) {
        print("row $i col is $j ${data[i][j]} datata is-->${data[i][j]}<--}");
        if (data[i][j] == null || data[i][j] == '' || data[i][j] == "") {
          print("enter");
          data[i][j] = " ";
          print("new value is ${data[i][j]}");
        }
        row.add(data[i][j]);
      }
      newlist.add(row);
    }

    ref.read(dataListProvider.notifier).setData(newlist);

    print("data is $newlist");
  }

  final List<List<dynamic>> spreadsheetData = [
    ["Name", "Age", "City"],
    ["Alice", 30, "New York"],
    ["Bob", 25, "Los Angeles"],
    ["Charlie", 28, "Chicago"],
  ];

  void sendApiUpdatedData(dynamic spreadsheetData) {
    print("data is $spreadsheetData");
    final String jsonData2 = jsonEncode(spreadsheetData);
    webViewController?.evaluateJavascript(
      source: "updateHandsontableData('$jsonData2');",
    );
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

  void _handleOpenDialog(int row, int col) {
    String columnName = _getColumnName(col);
    List<String> options = [];

    switch (columnName) {
      case 'C': // Column 'C'
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

  // Function to show a dialog with a list of options
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

  Future<void> _validateFormulas() async {
    if (webViewController == null) return;

    try {
      // Call the validateAllFormulas function in JavaScript
      bool result = await webViewController!
          .evaluateJavascript(source: "validateAllFormulas();");
      // print("result is $result  ");

      // The result is returned as a string, e.g., "true" or "false"
      bool isValid = false;
      // Remove quotes if any
      if (result == true) {
        isValid = true;
      } else if (result == false) {
        isValid = false;
      }

      if (isValid) {
        // All formulas are valid
        _showSnackBar('All formulas are valid.', Color(0xff28713E));
      } else {
        // Some formulas are invalid
        _showSnackBar(
            'Some formulas are invalid. Please review them.', Colors.red);
      }
    } catch (e) {
      print('Error during formula validation: $e');
      _showSnackBar('An error occurred during validation.', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    );

    // Use ScaffoldMessenger to show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showColumnDialog(int rowIndex, int colIndex) {
    String columnName = _getColumnName(colIndex);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Value for Column $columnName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Example options; replace with your actual options
              ListTile(
                title: Text('Option 1'),
                onTap: () {
                  Navigator.of(context).pop();
                  _sendSelectedValueToWebView('Option 1');
                },
              ),
              ListTile(
                title: Text('Option 2'),
                onTap: () {
                  Navigator.of(context).pop();
                  _sendSelectedValueToWebView('Option 2');
                },
              ),
              ListTile(
                title: Text('Option 3'),
                onTap: () {
                  Navigator.of(context).pop();
                  _sendSelectedValueToWebView('Option 3');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally, reset selectedCellCoords
              },
            ),
          ],
        );
      },
    );
  }

  // Helper function to convert column index to column name (e.g., 0 -> A, 1 -> B)
  String _getColumnName(int index) {
    String column = '';
    int temp = index;
    while (temp >= 0) {
      column = String.fromCharCode((temp % 26) + 65) + column;
      temp = (temp ~/ 26) - 1;
    }
    return column;
  }

  // Function to send the selected value back to JavaScript
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

  @override
  Widget build(BuildContext context) {
    final selectedContent = ref.watch(formSequenceProvider);
    final dataList = ref.watch(dataListProvider);

    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);
    int? selectedColumn;
    int? selectedRow;
    int? selectedCol;
    return RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (RawKeyEvent event) {
          if (event.isKeyPressed(LogicalKeyboardKey.altLeft) &&
              event.isKeyPressed(LogicalKeyboardKey.keyO)) {
            print('Alt+O pressed!');
            // _showOptionsDialog(selectedColumn!);
          }
        },
        child: Scaffold(
          persistentFooterButtons: [
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 20),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: const Color.fromARGB(255, 40, 112, 62)),
              child: !ref.watch(itemConfigurationControllerProvider)
                  ? Text(
                      selectedContent == 0 ? 'Next' : 'Save',
                      style: const TextStyle(color: Colors.white),
                    )
                  : const CircularProgressIndicator(
                      color: Colors.white,
                    ),
            ),
          ],
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: const Text('Formula Procdure Details Master'),
            actions: [
              AppBarButtons(
                ontap: [
                  () {},
                  () {},
                  () {
                    // Reset the provider value to null on refresh
                    ref.watch(masterTypeProvider.notifier).state = [
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white, // Background color of the container
                  borderRadius: BorderRadius.circular(12.0), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Shadow color
                      spreadRadius: 1, // How far the shadow spreads
                      blurRadius: 8, // Softens the shadow
                      offset: const Offset(
                          4, 4), // Moves the shadow horizontally and vertically
                    ),
                  ],
                  border: Border.all(
                    color: const Color.fromARGB(
                        255, 219, 219, 219), // Outline (border) color
                    width: 2.0, // Border width
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: parentForm(dataList)),
              ),
              // Expanded(child: ExcelSheet())
              SizedBox(
                height: screenHeight * 0.53,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                      url: WebUri.uri(Uri.file(
                          "C:/Users/ASUS/StudioProjects/jewlease/lib/test.html"))),
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

                          _handleOpenDialog(rowIndex, colIndex);
                        }
                      },
                    );
                  },
                ),
              )
              // Expanded(flex: 1, child: ExcelSheet())
            ]),
          ),
        ));
  }

  Widget parentForm(dynamic datalist) {
    return GridView.count(
      crossAxisCount: 6,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      childAspectRatio: 4.5,
      children: [
        ReadOnlyTextFieldWidget(
          hintText: 'Procedure Type',
          labelText: 'Procedure Type',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        TextFieldWidget(
            labelText: 'FormulaProcedureNa', controller: formulaProcdureNa),
        ReadOnlyTextFieldWidget(
          hintText: 'Calculate One',
          labelText: 'Calculate One',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: 'Minimum Value',
          labelText: 'Minimum Value',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: 'Min Range Ty',
          labelText: 'Min Range Ty',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        NumberTextFieldWidget(
            labelText: 'Minimum Value', controller: minimumValue),
        ReadOnlyTextFieldWidget(
          hintText: 'Maximun Value',
          labelText: 'Maximun Value',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        ReadOnlyTextFieldWidget(
          hintText: 'Max Range Ty',
          labelText: 'Max Range Ty',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
              ),
            );
          },
        ),
        NumberTextFieldWidget(labelText: 'Maximum Value', controller: maxValue),
        // TextFieldWidget(labelText: 'Procedure Set', controller: procedureSet),
        InkWell(
            onTap: () {
              _validateFormulas();
            },
            child: Container(child: Text("Validate"))),
        IconButton(
            onPressed: () {
              _uploadData();
            },
            icon: Text("Save")),
        IconButton(
            onPressed: () {
              // _uploadData();
              sendApiUpdatedData(datalist);
              // _validateFormulas();
            },
            icon: Text("Fetch"))
      ],
    );
  }
}
