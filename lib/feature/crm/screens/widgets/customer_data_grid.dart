import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/routes/go_router.dart';
import 'package:jewlease/data/model/customer_model.dart';
import 'package:jewlease/feature/crm/controller/all_attribute_controller.dart';
import 'package:jewlease/feature/crm/screens/widgets/customer_data_grid_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../main.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class CustomerDataGrid extends ConsumerStatefulWidget {
  const CustomerDataGrid({super.key});

  @override
  ConsumerState<CustomerDataGrid> createState() => _CustomerDataGridState();
}

class _CustomerDataGridState extends ConsumerState<CustomerDataGrid> {
  @override
  List<String> _tabs = [
    'Top Customer',
    'Delivery Pending',
    'Memo Out',
    'Events',
    'All Customers'
  ];
  List<String> LedgerColumnns = [
    'Info',
    'Party Name',
    'Email Id',
    'Mobile No',
    'Purchase Count',
    'Aov Value',
    'Order Count',
  ];
  List<DataGridRow> ledgerRows = [];
  List<CustomerModel>customersList=[];
  late CustomerDataGridSource _procumentdataGridSource;
  final DataGridController InwardDataGridController = DataGridController();

  @override
  double _calculateColumnWidth(String columnName) {
    const double charWidth = 15.0; // Approximate width of a character
    const double paddingWidth = 20.0; // Extra padding for the cell
    return (columnName.length * charWidth) + paddingWidth;
  }

  void selectedIndex(int index) {
    print("selecte $index");
    context.push('/CustomerInfoScreen',extra: customersList[index]);
  }

  @override
  void initState() {
    _procumentdataGridSource = CustomerDataGridSource(
      selectedIndex,
      dataGridRows: ledgerRows,
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Future.microtask(() {
      initializeRows();
    });
  }

  void initializeRows() async {
    List<CustomerModel> customers =
        await ref.read(cRMControllerProvider.notifier).fetchCustomers();
    setState(() {
      ledgerRows = customers
          .map(
            (customer) => DataGridRow(cells: [
              DataGridCell(columnName: 'Info', value: '1'),
              DataGridCell(
                  columnName: 'Party Name',
                  value: '${customer.firstName} ${customer.lastName}'),
              DataGridCell(columnName: 'Email Id', value: customer.emailId),
              DataGridCell(columnName: 'Mobile No', value: customer.mobileNo),
              DataGridCell(columnName: 'Purchase Count', value: '3'),
              DataGridCell(columnName: 'Aov Value', value: '4'),
              DataGridCell(columnName: 'Order Count', value: '5')
            ]),
          )
          .toList();
      customersList = customers;

      _procumentdataGridSource =
          CustomerDataGridSource(selectedIndex, dataGridRows: ledgerRows);
    });
  }

  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.06,
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            decoration: BoxDecoration(
                // color: Colors.white,

                ),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              child: Row(
                children: List.generate(
                  _tabs.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        ref.read(tabIndexProvider.notifier).state = index;
                      },
                      child: Container(
                        color: Colors.transparent,
                        margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.01),
                        padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.005),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.013,
                              vertical: screenHeight * 0.005),
                          decoration: BoxDecoration(
                            color: index == selectedIndex
                                ? Colors.blue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              _tabs[index],
                              style: TextStyle(
                                  color: index == selectedIndex
                                      ? Colors.white
                                      : Colors.blue),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                height: screenHeight * 0.6,

                margin: EdgeInsets.only(top: 10, left: 0),
                // padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // color: Colors.green,
                  // border: Border.all(color: Colors.pink),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      // Shadow color with opacity
                      spreadRadius: 2,
                      blurRadius: 6,
                      offset: Offset(0, 4), // Offset only on the bottom
                    ),
                  ],
                ),
                // height: screenHeight * 0.5,
                width: screenWidth,
                child: Theme(
                  data: ThemeData(
                    cardColor: Colors.transparent,
                    // Background color for DataGrid
                    shadowColor: Colors.transparent, // Removes shadow if any
                  ),
                  child: SfDataGrid(
                    rowHeight: 40,
                    headerRowHeight: 40,
                    source: _procumentdataGridSource,
                    controller: InwardDataGridController,
                    footerFrozenColumnsCount: 1,
                    // Freeze the last column
                    columns: LedgerColumnns.map((columnName) {
                      return GridColumn(
                        columnName: columnName,
                        width: _calculateColumnWidth(columnName),
                        // Dynamically set column width
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Color(0xFF003450),
                            border:
                                Border(right: BorderSide(color: Colors.grey)),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(
                                  LedgerColumnns.indexOf(columnName) ==
                                          LedgerColumnns.length - 1
                                      ? 15
                                      : 0),
                              topLeft: Radius.circular(
                                  LedgerColumnns.indexOf(columnName) == 0
                                      ? 15
                                      : 0),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            columnName,
                            style: TextStyle(color: Colors.white),
                            maxLines: 1,
                            // Ensure text stays in a single line
                            overflow: TextOverflow.visible, // Prevent clipping
                          ),
                        ),
                      );
                    }).toList(),
                    gridLinesVisibility: GridLinesVisibility.both,
                    headerGridLinesVisibility: GridLinesVisibility.none,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
