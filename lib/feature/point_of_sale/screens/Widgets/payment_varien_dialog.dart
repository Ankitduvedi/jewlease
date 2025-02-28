import 'package:flutter/material.dart';
import 'package:jewlease/feature/point_of_sale/screens/Widgets/payment_dailog.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';



class PaymentVarientDialog extends StatefulWidget {
  const PaymentVarientDialog({super.key, required this.dataGridSource, required this.transferOutwardColumnns});
  final DataGridSource dataGridSource;
  final List<String> transferOutwardColumnns;

  @override
  State<PaymentVarientDialog> createState() => _PaymentVarientDialogState();
}

class _PaymentVarientDialogState extends State<PaymentVarientDialog> {
  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 600,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'No Wastage & Making For Following Item(s)...',
                  style: TextStyle(color: Colors.red),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, icon: Icon(Icons.close))
              ],
            ),
            SfDataGrid(
              rowHeight: 40,
              headerRowHeight: 40,
              source: widget.dataGridSource,
              controller: DataGridController(),
              footerFrozenColumnsCount: 1,
              // Freeze the last column
              columns: widget.transferOutwardColumnns.map((columnName) {
                return GridColumn(
                  columnName: columnName,
                  width: 200,
                  // Dynamically set column width
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color(0xFF003450),
                      border: Border(
                          right: BorderSide(color: Colors.grey)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      columnName,
                      style: TextStyle(color: Colors.white),
                      maxLines: 1,
                      // Ensure text stays in a single line
                      overflow:
                      TextOverflow.visible, // Prevent clipping
                    ),
                  ),
                );
              }).toList(),
              gridLinesVisibility: GridLinesVisibility.both,
              headerGridLinesVisibility: GridLinesVisibility.none,
            ),
            Row(
              children: [
                Spacer(),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Text("Cancel",style: TextStyle(color: Colors.white),),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: PaymentDialog()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Text("Continue",style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
