
import 'package:flutter/material.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/voucher_details.dart';

import 'StockDetailsScreen.dart';

class FinanacialTransaction extends StatefulWidget {
  const FinanacialTransaction({super.key});

  @override
  State<FinanacialTransaction> createState() => _FinanacialTransactionState();
}

class _FinanacialTransactionState extends State<FinanacialTransaction> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: VoucherDetailsScreen()),
        ),

      ],
    );
  }
}
