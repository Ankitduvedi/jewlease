import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

class ExcelSheet extends StatefulWidget {
  @override
  _ExcelSheetState createState() => _ExcelSheetState();
}

class _ExcelSheetState extends State<ExcelSheet> {
  // 2D list to store the content of the cells (100 rows and 26 columns, A to Z)
  List<List<String>> cellValues =
      List.generate(100, (_) => List.generate(26, (_) => ""));

  List<List<TextEditingController>> cellControllers = List.generate(
    100,
    (row) => List.generate(26, (col) => TextEditingController()),
  );

  List<String> columnHeaders =
      List.generate(26, (index) => String.fromCharCode(65 + index));

  List<String> rowHeaders =
      List.generate(100, (index) => (index + 1).toString());

  void evaluateFormula(int row, int col) {
    String input = cellControllers[row][col].text;

    if (input.startsWith('=')) {
      String formula = input.substring(1);

      formula = formula.toUpperCase();

      try {
        Expression expression = Expression.parse(formula);

        final evaluator = const ExpressionEvaluator();
        final context = <String, dynamic>{};

        // Populate the context with cell values
        for (int i = 0; i < 100; i++) {
          for (int j = 0; j < 26; j++) {
            String cellRef =
                '${String.fromCharCode(65 + j)}${(i + 1).toString()}';
            double cellValue =
                double.tryParse(cellControllers[i][j].text) ?? 0.0;
            context[cellRef] = cellValue;
          }
        }

        var result = evaluator.eval(expression, context);

        setState(() {
          cellControllers[row][col].text = result.toString();
        });
      } catch (e) {
        print('Invalid formula: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Column headers (A to Z)
              Row(
                children: [
                  Container(
                      width: 50,
                      height: 20,
                      color: Color(0xfff1f1f1) // Light green color
                      ), // Empty top-left corner
                  ...columnHeaders.map((colHeader) => Container(
                        width: 100,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xfff1f1f1),
                            border: Border.all(color: Color(0xffe4e4e4))),
                        child: Text(
                          colHeader,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Color(0xff4c4c4c)),
                        ),
                      )),
                ],
              ),

              ...List.generate(100, (rowIndex) {
                return Row(
                  children: [
                    // Row headers (1 to 100)
                    Container(
                      width: 50,
                      height: 20,
                      // Light green color
                      decoration: BoxDecoration(
                          color: Color(0xfff1f1f1),
                          border: Border.all(color: Color(0xffe4e4e4))),
                      alignment: Alignment.center,
                      child: Text(
                        rowHeaders[rowIndex],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xff4c4c4c)),
                      ),
                    ),
                    // Input cells
                    ...List.generate(26, (colIndex) {
                      return Container(
                        width: 100,
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffe4e4e4)),
                            color: Colors.white // Light green color for cells
                            ),
                        child: TextField(
                          controller: cellControllers[rowIndex][colIndex],
                          decoration: InputDecoration(
                            border: InputBorder.none, // No extra borders
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          onSubmitted: (value) {
                            evaluateFormula(rowIndex, colIndex);
                          },
                        ),
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
