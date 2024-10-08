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
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    _focusNode.requestFocus();
    super.initState();
  }

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
    final data = await webViewController?.evaluateJavascript(
      source: "getHandsontableData()",
    );

    print("data is $data");
  }

  final List<List<dynamic>> spreadsheetData = [
    ["Name", "Age", "City"],
    ["Alice", 30, "New York"],
    ["Bob", 25, "Los Angeles"],
    ["Charlie", 28, "Chicago"],
  ];

  void sendApiUpdatedData(String newJsonData) {
    final String jsonData2 = jsonEncode(spreadsheetData);
    webViewController?.evaluateJavascript(
      source: "updateHandsontableData('$jsonData2');",
    );
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
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);
    int? selectedColumn;
    int? _selectedRow;
    int? _selectedCol;
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
                    padding: const EdgeInsets.all(8.0), child: parentForm()),
              ),
              // Expanded(child: ExcelSheet())
              Container(
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
                          _showColumnDialog(rowIndex, colIndex);
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

  Widget parentForm() {
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
        TextFieldWidget(labelText: 'Procedure Set', controller: procedureSet),
        IconButton(
            onPressed: () {
              // _uploadData();
              sendApiUpdatedData('');
            },
            icon: Icon(Icons.edit))
      ],
    );
  }
}
