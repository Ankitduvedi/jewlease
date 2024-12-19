import 'package:flutter/material.dart';

class StockDetailsScreen extends StatelessWidget {
  const StockDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            TextField(
                onTap: () {
                  // Prevent any interaction with the text field
                },

                //enabled: false,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Barcode Number',
                  labelStyle: const TextStyle(fontSize: 12),
                  hintText: 'DLG70120',
                  hintStyle: const TextStyle(fontSize: 13),

                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.search,
                      size: 17,
                    ),
                    onPressed: () {},
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .always, // Keeps the label always at the top
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                )),
            _buildSection('Barcode Number', 'DLG70120'),
            _buildSection('Stock Code | Group Code', 'DLG70120'),
            _buildSection('Quantity', '50'),
            _buildSection('Status', 'Active'),
            Divider(),
            _buildSection('Lying With', 'METAL CONTROL (METAL CONTROL)'),
            _buildSection('Order No', ''),
            _buildSection(
                'Vendor Name', 'BADRI PRASAD VISHWANATH JEWELS(KBPV)'),
            _buildSection('Customer', '0'),
            _buildSection('Batch No', ''),
            _buildSection('Stock Variant', 'GL-BALI-BAL-ANT-18KT-761'),
            _buildSection('Stack Age', ''),
            _buildSection('Purchase Document', 'HO-FIX-GRN-24-25311'),
            _buildSection('Purchase Variant', ''),
            _buildSection('Creation Date', ''),
            _buildSection('HUID', ''),
            _buildSection('CNO', ''),
            _buildSection('Certificate No', ''),
            _buildSection('Remarks', ''),
            Divider(),
            _buildSection('Trans Subtype', 'GOODS RECEIPT NOTE'),
            _buildSection('Trans Category', 'FIXED - PURCHASE'),
            _buildSection('Financial Year', '24-25'),
            _buildSection('Src Location', 'Head Office'),
            _buildSection('Dest Location', ''),
            _buildSection('Customer', ''),
            _buildSection(
                'Vendor Name', 'BADRI PRASAD VISHWANATH JEWELS(KBPV)'),
            _buildSection('Src Department', ''),
            _buildSection('Dest Department', 'METAL CONTROL'),
            _buildSection('Terms', ''),
            _buildSection('Currency', 'INDIAN RUPEES'),
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
