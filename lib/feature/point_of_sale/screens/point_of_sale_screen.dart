import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/point_of_sale/screens/sales_summery_screen.dart';
import 'package:jewlease/main.dart';

import '../../procument/screens/procumentSummeryScreen.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class PointOfSaleScreen extends ConsumerStatefulWidget {
  const PointOfSaleScreen({super.key});

  @override
  ConsumerState<PointOfSaleScreen> createState() => _PointOfSaleScreenState();
}

class _PointOfSaleScreenState extends ConsumerState<PointOfSaleScreen> {
  List<String> _tabs = [
    'Estimation',
    'Memo Issue',
    'Payment',
    'PUrchase Invoic',
    'Reciept',
    'Sales Invoice',
    'Sales Return',
    'Sales Order'
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    final selectedIndex = ref.watch(tabIndexProvider);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                height: screenHeight * 0.06,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: Row(
                    children: List.generate(
                      _tabs.length,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(tabIndexProvider.notifier).state = index;
                          },
                          child: Container(
                            color: index == selectedIndex
                                ? Color(0xff28713E)
                                : Colors.white,
                            margin: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.01),
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.007),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.005),
                              decoration: BoxDecoration(
                                color: index == selectedIndex
                                    ? Color(0xff28713E)
                                    : Color(0xffF0F4F8),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text(
                                  _tabs[index],
                                  style: TextStyle(
                                      color: index == selectedIndex
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: selectedIndex == 0
            ? SalesSummaryScreen()
            : Container());
  }
}
