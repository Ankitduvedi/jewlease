import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/model/procumentStyleVariant.dart';
import '../../barcoding/screens/barCodeGeneration.dart';

class InventoryDataSource extends DataGridSource {
  final BuildContext context;
  final List<DataGridRow> _dataGridRows;
  final Function(int index) setCureentRowIndex;

  InventoryDataSource(
    this.context,
    this.setCureentRowIndex,
    List<ProcumentStyleVariant> inventoryItems,
  ) : _dataGridRows = inventoryItems.map<DataGridRow>((inventoryItem) {
          return DataGridRow(cells: [
            DataGridCell(
              columnName: 'More',
              value: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "Formula") {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);
                    // showFormulaGrid(context, position);
                  } else if (value == "Attribute") {
                    final RenderBox renderBox =
                        context.findRenderObject() as RenderBox;
                    final position = renderBox.localToGlobal(Offset.zero);
                    // Handle Attribute logic here
                    // showAttributeGrid(context, position);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "Attribute",
                    child: Text("Attribute"),
                  ),
                  const PopupMenuItem(
                    value: "Formula",
                    child: Text("Formula"),
                  ),
                  PopupMenuItem(
                    value: "Generate Barcode",
                    child: Text("Generate Barcode"),
                    onTap: () {
                      print("varient Name is ${inventoryItem.variantName}");
                      if (inventoryItem.isRawMaterial == 1 &&
                          inventoryItem.variantName == "new") return;
                      if (inventoryItem.totalPieces.value == 1) return;
                      int index = inventoryItems.indexOf(inventoryItem);
                      setCureentRowIndex(index);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BarCodeGeneration()),
                      );
                    },
                  ),
                ],
                child: const Icon(Icons.more_vert), // "More" button icon
              ),
            ),
            DataGridCell(
                columnName: 'ItemGroup', value: inventoryItem.itemGroup),
            DataGridCell(
                columnName: 'VariantName', value: inventoryItem.variantName),
            DataGridCell(
                columnName: 'OldVariantName', value: inventoryItem.oldVariant),
            DataGridCell(columnName: 'StockCode', value: inventoryItem.stockID),
            DataGridCell(
                columnName: 'GroupCode', value: inventoryItem.groupCode),
            DataGridCell(
                columnName: 'QCStatus', value: inventoryItem.verifiedStatus),
            DataGridCell(columnName: 'BatchNo', value: inventoryItem.batchNo),
            DataGridCell(
                columnName: 'StoneShape', value: inventoryItem.stoneShape),
            DataGridCell(
                columnName: 'StoneRange', value: inventoryItem.stoneRange),
            DataGridCell(
                columnName: 'StoneColor', value: inventoryItem.stoneColor),
            DataGridCell(columnName: 'StoneCut', value: inventoryItem.stoneCut),
            DataGridCell(
                columnName: 'MetalKarat', value: inventoryItem.metalKarat),
            DataGridCell(
                columnName: 'MetalColor', value: inventoryItem.metalColor),
            DataGridCell(columnName: 'LOB', value: inventoryItem.lob),
            DataGridCell(columnName: 'Category', value: inventoryItem.category),
            DataGridCell(
                columnName: 'SubCategory', value: inventoryItem.subCategory),
            DataGridCell(
                columnName: 'StyleCollection',
                value: inventoryItem.styleCollection),
            DataGridCell(
                columnName: 'ProjectSizeMaster',
                value: inventoryItem.projectSizeMaster),
            DataGridCell(
                columnName: 'StyleMetalKarat', value: inventoryItem.styleKarat),
            DataGridCell(
                columnName: 'StyleMetalColor',
                value: inventoryItem.styleMetalColor),
            DataGridCell(columnName: 'Brand', value: inventoryItem.brand),
            DataGridCell(
                columnName: 'ProductSizeStock',
                value: inventoryItem.productSizeStock),
            DataGridCell(columnName: 'TablePer', value: inventoryItem.tablePer),
            DataGridCell(
                columnName: 'BrandStock', value: inventoryItem.brandStock),
            DataGridCell(
                columnName: 'VendorCode', value: inventoryItem.vendorCode),
            DataGridCell(columnName: 'Vendor', value: inventoryItem.vendor),
            DataGridCell(columnName: 'Customer', value: inventoryItem.customer),
            DataGridCell(
                columnName: 'Piece', value: inventoryItem.totalPieces.value),
            DataGridCell(
                columnName: 'Weight',
                value: inventoryItem.totalMetalWeight.value),
            DataGridCell(
                columnName: 'NetWeight',
                value: inventoryItem.totalWeight.value),
            DataGridCell(
                columnName: 'DiaPieces',
                value: inventoryItem.totalStonePeices.value),
            DataGridCell(
                columnName: 'DiaWeight',
                value: inventoryItem.totalStoneWeight.value),
            DataGridCell(columnName: 'LgPiece', value: inventoryItem.lgPiece),
            DataGridCell(columnName: 'LgWeight', value: inventoryItem.lgWeight),
            DataGridCell(
                columnName: 'StonePiece',
                value: inventoryItem.totalStonePeices.value),
            DataGridCell(
                columnName: 'StoneWeight',
                value: inventoryItem.totalStoneWeight.value),
            DataGridCell(columnName: 'SellingLabour', value: 0),
            DataGridCell(columnName: 'OrderNo', value: inventoryItem.orderNo),
            DataGridCell(
                columnName: 'KaratColor', value: inventoryItem.karatColor),
            DataGridCell(
              columnName: 'ImageFileName',
              value: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: NetworkImage(inventoryItem.imageDetails[0]),
                  // ),
                ),
              ),
            ),
            DataGridCell(
                columnName: 'InwardDocLastTrans',
                value: inventoryItem.inwardDoc),
            DataGridCell(
                columnName: 'ReserveInd', value: inventoryItem.reserveInd),
            DataGridCell(
                columnName: 'BarcodeInd', value: inventoryItem.barcodeInd),
            DataGridCell(
                columnName: 'TransitLocationCode',
                value: inventoryItem.locationCode),
            DataGridCell(
                columnName: 'LocationName', value: inventoryItem.locationName),
            DataGridCell(
                columnName: 'WCGroupName', value: inventoryItem.wcGroupName),
            DataGridCell(
                columnName: 'CustomerJobworker',
                value: inventoryItem.customerJobworker),
            DataGridCell(
                columnName: 'Halimarking', value: inventoryItem.halimarking),
            DataGridCell(
                columnName: 'CertificateNo',
                value: inventoryItem.certificateNo),
            DataGridCell(columnName: 'StockAge', value: inventoryItem.stockAge),
            DataGridCell(columnName: 'MemoInd', value: inventoryItem.memoInd),
            DataGridCell(
                columnName: 'BarcodeDate', value: inventoryItem.barcodeDate),
            DataGridCell(
                columnName: 'SorTransItemId',
                value: inventoryItem.sorTransItemId),
            DataGridCell(
                columnName: 'SorTransItemBomId',
                value: inventoryItem.sorTransItemBomId),
            DataGridCell(
                columnName: 'OwnerPartyTypeId',
                value: inventoryItem.ownerPartyTypeId),
            DataGridCell(
                columnName: 'ReservePartyId',
                value: inventoryItem.reservePartyId),
            DataGridCell(columnName: 'LineNo', value: inventoryItem.lineNo),
            DataGridCell(
                columnName: 'OrderPartName',
                value: inventoryItem.orderPartName),
            DataGridCell(
                columnName: 'InwardEllapsDays',
                value: inventoryItem.inwardEllapsDays),
            DataGridCell(
                columnName: 'OrderEllapsDays',
                value: inventoryItem.orderEllapsDays),
          ]);
        }).toList();

  @override
  List<DataGridRow> get rows => _dataGridRows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      color: const Color(0xFFFFFFFF),
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          child: cell.value is Widget
              ? cell.value
              : Text(
                  cell.value.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
        );
      }).toList(),
    );
  }
}
