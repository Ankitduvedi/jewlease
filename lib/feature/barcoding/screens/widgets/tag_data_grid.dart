import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/inventoryItem.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../controllers/tag_list_controller.dart';
import '../tag_dataSource.dart';

class TagListUI extends ConsumerStatefulWidget {
  @override
  ConsumerState<TagListUI> createState() => _TagListUIState();
}

class _TagListUIState extends ConsumerState<TagListUI> {
  final List<TagRow> tagRows = [];

  final List<String> gridColumnNames = [
    'checkbox',
    'Image',
    'Variant',
    'StockCode',
    'Pcs',
    'Wt',
    'Net Wt',
    'Cls Wt',
    'Dia Wt',
    'Stone Amt',
    'Metal Amt',
    'Wstg',
    'Fix MRP',
    'Making',
    'Rate',
    'Amount',
    'Line Remark',
    'HUID',
    'Order Variant',
  ];

  Map<String, dynamic> convertToSchema(
      TagRow tag, InventoryItemModel stock, String image) {
    return {};
  }

  InventoryItemModel updateCurrentInveryItem(
      InventoryItemModel item, TagRow tag, String imageFile) {
    item.Pieces = item.Pieces - 1;

    item.metalWeight = item.metalWeight - tag.wt;
    item.diaWeight = item.diaWeight - tag.diaWt;
    item.diaPieces = max(item.diaPieces - tag.pcs, 0);
    item.imageFileName = imageFile;
    item.netWeight = item.netWeight - tag.netWt;
    item.stonePiece = item.stonePiece - tag.pcs;
    return item;
  }

  void addTagRow() async {
    print("adding row");
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(isTagUpdateProvider, (previous, next) {
      // Trigger your function here
      addTagRow();
    });
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // SfDataGrid
            Expanded(
              child: SfDataGrid(
                source: TagDataSource(tagRows),
                columns: gridColumnNames
                    .map((column) => GridColumn(
                          columnName: column.toLowerCase(),
                          label: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                      column == 'checkbox' ? 8.0 : 0.0),
                                  topRight: Radius.circular(
                                      column == 'Order Variant' ? 8.0 : 0.0),
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                                color: Color(0xff28713E)),
                            child: Text(
                              column,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ))
                    .toList(),
                headerRowHeight: 25,
                rowHeight: 35,
                gridLinesVisibility: GridLinesVisibility.horizontal,
                headerGridLinesVisibility: GridLinesVisibility.horizontal,
                // columnWidthMode: ColumnWidthMode.fill,
              ),
            ),
            // Message Below the Grid
            if (tagRows.length == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tag, color: Colors.green),
                    SizedBox(width: 8),
                    Text(
                      "Your created tags would be listed here",
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
