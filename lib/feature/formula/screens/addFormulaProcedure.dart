import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/formula_model.dart';
import 'package:jewlease/feature/item_configuration/controller/item_configuration_controller.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';
import 'package:jewlease/providers/dailog_selection_provider.dart';
import 'package:jewlease/widgets/app_bar_buttons.dart';
import 'package:jewlease/widgets/number_input_text_field.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../main.dart';
import '../../../providers/excelProvider.dart';
import '../../../widgets/search_dailog_widget.dart';
import '../controller/formula_prtocedure_controller.dart';
import 'addFormulaGridSource.dart';

class AddFormulaProcedure extends ConsumerStatefulWidget {
  const AddFormulaProcedure({
    super.key,
    required this.FormulaProcedureName,
    required this.ProcedureType,
  });

  final String FormulaProcedureName;
  final String ProcedureType;

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
  List<String> transferOutwardColumns = [
    'Row',
    'Description',
    'Data Type',
    'Row Type',
    'Formula',
    'Range Value',
    'Editable',
    'Visible',
    'Round Off',
    'Account Name'
  ];

  List<DataGridRow> outwardRows = [];
  late AddFormulaDataGridSource _procumentDataGridSource;
  final DataGridController outwardDataGridController = DataGridController();
  bool _isLoading = true;

  @override
  void initState() {
    _procumentDataGridSource = AddFormulaDataGridSource(
        outwardRows, (_) {}, () {}, false, _handleOpenDialog);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() async {
      await initializeRows();
    });
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

  void addNewRow() {
    outwardRows.add(DataGridRow(cells: [
      DataGridCell<String>(
          columnName: 'Row', value: (outwardRows.length + 1).toString()),
      DataGridCell<String>(columnName: 'Description', value: ''),
      DataGridCell<String>(columnName: 'Data Type', value: ''),
      DataGridCell<String>(columnName: 'Row Type', value: ''),
      DataGridCell<String>(columnName: 'Formula', value: ''),
      DataGridCell<String>(columnName: 'Range Value', value: ''),
      DataGridCell<String>(columnName: 'Editable', value: '0'),
      DataGridCell<String>(columnName: 'Visible', value: '1'),
      DataGridCell<String>(columnName: 'Round Off', value: ''),
      DataGridCell<String>(columnName: 'Account Name', value: ''),
    ]));
    setState(() {
      _procumentDataGridSource = AddFormulaDataGridSource(
          outwardRows, (_) {}, () {}, false, _handleOpenDialog);
    });
  }

  //<-----------------------Fetching intial formula if exist----------------------->
  Future<void> initializeRows() async {
    if (widget.FormulaProcedureName.isEmpty) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      List<List<dynamic>> excelData = await fetchApiUpdatedData();

      setState(() {
        outwardRows = excelData
            .map((row) => DataGridRow(cells: [
                  DataGridCell<String>(
                      columnName: 'Row', value: row[0]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Description',
                      value: row[1]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Data Type', value: row[2]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Row Type', value: row[3]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Formula', value: row[4]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Range Value',
                      value: row[5]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Editable', value: row[6]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Visible', value: row[7]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Round Off', value: row[7]?.toString() ?? ''),
                  DataGridCell<String>(
                      columnName: 'Account Name',
                      value: row[7]?.toString() ?? ''),
                ]))
            .toList();

        _procumentDataGridSource = AddFormulaDataGridSource(
            outwardRows, (_) {}, () {}, false, _handleOpenDialog);
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

//<-------------------------Fetching formula from  api-------------------------->
  Future<List<List<dynamic>>> fetchApiUpdatedData() async {
    if (widget.FormulaProcedureName.isEmpty) return [];

    Map<String, dynamic> data = await ref
        .read(formulaProcedureControllerProvider.notifier)
        .fetchFormulaExcel(widget.FormulaProcedureName, context);

    List<dynamic> tempList = data["Excel Detail"]["data"] ?? [];

    return tempList.map((row) => List<dynamic>.from(row)).toList();
  }

  final List<String> content = [
    'Parent Form',
    'Item Attribute',
  ];

  //<-------------------------Save Formula------------------------------------>
  Future<void> _uploadData() async {
    await Future.delayed(
        const Duration(seconds: 1)); // Allow time for JS to load
    List<DataGridRow> datagridRows = outwardRows;
    List<FormulaRowModel> newlist = [];

    int lastEditedRow = -1;
    int lastEditedColumn = -1;

    // Find the bounds of the edited area
    for (int row = 0; row < datagridRows.length; row++) {
      for (int col = 0; col < datagridRows[row].getCells().length; col++) {
        if (!(datagridRows[row].getCells()[col] == null ||
            datagridRows[row].getCells()[col] == '' ||
            datagridRows[row].getCells()[col] == "")) {
          lastEditedRow = row > lastEditedRow ? row : lastEditedRow;
          lastEditedColumn = col > lastEditedColumn ? col : lastEditedColumn;
        }
      }
    }
    print("last edited row $lastEditedRow $lastEditedColumn");

    for (int i = 0; i < lastEditedRow + 1; i++) {
      List<dynamic> row = [];
      for (int j = 0; j < lastEditedColumn + 1; j++) {
        row.add(datagridRows[i].getCells()[j].value ?? "");
      }
      print("4 ${row[4]}");
      FormulaRowModel newRow = FormulaRowModel(
          editableInd: int.parse(row[6]),
          hideDefaultValueInd: int.parse(row[7]),
          attribTypeAndAttribId: 0,
          maxRateValue: 0,
          minRateValue: 0,
          mrpInd: 0,
          rangeDtl: null,
          rowDescription: row[1],
          rowExpression: row[4],
          rowExpressionId: i,
          rowExpressionValue: "0",
          rowNo: i,
          rowStatus: row[7],
          rowType: row[1],
          rowValue: 0,
          validateExpression: "",
          variantId: 0,
          visibleInd: int.parse(row[7]),
          rateAsPerFormula: 0,
          id: i,
          dataType: row[2]);
      if (row.length != 0) {
        newlist.add(newRow);
      }
    }

    Map<String, dynamic> excelReqBody = {
      "procedureType": procedureTy.text,
      "formulaProcedureName": formulaProcdureNa.text,
      "calculateOn": calculateOne.text,
      "minimumValueBasedOn": minimumValue.text,
      "minRangeType": minimumValue.text,
      "maximumValueBasedOn": maxValue.text,
      "maxRangeType": maxRangeTy.text,
      "excelDetail": newlist.map((formula) => formula.toJson()).toList()
    };
    // Utils.printJsonFormat(excelReqBody);

    ref
        .read(formulaProcedureControllerProvider.notifier)
        .addFormulaExcel(excelReqBody, context);

  }

  Map<String, String> excelMap = {
    "A": "Row",
    "B": 'Description',
    "C": "Data Type",
    "D": "Row Type",
    "E": "Formula",
    "F": "Range Value",
    "G": "Editable",
    "H": "Visible",
    "I": "Round Off",
    "J": "Account Name",
  };

  void _handleOpenDialog(int row, int col) {
    String columnName = _getColumnName(col);
    List<String> options = [];

    // Show the dialog with the options
    if (row != -1)
      _showOptionsDialog(context, columnName, options, (selectedOption) {
        setState(() {
          outwardRows[row] = DataGridRow(
              cells: outwardRows[row].getCells().map((cell) {
            if (cell.columnName != outwardRows[row].getCells()[col].columnName)
              return cell;
            else
              return DataGridCell(
                  columnName: outwardRows[row].getCells()[col].columnName,
                  value: selectedOption);
          }).toList());
        });
      });
  }

  // Function to show a dialog with a list of options
  void _showOptionsDialog(BuildContext context, String title,
      List<String> options, Function(String) onOptionSelected) {
    showDialog(
      context: context,
      builder: (context) => ItemTypeDialogScreen(
        title: 'Range Type',
        endUrl: 'FormulaProcedures/RateStructure/FormulaRangeMaster',
        value: 'Config Id',
        onOptionSelectd: (selectedValue) {
          onOptionSelected(selectedValue);
        },
      ),
    );
  }

  //<--------------------------Validity of All Formula-------------------------->
  Future<void> _validateFormulas() async {
    if (outwardRows.length == 0) return;

    try {
      // Call the validateAllFormulas function in JavaScript
      bool result = testFormulaValidity(outwardRows);
      // print("result is $result  ");

      // The result is returned as a string, e.g., "true" or "false"
      bool isValid = false;
      // Remove quotes if any
      if (result == true) {
        isValid = true;
      }

      if (isValid) {
        // All formulas are valid
        _showSnackBar('All formulas are valid.', const Color(0xff28713E));
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

  //<--------------------------Validity of Single Formula-------------------------->
  bool testFormulaValidity(List<DataGridRow> rows) {
    bool allValid = true;

    for (var row in rows) {
      String formula = row
              .getCells()
              .firstWhere((cell) => cell.columnName == 'Formula')
              .value ??
          '';

      if (!isFormulaValid(formula)) {
        allValid = false;
        // Apply error style
        // errorRows.add(row);
      }
    }

    // Ensure the last edited row contains "total"

    bool containsTotal = rows[rows.length - 1].getCells().any((cell) =>
        (cell.value as String?)?.toLowerCase().contains('total') ?? false);

    if (!containsTotal) {
      allValid = false;
    }

    return allValid;
  }

  //<--------------------------Formula Validation REgx-------------------------->
  bool isFormulaValid(String formula) {
    if (formula.isEmpty) return true;

    try {
      // Replace r1, r2, etc., with dummy values
      String expression = formula.replaceAll(RegExp(r'r\d+'), '1');

      // Check for invalid sequences like ++ or -- or */
      if (RegExp(r'[+\-*/]{2,}').hasMatch(expression)) return false;

      // Check for invalid start/end operators
      if (RegExp(r'^[+\-*/]|[+\-*/]$').hasMatch(expression)) return false;

      // Evaluate using Dart's math parser
      final parsed = double.parse(expression); // Dummy parse check
      return true;
    } catch (e) {
      return false;
    }
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    );

    // Use ScaffoldMessenger to show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                padding: const EdgeInsets.all(8.0),
                child: parentForm(dataList)),
          ),
          // Expanded(child: ExcelSheet())
          SizedBox(
              height: screenHeight * 0.53,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: screenHeight * 0.6,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  width: screenWidth,
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Theme(
                          data: ThemeData(
                            cardColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: SfDataGrid(
                            rowHeight: 40,
                            headerRowHeight: 40,
                            source: _procumentDataGridSource,
                            controller: outwardDataGridController,
                            footerFrozenColumnsCount: 1,
                            columns: transferOutwardColumns.map((columnName) {
                              return GridColumn(
                                columnName: columnName,
                                width: _calculateColumnWidth(columnName),
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF003450),
                                    border: Border(
                                        right: BorderSide(color: Colors.grey)),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                          transferOutwardColumns
                                                      .indexOf(columnName) ==
                                                  transferOutwardColumns
                                                          .length -
                                                      1
                                              ? 15
                                              : 0),
                                      topLeft: Radius.circular(
                                          transferOutwardColumns
                                                      .indexOf(columnName) ==
                                                  0
                                              ? 15
                                              : 0),
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    columnName,
                                    style: TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              );
                            }).toList(),
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.none,
                          ),
                        ),
                ),
              ))
          // Expanded(flex: 1, child: ExcelSheet())
        ]),
      ),
    );
  }

  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0;
    const double paddingWidth = 20.0;
    return (columnName.length * charWidth) + paddingWidth;
  }

  Widget parentForm(dynamic datalist) {
    return GridView.count(
      crossAxisCount: 6,
      crossAxisSpacing: 10,
      mainAxisSpacing: 20,
      childAspectRatio: 4.5,
      children: [
        ReadOnlyTextFieldWidget(
          hintText:
              procedureTy.text == '' ? 'Procedure Type' : procedureTy.text,
          labelText: 'Procedure Type',
          icon: Icons.search,
          onIconPressed: () {
            showDialog(
              context: context,
              builder: (context) => ItemTypeDialogScreen(
                title: 'Attribute Type',
                endUrl: 'AllAttribute/AttributeType',
                value: 'ConfigValue',
                onOptionSelectd: (selectedOption) {
                  setState(() {
                    procedureTy.text = selectedOption;
                  });
                  print("selectedOption is $selectedOption");
                },
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
              addNewRow();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff003450),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                    child: Text(
                  "Add Row",
                  style: TextStyle(color: Colors.white),
                )))),
        InkWell(
            onTap: () {
              _validateFormulas();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff003450),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                    child: Text(
                  "Validate",
                  style: TextStyle(color: Colors.white),
                )))),
        InkWell(
            onTap: () {
              _uploadData();
            },
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff003450),
                    borderRadius: BorderRadius.circular(8)),
                child: const Center(
                    child: Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                )))),
      ],
    );
  }
}
