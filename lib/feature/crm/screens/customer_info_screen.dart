import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/crm/screens/ledger_data_grid.dart';

import '../../../main.dart';

final tabIndexProvider = StateProvider<int>((ref) => 0);

class CustomerInfoScreen extends ConsumerStatefulWidget {
  const CustomerInfoScreen({super.key});

  @override
  ConsumerState<CustomerInfoScreen> createState() => _CustomerInfoScreenState();
}

class _CustomerInfoScreenState extends ConsumerState<CustomerInfoScreen> {
  @override
  List<String> _tabs = [
    'Orders',
    'Sales',
    'Customer Stock',
    'Memo',
    'Scheme',
    'Bills',
    'Loyalty',
    'Ledgers',
    'Metal Ledgers',
    'Repair & Return'
  ];

  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(tabIndexProvider);
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: const Color(0xffEFF2F4),
      margin: const EdgeInsets.only(top: 60),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Customer Info",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 190,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    // width: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Sanjay Kumar",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              onPressed: () {
                                context.push('/addCustomerScreen');
                              },
                              icon: const Icon(
                                Icons.edit,
                                size: 15,
                                color: Colors.green,
                              ),
                            ),
                            const Spacer(),
                            const Text(
                              "Additional Info",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        const Text(
                          "183163186",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: const Color(0xffBFBFBF),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            // Spacer(),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      size: 12,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "a@gmail.com",
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      size: 12,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "+918077485551",
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          color: const Color(0xffBFBFBF),
                          padding: const EdgeInsets.all(7),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("Balance"), Text("Rs. 15000")],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Last Transaction",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "View",
                              style: TextStyle(color: Colors.green),
                            )
                          ],
                        ),
                        Text(
                          "5",
                          style: TextStyle(fontSize: 30, color: Colors.orange),
                        ),
                        Text("Days ago"),
                        Text(
                          "1 item purchased",
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    // color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Item Prefrences",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [1, 2, 3]
                                .map(
                                  (_element) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffBFBFBF),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      Text("$_element ring")
                                    ],
                                  ),
                                )
                                .toList()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff003450),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Average Order Value (AOV)",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Rs.88888",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color(0xff1F552F),
                            borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Customer Lifetime Value (AOV)",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "Rs.88888",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 25),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
              height: screenHeight * 0.06,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
              decoration: const BoxDecoration(
                  // color: Colors.white,

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
                          color: Colors.transparent,
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.01),
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.005),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.013,
                                vertical: screenHeight * 0.005),
                            decoration: BoxDecoration(
                              color: index == selectedIndex
                                  ? Colors.black
                                  : Colors.white,
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
          selectedIndex == 7 ? const LedgerDataGrid() : Container()
        ],
      ),
    );
  }
}
