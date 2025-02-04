import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jewlease/data/model/transaction_model.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_detail_list_controller.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_history_list_controller.dart';
import 'package:jewlease/feature/transaction/controller/transaction_list_controller.dart';
import 'package:jewlease/main.dart';
import 'package:jewlease/widgets/read_only_textfield_widget.dart';

import '../../../providers/dailog_selection_provider.dart';
import '../../../widgets/search_dailog_widget.dart';

class TransactionDetailsCard extends ConsumerStatefulWidget {
  const TransactionDetailsCard({Key? key}) : super(key: key);

  @override
  ConsumerState<TransactionDetailsCard> createState() =>
      _TransactionDetailsCardState();
}

class _TransactionDetailsCardState
    extends ConsumerState<TransactionDetailsCard> {
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    final textFieldvalues = ref.watch(dialogSelectionProvider);
    final transactionState = ref.watch(transactionProvider);

    int selectedIndex = ref.watch(barcodeIndexProvider);
    var details = ref.watch(barcodeDetailListProvider);
    var history = ref.watch(barcodeHistoryListProvider);
    print(
        "textfield values $textFieldvalues ${textFieldvalues["TransactionId"]}");

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            SizedBox(
                height: screenHeight * 0.05,
                width: screenWidth * 0.2,
                child: ReadOnlyTextFieldWidget(
                  labelText: 'Transaction ID',
                  hintText:
                      textFieldvalues['TransactionId'] ?? 'Transaction ID',
                  icon: Icons.search,
                  onIconPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => ItemTypeDialogScreen(
                        title: 'TransactionId',
                        endUrl: 'Transaction/History',
                        value: 'transId',
                        // keyOfMap: 'Vendor Name',
                        // query: 'Barcode Generation',
                        onSelectdRow: (selectedRow) async {
                          print("selected Row $selectedRow");

                          String transactionID = selectedRow["transId"];
                          TransactionModel transaction =
                              TransactionModel.fromJson(selectedRow);
                          ref
                              .read(transactionProvider.notifier)
                              .saveTransaction(transaction);
                        },
                      ),
                    );
                  },
                )),
            Divider(),
            _buildSection('Trans Id', textFieldvalues['TransactionId'] ?? ''),
            if(transactionState.transaction!=null)
            _buildTransList(transactionState!.transaction)

          ],
        ),
      ),
    );
  }
  
  Widget _buildTransList(TransactionModel? transaction) {
    return Column(
      children: [
        _buildSection(
            'Trans Type', transaction!.transType ?? ''),
        _buildSection('Trans Subtype',
            transaction!.transType ?? ''),
        _buildSection('Trans Category',
            transaction!.transCategory ?? ''),
        _buildSection('Doc No', transaction!.docNo),
        _buildSection(
            'Trans Date',
            DateFormat('d-M-yyyy').format(
                DateTime.parse(transaction!.transDate))),
        Divider(),
        _buildSection('FA Voucher ', 'dannana'),
        _buildSection(
            'Src Location', transaction!.source ?? ""),
        _buildSection('Dest Location',
            transaction!.destination ?? ""),
        _buildSection('Src Department',
            transaction!.sourceDept ?? ""),
        _buildSection('Dest Department',
            transaction!.destinationDept ?? ""),
        _buildSection(
            'Party Name', transaction!.customer),
        _buildSection('Terms', transaction!.term ?? ""),
        _buildSection(
            'Currency', transaction!.currency ?? ""),
        _buildSection('Exchange Rate',
            transaction!.exchangeRate ?? ""),
        _buildSection('Sales Person',
            transaction!.salesPerson ?? ""),
        _buildSection('Posting Date',
    DateFormat('d-M-yyyy').format(DateTime.parse( transaction!.postingDate ?? ""))),
        _buildSection(
            'Remark', transaction!.remark ?? ""),
        Divider(),
        _buildSection(
            'Created Date',
            DateFormat('d-M-yyyy').format(DateTime.parse(
                transaction!.transDate ?? ""))),
        _buildSection(
            'Entry Date',
            DateFormat('d-M-yyyy').format(DateTime.parse(
                transaction!.postingDate ?? ""))),
      ],
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
