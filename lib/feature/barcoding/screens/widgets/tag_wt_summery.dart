import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/barcoding/screens/widgets/tag_image_uploader.dart';

import '../../controllers/stockController.dart';
import '../../controllers/tag_image_controller.dart';

class TagWtSummery extends ConsumerStatefulWidget {
  @override
  ConsumerState<TagWtSummery> createState() => _TagWtSummeryState();
}

class _TagWtSummeryState extends ConsumerState<TagWtSummery> {
  @override
  Widget build(BuildContext context) {
    File? imgFile = ref.watch(tagImgListProvider);
    final stockDetails = ref.watch(stockDetailsProvider);
    return Container(
      padding: EdgeInsets.all(8.0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Edit Icon
          Stack(
            children: [
              if (imgFile != null)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(imgFile),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    Icons.image,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              Positioned(
                bottom: 4,
                right: 4,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Color(0xff28713E),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => TagImageDialog(),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 32),
          // Weights Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeightInfo(
                        "Gross Wt", stockDetails.currentWt.toString()),
                    _buildWeightInfo(
                        "Net Wt", stockDetails.currentWt.toString()),
                    _buildWeightInfo(
                        "Dia Wt", stockDetails.balStoneWt.toString()),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildWeightInfo("Other Wt", "0.200"),
                    _buildWeightInfo("Tag Wt", "0.00"),
                    _buildWeightInfo("Poly Wt", "0.00"),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 32),
        ],
      ),
    );
  }

  Widget _buildWeightInfo(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.blueGrey,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
