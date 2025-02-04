import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/stock_details_model.dart';
import 'package:jewlease/feature/barcoding/controllers/stockController.dart';
import 'package:jewlease/feature/barcoding/controllers/tag_list_controller.dart';

class TagMRP extends ConsumerStatefulWidget {
  @override
  ConsumerState<TagMRP> createState() => _TagMRPState();
}

class _TagMRPState extends ConsumerState<TagMRP> {
  @override
  Widget build(BuildContext context) {
    StockDetailsModel stockDetails = ref.watch(stockDetailsProvider);
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Checkbox and Text
            Row(
              children: [
                Checkbox(
                  value: false,
                  onChanged: (value) {},
                ),
                Text(
                  "Fix MRP",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            // Rates Information
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildRateInfo("Trans Rate: ", "Rs ${stockDetails.rate}"),
                SizedBox(height: 8),
                _buildRateInfo("Rate: ", "Rs ${stockDetails.rate}"),
              ],
            ),
            // Create Tag Button
            ElevatedButton(
              onPressed: () {
                bool oldVal = ref.read(isTagUpdateProvider);
                ref.read(isTagUpdateProvider.notifier).setUpdate(!oldVal); //
                StockDetailsModel stock = ref.read(stockDetailsProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff28713E), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
              child: Text(
                "Create Tag",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateInfo(String title, String value) {
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
