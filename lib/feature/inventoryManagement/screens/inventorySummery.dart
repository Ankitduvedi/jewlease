import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/inventoryManagement/controllers/inventorySummery.dart';

import '../../../main.dart';

class inventorySummery extends ConsumerStatefulWidget {
  @override
  ConsumerState<inventorySummery> createState() => _inventorySummeryState();
}

class _inventorySummeryState extends ConsumerState<inventorySummery> {
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    Map<String, dynamic> summery = ref.watch(inventorySummaryProvider);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStatItem("Total => Rows:", summery["TotalRows"]),
              buildStatItem("Pcs:", summery["Pcs"]),
              buildStatItem("Wt:", summery["Wt"]),
              buildStatItem("Net Wt:", summery["NetWt"]),
              buildStatItem("Dia Pcs", summery["DiaPcs"]),
              buildStatItem("Dia Wt", summery["DiaWt"])
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStatItem("Lg Pcs:", "0"),
              buildStatItem("Lg Wt:", "0.000"),
              buildStatItem("Stn Pcs:", summery["StnPcs"]),
              buildStatItem("Stn Wt:", summery["StnWt"]),
              buildStatItem("Memo Ind", summery["MemoInd"]),
              buildStatItem("Sor Trans Item Id", '2329')
            ],
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildStatItem("Sor Trans Item Bom Id:", "0"),
              buildStatItem("Owner Party Type Id:", "250.00"),
              buildStatItem("Reserve Party Id:", "5792.00"),
              buildStatItem("Dia Pcs:", "630"),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildStatItem(String title, String value) {
    return Container(
      width: 170,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
