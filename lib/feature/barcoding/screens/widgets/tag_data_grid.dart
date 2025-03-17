import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/barcode_detail_model.dart';
import 'package:jewlease/data/model/inventoryItem.dart';
import 'package:jewlease/data/model/stock_details_model.dart';
import 'package:jewlease/data/model/transaction_model.dart';
import 'package:jewlease/feature/barcoding/controllers/barcode_detail_controller.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/utils/utils.dart';
import '../../../../data/model/barcode_historyModel.dart';
import '../../../../providers/image_provider.dart';
import '../../../../widgets/image_data.dart';
import '../../../inventoryManagement/controllers/inventoryController.dart';
import '../../../procument/controller/procumentcController.dart';
import '../../../transaction/controller/transaction_controller.dart';
import '../../controllers/barcode_history_controller.dart';
import '../../controllers/stockController.dart';
import '../../controllers/tag_image_controller.dart';
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

  StockDetailsModel updateStock(StockDetailsModel newStockDetails) {
    newStockDetails.rate = 0;
    newStockDetails.balMetWt = newStockDetails.balMetWt -
        (newStockDetails.currentNetWt - newStockDetails.currentStoneWt);
    newStockDetails.balStoneWt =
        newStockDetails.balStoneWt - newStockDetails.currentStoneWt;
    newStockDetails.balWt = newStockDetails.balWt - newStockDetails.currentWt;
    newStockDetails.stockQty--;
    newStockDetails.tagCreated++;
    newStockDetails.remaining--;
    newStockDetails.currentNetWt=0;
    newStockDetails.currentStoneWt=0;
    newStockDetails.currentWt=0;
    return newStockDetails;
  }

  void addTagRow() async {
    print("adding row");
    InventoryItemModel currentTotalStock =
        ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;
    print("current item ${currentTotalStock.varientName}");
    try {
      StockDetailsModel newChildStockDetails = ref.read(stockDetailsProvider);
      File? imgFile = ref.read(tagImgListProvider);
      // return ;
      TagRow tag = createTag(newChildStockDetails, currentTotalStock, imgFile);
      final response = await ref.watch(imageProvider.notifier).uploadImage(
          ImageModel(
              imageData: tag.image!.readAsBytesSync(),
              type: 'Tag',
              description: tag.stockCode));
      String imageUrl = "";
      response.fold((l) => Utils.snackBar(l.message, context), (r) {
        print("image url1 is $r");
        setState(() {
          imageUrl = r;
        });
      });
      tagRows.add(tag);
      Map<String, dynamic> tagrRqsBody =
          convertToSchema(tag, currentTotalStock, "xyz");
      print("tagrRqsBody is $tagrRqsBody");
      tagrRqsBody.remove("Stock ID");

      //<---------------api to create a new tag---------------->
      String newTagStockCode = await ref
          .read(procurementControllerProvider.notifier)
          .sendGRN(tagrRqsBody);
      TransactionModel transaction = createTransaction(tagrRqsBody);
      String? transactionId = await ref
          .read(TransactionControllerProvider.notifier)
          .sentTransaction(transaction);
      BarcodeDetailModel detailModel =
          createBarcodeDetail(newTagStockCode, tagrRqsBody, transactionId);
      BarcodeHistoryModel historyModel =
          createBarcodeHistory(newTagStockCode, tagrRqsBody, transactionId);

      await ref
          .read(BarocdeDetailControllerProvider.notifier)
          .sentBarcodeDetail(detailModel);
      await ref
          .read(BarocdeHistoryControllerProvider.notifier)
          .sentBarcodeHistory(historyModel);
      //<--------------------api to update current grn------------------>
      if (ref.read(stockDetailsProvider).stockQty > 0) {
        print(
            "update grn is1 ${updateCurrentInveryItem(currentTotalStock, tag, imageUrl).toJson()}");
        await ref.read(procurementControllerProvider.notifier).updateGRN(
            updateCurrentInveryItem(currentTotalStock, tag, imageUrl).toJson(),
            currentTotalStock.stockCode);
      } else {
        await ref
            .read(procurementControllerProvider.notifier)
            .deleteGRN(currentTotalStock.stockCode);
      }

      ref.read(tagRowsProvider.notifier).addTag(tag);
      StockDetailsModel updateParentStock = updateStock(newChildStockDetails);
      ref.read(stockDetailsProvider.notifier).update(updateParentStock);
      ref.read(tagImgListProvider.notifier).addFile(File(''));

      print("added row");
    } catch (e) {
      print("error in addTagRow: $e");
    }
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

  Map<String, dynamic> convertToSchema(
      TagRow tag, InventoryItemModel stock, String image) {
    print("location is ${stock.locationName}");
    return {
      "varientName": stock.varientName,
      "vendor": stock.vendor,
      "stdBuyingRate": tag.rate,
      "stoneMaxWt": tag.diaWt,
      "stoneMinWt": tag.diaWt,
      "karatColor": stock.karatColor,
      "category": stock.category,
      "subCategory": stock.subCategory,
      "styleKarat": stock.styleKarat,
      "varient": stock.varientName,
      "style": stock.style,
      "oldVarient": stock.oldVarient,
      "customerVarient": stock.customerVarient,
      "baseVarient": stock.baseVarient,
      "remark1": stock.remark1,
      "vendorVarient": stock.vendorVarient,
      "remark2": stock.remark2,
      "createdBy": stock.createdBy,
      "remark": stock.remark,
      "deliveryDays": stock.deliveryDays,
      "forWeb": stock.forWeb,
      "rowStatus": stock.rowStatus,
      "verifiedStatus": stock.verifiedStatus,
      "length": stock.length,
      "codegenSrNo": stock.codegenSrNo,
      "hsnSacCode": stock.hsnSacCode,
      "lineOfBusiness": stock.lineOfBusiness,
      "bom": stock.bom,
      "operation": stock.operation,
      "imageDetails": image,
      "formulaDetails": stock.formulaDetails,
      "pieces": tag.pcs,
      "weight": tag.wt,
      "netWeight": tag.diaWt + tag.wt,
      "diaWeight": tag.diaWt,
      "diaPieces": tag.pcs,
      "loactionCode": stock.locationName,
      "vendorCode": stock.vendorCode,
      "location": stock.locationName,
      "itemGroup": stock.itemGroup,
      "metalColor": stock.metalColor,
      "styleMetalColor": stock.styleMetalColor,
      "isRawMaterial":0
    };
  }

  InventoryItemModel updateCurrentInveryItem(
      InventoryItemModel totalStock, TagRow tag, String imageFile) {
    totalStock.pieces = totalStock.pieces - 1;

    totalStock.metalWeight = totalStock.metalWeight - tag.wt;
    totalStock.diaWeight = totalStock.diaWeight - tag.diaWt;
    totalStock.diaPieces = max(totalStock.diaPieces - tag.pcs, 0);
    // totalStock.imageDetails = imageFile;
    totalStock.netWeight = totalStock.netWeight - tag.netWt;
    totalStock.stonePiece = totalStock.stonePiece - tag.pcs;
    return totalStock;
  }

    TransactionModel createTransaction(Map<String, dynamic> varient) {
      TransactionModel transaction = TransactionModel(
          transType: "Barcode Generation",
          subType: "BG",
          transCategory: "GENERAL",
          docNo: "bsjbcs",
          transDate: DateTime.now().toIso8601String(),
          source: "WareHouse",
          destination: "MH_CASH",
          customer: "ankit",
          sourceDept: "Warehouse",
          destinationDept: "MH_CASH",
          exchangeRate: "0.0",
          currency: "RS",
          salesPerson: "Arun",
          term: "term",
          remark: "Creating GRN",
          createdBy: DateTime.now().toIso8601String(),
          postingDate: DateTime.now().toIso8601String(),
          varients: [varient]);
      return transaction;

      // print("transactionID is $transactionID");
    }

  BarcodeDetailModel createBarcodeDetail(String newStockCode,
      Map<String, dynamic> tagrRqsBody, String? transactionID) {
    BarcodeDetailModel detailModel = BarcodeDetailModel(
        stockId: newStockCode,
        date: DateTime.now().toIso8601String(),
        transNo: transactionID ?? "ABC",
        transType: "Barcode Generation",
        source: tagrRqsBody["location"],
        destination: "MahaNagar",
        customer: "Anurag",
        vendor: tagrRqsBody["vendor"],
        sourceDept: "MHCASH",
        destinationDept: "MHCash",
        exchangeRate: 11.33,
        currency: "Rs",
        salesPerson: "Arpit",
        term: "nothing",
        remark: "barcode generated",
        createdBy: "Arpit Verma",
        varient: tagrRqsBody['varientName'],
        postingDate: DateTime.now().toIso8601String());
    return detailModel;
  }

  BarcodeHistoryModel createBarcodeHistory(String newStockCode,
      Map<String, dynamic> tagrRqsBody, String? transactionID) {
    BarcodeHistoryModel historyModel = BarcodeHistoryModel(
        stockId: newStockCode,
        attribute: '',
        varient: tagrRqsBody['varientName'],
        transactionNumber: transactionID ?? 'ABC',
        date: DateTime.now().toIso8601String(),
        bom: tagrRqsBody["bom"],
        operation: tagrRqsBody["operation"],
        formula: tagrRqsBody["formulaDetails"]);
    return historyModel;
  }

  TagRow createTag(StockDetailsModel newStockDetails,
      InventoryItemModel currentStock, File? imgFile) {
    TagRow tag = TagRow(
      checkbox: false,
      image: imgFile,
      variant: '${currentStock.varientName}',
      stockCode: '${currentStock.stockCode}#${newStockDetails.tagCreated + 1}',
      pcs: 1,
      wt: newStockDetails.currentNetWt - newStockDetails.currentStoneWt,
      netWt: newStockDetails.currentNetWt,
      clsWt: 0.0,
      diaWt: newStockDetails.currentStoneWt,
      stoneAmt: 0.0,
      metalAmt: 0.0,
      wstg: 0.0,
      fixMrp: newStockDetails.rate,
      making: 0.0,
      rate: newStockDetails.rate,
      amount: newStockDetails.rate,
      lineRemark: 'lineRemark',
      huid: 'huid',
      orderVariant: 'orderVariant',
    );
    return tag;
  }
}
