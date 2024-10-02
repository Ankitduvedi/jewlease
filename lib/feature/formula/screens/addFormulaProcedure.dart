import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';

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
  @override
  void initState() {
    // TODO: implement initState

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
  void _showOptionsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Option 1'),
                  onTap: () {
                    _selectOption('Option 1');
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Option 2'),
                  onTap: () {
                    _selectOption('Option 2');
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('Option 3'),
                  onTap: () {
                    _selectOption('Option 3');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _selectOption(String option) {
    context.pop();
    _updateCellWithOption(option);
  }

  void _updateCellWithOption(String option) {
    webViewController?.evaluateJavascript(source: """
      updateExcelCell('$option');
    """);
  }

  @override
  Widget build(BuildContext context) {
    final selectedContent = ref.watch(formSequenceProvider);
    final isChecked = ref.watch(chechkBoxSelectionProvider);
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final dropDownValue = ref.watch(dropDownProvider);

    return Scaffold(
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
          Container(
            height: screenHeight * 0.53,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri.uri(
                  Uri.file(File(
                          "C:\\Users\\ASUS\\StudioProjects\\jewlease\\lib\\test.html")
                      .absolute
                      .path),
                ),
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                await Future.delayed(Duration(seconds: 1));
                await webViewController?.evaluateJavascript(source: """
            window.userId = '123456';
            console.log('Injected User ID:', window.userId);
          """);
              },
            ),
          )
          // Expanded(flex: 1, child: ExcelSheet())
        ]),
      ),
    );
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
              _showOptionsDialog();
            },
            icon: Icon(Icons.edit))
      ],
    );
  }
}
