import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/barcode_detail_model.dart';
import 'package:jewlease/data/model/bom_model.dart';
import 'package:jewlease/data/model/stock_details_model.dart';
import 'package:jewlease/data/model/transaction_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../core/utils/utils.dart';
import '../../../../data/model/barcode_historyModel.dart';
import '../../../../data/model/procumentStyleVariant.dart';
import '../../../../providers/image_provider.dart';
import '../../../../widgets/image_data.dart';
import '../../../home/right_side_drawer/controller/drawer_controller.dart';
import '../../../inventoryManagement/controllers/inventoryController.dart';
import '../../../procument/controller/procumentcController.dart';
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

  void addTagRow() async {
    print("adding row");
    ProcumentStyleVariant currentTotalStock =
        ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;
    // Utils.printJsonFormat(currentTotalStock.toJson());
    print("current item ${currentTotalStock.variantName}");
    // return;
    // try {
    StockDetailsModel newChildStockDetails = ref.read(stockDetailsProvider);
    if (newChildStockDetails.currentBom != null) {
      print("tag bom is ${newChildStockDetails.currentBom!.bomRows[0].amount}");
    }
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

    ProcumentStyleVariant tagStyleVariant = ProcumentStyleVariant.copy(currentTotalStock);
    tagStyleVariant =
        updateTagStyleVariant(tagStyleVariant, newChildStockDetails, imageUrl);
    Map<String, dynamic> tagrRqsBody = tagStyleVariant.toJson();
    tagrRqsBody.remove("Stock ID");
    Map<String, dynamic> updatedTotalBom = {};
    print("updated total Bom $updatedTotalBom");
    // return;

    //<---------------api to create a new tag---------------->
    // String? transactionID =
    //     await Utils().createNewTransaction([tagrRqsBody], ref, "Barcoding");

    BomModel newParentBom = updatedParentBom(
        currentTotalStock.bomData, newChildStockDetails.currentBom!);
    currentTotalStock.bomData = newParentBom;
    currentTotalStock.operationData = newChildStockDetails.currentOperation!;
    ref
        .read(inventoryControllerProvider.notifier)
        .updateStyleVariant(currentTotalStock);

    ref.read(isTagCreatedProvider.notifier).setUpdate(true); //
    ref.read(tagRowsProvider.notifier).addTag(tag);
    StockDetailsModel updateParentStock = updateStock(newChildStockDetails);
    ref.read(stockDetailsProvider.notifier).update(updateParentStock);
    ref.read(tagImgListProvider.notifier).addFile(File(''));
    // ref.read(isTagUpdateProvider.notifier).setUpdate(false); //
    return;

    //<--------------------api to update current grn------------------>
    if (newChildStockDetails.stockQty > 0) {
      await ref.read(procurementControllerProvider.notifier).updateGRN(
          updateCurrentInveryItem(
                  currentTotalStock, tag, imageUrl, updatedTotalBom)
              .toJson(),
          currentTotalStock.stockID);
    } else {
      await ref
          .read(procurementControllerProvider.notifier)
          .deleteGRN(currentTotalStock.stockID);
    }
    // ref.read(tagRowsProvider.notifier).addTag(tag);
    // StockDetailsModel updateParentStock = updateStock(newChildStockDetails);
    // ref.read(stockDetailsProvider.notifier).update(updateParentStock);
    // ref.read(tagImgListProvider.notifier).addFile(File(''));
    // } catch (e) {
    //   print("error in addTagRow: $e");
    // }
  }

  StockDetailsModel updateStock(StockDetailsModel newStockDetails) {
    newStockDetails.rate = 0;
    newStockDetails.balMetWt = newStockDetails.balMetWt -
        (newStockDetails.currentMetalWt - newStockDetails.currentStoneWt);
    newStockDetails.balStoneWt =
        newStockDetails.balStoneWt - newStockDetails.currentStoneWt;
    newStockDetails.balWt =
        newStockDetails.balWt - newStockDetails.currentNetWt;
    newStockDetails.stockQty -= newStockDetails.currentPieces;
    newStockDetails.balStonePcs -= newStockDetails.currentDiaPieces;
    newStockDetails.tagCreated++;
    newStockDetails.remaining--;
    newStockDetails.currentNetWt = 0;
    newStockDetails.currentStoneWt = 0;
    newStockDetails.currentWt = 0;
    newStockDetails.currentPieces = 0;
    newStockDetails.currentAmount = 0;
    newStockDetails.currentBom = null;
    newStockDetails.currentOperation = null;

    return newStockDetails;
  }

  BomModel updatedParentBom(BomModel parentBom, BomModel childBom) {
    print("update parent bom ");
    for (int bomIndex = 0; bomIndex < parentBom.bomRows.length; bomIndex++) {
      BomRowModel parentBomRowModel = parentBom.bomRows[bomIndex];
      BomRowModel childBomRowModel = childBom.bomRows[bomIndex];
      print("weight parent ${parentBomRowModel.weight} child ${childBomRowModel.weight}");
      parentBomRowModel.rate = childBomRowModel.rate;
      parentBomRowModel.weight -= childBomRowModel.weight;
      parentBomRowModel.amount =
          childBomRowModel.rate * parentBomRowModel.weight;
      parentBomRowModel.itemGroup = childBomRowModel.itemGroup;
      parentBomRowModel.variantName = childBomRowModel.variantName;
      parentBomRowModel.rowNo = childBomRowModel.rowNo;
      parentBomRowModel.operation = childBomRowModel.operation;
      parentBomRowModel.avgWeight = childBomRowModel.avgWeight;
      parentBomRowModel.pieces -= childBomRowModel.pieces;
      parentBomRowModel.type = childBomRowModel.type;
      parentBom.bomRows[bomIndex] = parentBomRowModel;
    }
    for (int bomIndex = 0; bomIndex < parentBom.bomRows.length; bomIndex++) {
      BomRowModel parentBomRowModel = parentBom.bomRows[bomIndex];
      print("updated weight is ${parentBomRowModel.weight}");
    }

    return parentBom;
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
      TagRow tag, ProcumentStyleVariant stock, String image) {
    print("location is ${stock.locationName}");
    return {
      "varientName": stock.variantName,
      "vendor": stock.vendor,
      "stdBuyingRate": tag.rate,
      "stoneMaxWt": tag.diaWt,
      "stoneMinWt": tag.diaWt,
      "karatColor": stock.karatColor,
      "category": stock.category,
      "subCategory": stock.subCategory,
      "styleKarat": stock.styleKarat,
      "varient": stock.variantName,
      "style": stock.style,
      "oldVarient": stock.oldVariant,
      "customerVarient": stock.customerVariant,
      "baseVarient": stock.baseVariant,
      "remark1": stock.remark1,
      "vendorVarient": stock.vendorVariant,
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
      "bom": tag.bom,
      "operation": stock.operationData.toJson(),
      "imageDetails": image,
      "formulaDetails": stock.formulaDetails,
      "pieces": tag.pcs,
      "weight": tag.wt,
      "netWeight": tag.netWt,
      "diaWeight": tag.diaWt,
      "diaPieces": tag.diaPieces,
      "loactionCode": stock.locationName,
      "vendorCode": stock.vendorCode,
      "location": ref.watch(selectedDepartmentProvider).locationName,
      "department": ref.watch(selectedDepartmentProvider).departmentName,
      "itemGroup": stock.itemGroup,
      "metalColor": stock.metalColor,
      "styleMetalColor": stock.styleMetalColor,
      "isRawMaterial": stock.isRawMaterial
    };
  }

  ProcumentStyleVariant updateTagStyleVariant(ProcumentStyleVariant variant,
      StockDetailsModel newTagData, String imageUrl) {
    variant.totalPieces = TotalPeices(newTagData.currentPieces);
    variant.totalStonePeices = TotalPeices(newTagData.currentDiaPieces);
    variant.totalMetalWeight = TotalMetalWeight(newTagData.currentMetalWt);
    variant.totalStoneWeight = TotalStoneWeight(newTagData.currentStoneWt);
    variant.totalWeight = TotalWeight(newTagData.currentNetWt);
    variant.imageDetails = [imageUrl];
    variant.bomData = newTagData.currentBom ?? variant.bomData;
    variant.operationData =
        newTagData.currentOperation ?? variant.operationData;
    return variant;
  }

  ProcumentStyleVariant updateCurrentInveryItem(
      ProcumentStyleVariant totalStock,
      TagRow tag,
      String imageFile,
      Map<String, dynamic> updatedBom) {
    totalStock.totalPieces =
        TotalPeices(totalStock.totalPieces.value - tag.pcs);

    totalStock.totalMetalWeight =
        TotalMetalWeight(totalStock.totalMetalWeight.value - tag.wt);
    totalStock.totalStoneWeight =
        TotalStoneWeight(totalStock.totalStoneWeight.value - tag.diaWt);
    totalStock.totalStonePeices =
        TotalPeices(max(totalStock.totalStonePeices.value - tag.pcs, 0));
    // totalStock.imageDetails = imageFile;
    totalStock.totalWeight =
        TotalWeight(totalStock.totalWeight.value - tag.netWt);
    totalStock.totalStonePeices =
        TotalPeices(totalStock.totalStonePeices.value - tag.diaPieces);
    // totalStock.bom = updatedBom;
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
      ProcumentStyleVariant oldParentStock, File? imgFile) {
    print("current bom ${newStockDetails.currentBom}");
    TagRow tag = TagRow(
      checkbox: false,
      image: imgFile,
      variant: '${oldParentStock.variantName}',
      stockCode: '${oldParentStock.stockID}#${newStockDetails.tagCreated + 1}',
      pcs: newStockDetails.currentPieces,
      wt: newStockDetails.currentMetalWt,
      netWt: newStockDetails.currentNetWt,
      clsWt: 0.0,
      diaWt: newStockDetails.currentStoneWt,
      stoneAmt: 0.0,
      metalAmt: 0.0,
      wstg: 0.0,
      fixMrp: newStockDetails.rate,
      making: 0.0,
      rate: newStockDetails.rate,
      amount: newStockDetails.currentAmount,
      lineRemark: 'lineRemark',
      huid: 'huid',
      orderVariant: 'orderVariant',
      diaPieces: newStockDetails.currentDiaPieces,
      bom: newStockDetails.currentBom,
      operation: newStockDetails.currentOperation,
    );
    return tag;
  }
}
