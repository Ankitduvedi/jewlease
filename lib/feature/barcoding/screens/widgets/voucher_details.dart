import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jewlease/data/model/barcode_detail_model.dart';
import 'package:jewlease/data/model/barcode_historyModel.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_detail_controller.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_detail_list_controller.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_history_controller.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_history_list_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';

import '../../../../providers/dailog_selection_provider.dart';
import '../../../../widgets/search_dailog_widget.dart';

class VoucherDetailsScreen extends ConsumerStatefulWidget {
  const VoucherDetailsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VoucherDetailsScreen> createState() =>
      _StockDetailsScreenState();
}

class _StockDetailsScreenState extends ConsumerState<VoucherDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    final textFieldvalues = ref.watch(dialogSelectionProvider);

    int selectedIndex = ref.watch(barcodeIndexProvider);
    var details = ref.watch(barcodeDetailListProvider);
    var history = ref.watch(barcodeHistoryListProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.2,
                child: ReadOnlyTextFieldWidget(
                  labelText: 'Stock ID',
                  hintText: textFieldvalues['Vendor Name'] ?? 'Transaction ID',
                  icon: Icons.search,
                  onIconPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'Choose Stock',
                        endUrl: 'Barcode/Detail',
                        value: 'Stock ID',
                        keyOfMap: 'Vendor Name',
                        // query: 'Barcode Generation',
                        onSelectdRow: (selectedRow) async {
                          print("selected Row $selectedRow");

                          String stockId = selectedRow["Stock ID"];
                          List<BarcodeHistoryModel> historys = await ref
                              .read(BarocdeHistoryControllerProvider.notifier)
                              .fetchBarcodeHistory(stockId);

                          historys.forEach((history) => ref
                              .read(barcodeHistoryListProvider.notifier)
                              .addBarcodeHistory(history));
                          List<BarcodeDetailModel> details = await ref
                              .read(BarocdeDetailControllerProvider.notifier)
                              .fetchBarcodeDetail(stockId);
                          print("details ${details.length}");

                          details.forEach((history) => ref
                              .read(barcodeDetailListProvider.notifier)
                              .addBarcodeDetail(history));
                        },
                      ),
                    );
                  },
                )),
            _buildSection(
                'Barcode Number', history[selectedIndex].stockId ?? ''),
            _buildSection('Stock Code | Group Code',
                history[selectedIndex].stockId ?? ''),
            _buildSection('Quantity', '50'),
            _buildSection('Status', 'Active'),
            Divider(),
            _buildSection('Lying With', 'METAL CONTROL (METAL CONTROL)'),
            _buildSection('Order No', ''),
            _buildSection('Vendor Name', details[selectedIndex].vendor ?? ''),
            _buildSection('Customer', '0'),
            _buildSection('Batch No', ''),
            _buildSection(
                'Stock Variant', details[selectedIndex].varient ?? ''),
            _buildSection('Stack Age', ''),
            _buildSection('Purchase Document',
                history[selectedIndex].transactionNumber.toString() ?? ''),
            _buildSection('Purchase Variant', ''),
            _buildSection('Creation Date', ''),
            _buildSection('HUID', ''),
            _buildSection('CNO', ''),
            _buildSection('Certificate No', ''),
            _buildSection('Remarks', details[selectedIndex].remark ?? ''),
            Divider(),
            _buildSection(
                'Trans Subtype', details[selectedIndex].transType ?? ''),
            _buildSection('Trans Category', 'General'),
            _buildSection(
                'Financial Year',
                DateFormat('d-M-yyyy')
                        .format(DateTime.parse(details[selectedIndex].date)) ??
                    ''),
            _buildSection('Src Location', details[selectedIndex].source ?? ""),
            _buildSection(
                'Dest Location', details[selectedIndex].destination ?? ""),
            _buildSection('Customer', details[selectedIndex].customer ?? ""),
            _buildSection('Vendor Name', details[selectedIndex].vendor),
            _buildSection(
                'Src Department', details[selectedIndex].sourceDept ?? ""),
            _buildSection('Dest Department',
                details[selectedIndex].destinationDept ?? ""),
            _buildSection('Terms', details[selectedIndex].term ?? ""),
            _buildSection('Currency', details[selectedIndex].currency ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontSize: 10,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
