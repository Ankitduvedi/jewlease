import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/inventoryItem.dart';
import 'package:jewlease/feature/inventoryManagement/screens/inventorySummery.dart';
import 'package:jewlease/feature/rm_inventory_management/controllers/rm_inventory_controller.dart';
import 'package:jewlease/feature/rm_inventory_management/screens/rm_inventory_dataSource.dart';
import 'package:jewlease/main.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/model/rm_inventory_model.dart';
import '../../inventoryManagement/controllers/inventorySummery.dart';
import '../../inventoryManagement/screens/inventoryDataSource.dart';
import '../../inventoryManagement/screens/inventoryTopHeader.dart';

class RmInventoryManagementScreen extends ConsumerStatefulWidget {
  const RmInventoryManagementScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _RmInventoryManagementScreenState();
  }
}

class _RmInventoryManagementScreenState
    extends ConsumerState<RmInventoryManagementScreen> {
  @override
  void initState() {
    // TODO: implement initState

    addInventoryItem();

    super.initState();
  }

  @override
  List<String> leftPane = [
    'Category details',
    'QC Status',
    'Barcode/ Non barcoded',
    'Top 20 Vendor wise Stock',
    'Top 20 Vendor Customer wise Stock',
    'Reserved Stock',
    'Location Wise Stock',
    'Department Wise Stock'
  ];
  List<String> gridColumnNameInventory = [
    'More',
    'ItemGroup',
    'VariantName',
    'OldVariantName',
    'StockCode',
    'GroupCode',
    'QCStatus',
    'BatchNo',
    'StoneShape',
    'StoneRange',
    'StoneColor',
    'StoneCut',
    'MetalKarat',
    'MetalColor',
    'LOB',
    'Category',
    'SubCategory',
    'StyleCollection',
    'ProjectSizeMaster',
    'StyleMetalKarat',
    'StyleMetalColor',
    'Brand',
    'ProductSizeStock',
    'TablePer',
    'BrandStock',
    'VendorCode',
    'Vendor',
    'Customer',
    'Piece',
    'Weight',
    'NetWeight',
    'DiaPieces',
    'DiaWeight',
    'LgPiece',
    'LgWeight',
    'StonePiece',
    'StoneWeight',
    'SellingLabour',
    'OrderNo',
    'KaratColor',
    'ImageFileName',
    'InwardDocLastTrans',
    'ReserveInd',
    'BarcodeInd',
    'TransitLocationCode',
    'LocationName',
    'WCGroupName',
    'CustomerJobworker',
    'Halimarking',
    'CertificateNo',
    'StockAge',
    'MemoInd',
    'BarcodeDate',
    'SORTransItemId',
    'SORTransItemBomId',
    'OwnerPartyTypeId',
    'ReservePartyId',
    'LineNo',
    'OrderPartName',
    'InwardEllapsDays',
    'OrderEllapsDays',
  ];

  ScrollController _scrollController = ScrollController();
  List<RmInventoryItemModel> inventoryItems = [];

  void addInventoryItem() async {
    Future.delayed(Duration(seconds: 1), () async {
      // await ref.read(RmInventoryControllerProvider.notifier).fetchAllStocks();
      List<RmInventoryItemModel> allStocks =
          ref.read(RmInventoryControllerProvider.notifier).RmInventoryItems;

      print("len allstocks ${allStocks.length}");
      inventoryItems.addAll(allStocks);
      ref.read(inventorySummaryProvider.notifier).updateAll({
        "TotalRows": allStocks.length.toString(),
        "Pcs": allStocks.fold(0.0, (sum, item) => sum + item.pieces).toString(),
        "Wt": allStocks
            .fold(0.0, (sum, item) => sum + item.metalWeight)
            .toString(),
        "NetWt": (allStocks.fold(0.0, (sum, item) => sum + item.metalWeight) +
                allStocks.fold(0.0, (sum, item) => sum + item.diaWeight))
            .toString(),
        "DiaPcs":
            allStocks.fold(0.0, (sum, item) => sum + item.diaPieces).toString(),
        "DiaWt":
            allStocks.fold(0.0, (sum, item) => sum + item.diaWeight).toString(),
        "LgPcs": "30",
        "LgWt": "15",
        "StnPcs":
            allStocks.fold(0.0, (sum, item) => sum + item.diaPieces).toString(),
        "StnWt":
            allStocks.fold(0.0, (sum, item) => sum + item.diaWeight).toString(),
        "MemoInd": "1",
        "SorTransItemId": "123",
        "SorTransItemBomId": "456",
        "OwnerPartyTypeId": "789",
        "ReservePartyId": "999",
        "DiaPcs2": "60",
      });
      setState(() {});
    });
  }

  void updateSelectedIndex(int index) {
    ref.read(RmInventoryControllerProvider.notifier).setCurrentIndex(index);
  }

  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool showGraph = ref.watch(showGraphProvider);
    return Scaffold(
      body: Container(
        color: Colors.grey.shade200,
        child: Row(
          children: [
            if (showGraph)
              Expanded(
                flex: 1,
                child: Container(
                  child: Scrollbar(
                    controller: _scrollController,
                    scrollbarOrientation: ScrollbarOrientation.right,
                    thickness: 5,
                    trackVisibility: true,
                    thumbVisibility: true,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: false),
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: 8,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 200,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    leftPane[index],
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              })),
                    ),
                    interactive: true,
                  ),
                ),
              ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      height: screenHeight * 0.4,
                      margin: EdgeInsets.only(top: 80, right: 10),
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
                          SizedBox(height: 50, child: inventoryTopHeader()),
                          Expanded(
                            child: SfDataGrid(
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.none,
                              source: RmInventoryDataSource(
                                context,
                                updateSelectedIndex,
                                inventoryItems,
                              ),
                              columns: List.generate(
                                  gridColumnNameInventory.length, (index) {
                                return GridColumn(
                                  columnName: gridColumnNameInventory[index],
                                  label: _buildHeaderCell(
                                      gridColumnNameInventory[index], index),
                                );
                              }),
                              rowHeight: 30,
                              headerRowHeight: 40,
                              frozenColumnsCount: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(flex: 1, child: inventorySummery()),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(index == 0 ? 8.0 : 0.0),
          topRight: Radius.circular(
              index == gridColumnNameInventory.length - 1 ? 8.0 : 0.0),
        ),
        border: Border.all(
          color: Colors.grey,
          width: 0.5,
        ),
        color: Color(0xFF003450),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          overflow: TextOverflow.ellipsis,
          fontSize: 10,
        ),
      ),
    );
  }
}
