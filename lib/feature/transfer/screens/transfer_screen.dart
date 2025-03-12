import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/transfer/screens/transfer_inward_screen.dart';
import 'package:jewlease/feature/transfer/screens/transfer_outward_screen.dart';

import '../../../main.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class TransferScreen extends ConsumerStatefulWidget {
  const TransferScreen({super.key});

  @override
  ConsumerState<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends ConsumerState<TransferScreen> {
  @override
  List<String> _tabs = ['Inter Wc Group Transfer Outward', 'Transfer In'];
  Widget build(BuildContext context) {
    var selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight,
      width: screenWidth,
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.1,
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
                      )))),
          if (selectedIndex == 0)
            Expanded(child: TransferOutwardScreen())
          else
            Expanded(child: TransferInwardScreen())
        ],
      ),
    );
  }
}
