import 'package:flutter/material.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';
import 'package:jewlease/widgets/text_field_widget.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../procument/screens/procumenOprGrid.dart';
import '../../procument/screens/procumentBomGrid.dart';
import '../../procument/screens/procumentGridSource.dart';

class BarCodeGeneration extends StatefulWidget {
  const BarCodeGeneration({super.key});

  @override
  State<BarCodeGeneration> createState() => _BarCodeGenerationState();
}

class _BarCodeGenerationState extends State<BarCodeGeneration> {
  @override
  final DataGridController _dataGridController = DataGridController();
  late procumentGridSource _bomDataGridSource;
  late procumentGridSource _oprDataGridSource;
  List<DataGridRow> _bomRows = [];
  List<DataGridRow> _OpeationRows = [];
  //<------------------------- Function To Remove Bom Row ----------- -------------->

  void _removeRow(DataGridRow row) {
    setState(() {
      _bomRows.remove(row);
      _bomDataGridSource.updateDataGridSource();
      _updateBomSummaryRow();
    });
  }

  //<------------------------- Function To Update Bom Summary Row  ----------- -------------->

  void _updateBomSummaryRow() {}

  void showFormula(String val, int index) {}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _bomDataGridSource = procumentGridSource(
        _bomRows, _removeRow, _updateBomSummaryRow, showFormula);
    _oprDataGridSource = procumentGridSource(
        _OpeationRows, _removeRow, _updateBomSummaryRow, showFormula);
  }

  Widget build(BuildContext context) {
    double gridWidth =
        screenWidth * 0.4; // Set grid width to 50% of screen width
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: screenHeight * 0.1),
        child: Column(
          children: [
            CustomUI(),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 1)
                      ]),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        '   Modify Bom',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: screenHeight * 0.32,
                        child: ProcumentBomGrid(
                          bomDataGridSource: _bomDataGridSource,
                          dataGridController: _dataGridController,
                          gridWidth: gridWidth,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 5,
                            spreadRadius: 1)
                      ]),
                  child: ProcumentOperationGrid(
                      operationType: 'Modify operation',
                      gridWidth: gridWidth,
                      dataGridController: _dataGridController,
                      oprDataGridSource: _oprDataGridSource),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomUI extends StatelessWidget {
  const CustomUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 3)
          ]),
      child: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.blue.shade800,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                HeaderItemWidget(title: 'Stock Qty', value: '50'),
                HeaderItemWidget(title: 'Tag Created', value: '0'),
                HeaderItemWidget(title: 'Remaining', value: '0'),
                HeaderItemWidget(title: 'Bal Pcs', value: '50'),
                HeaderItemWidget(title: 'Bal Wt', value: '142.200'),
                HeaderItemWidget(title: 'Bal Met Wt', value: '138.000'),
                HeaderItemWidget(title: 'Bal Stone Pcs', value: '25'),
                HeaderItemWidget(title: 'Bal Stone Wt', value: '21.000'),
                HeaderItemWidget(title: 'Bal Find Pcs', value: '0'),
                HeaderItemWidget(title: 'Bal Find Wt', value: '0.000'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Input Section
          Container(
            // elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: TextFieldWidget(
                        labelText: 'G. Wt *',
                        controller: TextEditingController()),
                    height: 40,
                    width: 120,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: TextFieldWidget(
                        labelText: 'Ply Qty *',
                        controller: TextEditingController()),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: ReadOnlyTextFieldWidget(
                      labelText: 'Size',
                      hintText: '0',
                      icon: Icons.search,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 120,
                    child: TextFieldWidget(
                        labelText: 'Wastage',
                        controller: TextEditingController()),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 150,
                    child: TextFieldWidget(
                        labelText: 'Making Per Gram',
                        controller: TextEditingController()),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 40,
                    width: 220,
                    child: TextFieldWidget(
                        labelText: 'HUID', controller: TextEditingController()),
                  ),
                  const SizedBox(width: 8),
                  CheckboxFieldWidget(label: 'Hallmark'),
                  CheckboxFieldWidget(label: 'Creat New Barcode'),
                  ButtonWidget(
                    text: 'Details',
                    color: Colors.black,
                    icon: Icons.add,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Create Tag',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                SizedBox(width: 8),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderItemWidget extends StatelessWidget {
  final String title;
  final String value;

  const HeaderItemWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class CheckboxFieldWidget extends StatelessWidget {
  final String label;

  const CheckboxFieldWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          activeColor: Colors.green,
          value: true,
          onChanged: (val) {},
          checkColor: Colors.white,
        ),
        Text(label),
      ],
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
