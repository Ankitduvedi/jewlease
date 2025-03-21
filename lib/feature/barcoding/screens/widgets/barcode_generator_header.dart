import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/data/model/stock_details_model.dart';

import '../../../../data/model/inventoryItem.dart';
import '../../../../widgets/read_only_textfield_widget.dart';
import '../../../../widgets/text_field_widget.dart';
import '../../../inventoryManagement/controllers/inventoryController.dart';
import '../../controllers/stockController.dart';
import '../barCodeGeneration.dart';

class BarcodeHeader extends ConsumerStatefulWidget {
  const BarcodeHeader({Key? key}) : super(key: key);

  @override
  ConsumerState<BarcodeHeader> createState() => _BarcodeHeaderState();
}

class _BarcodeHeaderState extends ConsumerState<BarcodeHeader> {
  late InventoryItemModel currentStock;
  final TextEditingController _grossWeightController = TextEditingController();
  final TextEditingController _physicalQtyController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    intializeCurrentItem();
    super.initState();
  }

  List<String> stockDetailsParameters = [
    "StockQty",
    "TagCreated",
    "Remaining",
    "BalPcs",
    "BalWt",
    "BalMetWt",
    "BalStonePcs",
    "BalStoneWt",
    "BalFindPcs",
    "BalFindWt",
  ];

  void intializeCurrentItem() {
    currentStock =
        ref.read(inventoryControllerProvider.notifier).getCurrentItem()!;
    print("current stock is $currentStock");
    StockDetailsModel stockDetails = StockDetailsModel(
        stockQty: currentStock.pieces,
        tagCreated: 0,
        remaining: currentStock.pieces,
        balPcs: currentStock.diaPieces,
        balWt: currentStock.diaWeight + currentStock.metalWeight,
        balMetWt: currentStock.metalWeight,
        balStonePcs: currentStock.diaPieces,
        balStoneWt: currentStock.diaWeight,
        balFindPcs: 0,
        balFindWt: 0,
        currentWt: currentStock.metalWeight);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(stockDetailsProvider.notifier).initialize(stockDetails);
      _grossWeightController.text = stockDetails.balFindWt.toString();
      _physicalQtyController.text = stockDetails.stockQty.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final stockDetails = ref.watch(stockDetailsProvider);
    _grossWeightController.text= stockDetails.balWt.toString();
    _physicalQtyController.text= stockDetails.stockQty.toString();



    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 1,
                spreadRadius: 3)
          ]),
      child: Column(
        children: [
          // Header Section
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Colors.blue.shade800,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderItemWidget(
                    title: 'Stock Qty', value: stockDetails.stockQty * 1.0),
                HeaderItemWidget(
                    title: 'Tag Created', value: stockDetails.tagCreated * 1.0),
                HeaderItemWidget(
                    title: 'Remaining', value: stockDetails.remaining * 1.0),
                HeaderItemWidget(
                    title: 'Bal Pcs', value: stockDetails.stockQty * 1.0),
                HeaderItemWidget(title: 'Bal Wt', value: stockDetails.balWt),
                HeaderItemWidget(
                    title: 'Bal Met Wt', value: stockDetails.balMetWt),
                HeaderItemWidget(
                    title: 'Bal Stone Pcs',
                    value: stockDetails.balStonePcs * 1.0),
                HeaderItemWidget(
                    title: 'Bal Stone Wt', value: stockDetails.balStoneWt),
                HeaderItemWidget(
                    title: 'Bal Find Pcs',
                    value: stockDetails.balFindPcs * 1.0),
                HeaderItemWidget(
                    title: 'Bal Find Wt', value: stockDetails.balFindWt),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Input Section
          Container(
            // elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    width: 120,
                    child: TextField(
                      controller: _grossWeightController,

                      decoration: InputDecoration(
                        labelText: 'G. Wt *',
                        labelStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      enabled: false,


                      onSubmitted: (value) {
                        // StockDetailsModel updatedStockDetails = stockDetails;
                        // updatedStockDetails.currentWt = double.parse(value);
                        // ref
                        //     .read(stockDetailsProvider.notifier)
                        //     .update(updatedStockDetails);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    width: 120,
                    child: TextField(
                      controller: _physicalQtyController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Phy Qty *',
                        labelStyle: const TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    width: 120,
                    child: ReadOnlyTextFieldWidget(
                      labelText: 'Size',
                      hintText: '0',
                      icon: Icons.search,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    width: 120,
                    child: TextFieldWidget(
                        labelText: 'Wastage',
                        controller: TextEditingController()),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    width: 150,
                    child: TextFieldWidget(
                        labelText: 'Making Per Gram',
                        controller: TextEditingController()),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    width: 220,
                    child: TextFieldWidget(
                        labelText: 'HUID', controller: TextEditingController()),
                  ),
                  const SizedBox(width: 8),
                  CheckboxFieldWidget(label: 'Hallmark'),
                  CheckboxFieldWidget(label: 'Creat New Barcode'),
                  ButtonWidget(
                    text: 'Details',
                    color: Colors.black,
                    icon: Icons.add,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xff28713E),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Create Tag',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                ),
                SizedBox(width: 8),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderItemWidget extends StatelessWidget {
  final String title;
  final double value;

  const HeaderItemWidget({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
