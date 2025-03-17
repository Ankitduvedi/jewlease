import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/data/model/customer_model.dart';
import 'package:jewlease/feature/crm/screens/widgets/customer_age-widget.dart';
import 'package:jewlease/feature/crm/screens/widgets/customer_data_grid.dart';
import 'package:jewlease/feature/crm/screens/widgets/customer_walkin.dart';
import 'package:jewlease/feature/crm/screens/widgets/hourly_customer_widget.dart';
import 'package:jewlease/feature/crm/screens/widgets/inactive_customer_widget.dart';

class CrmDashboard extends StatefulWidget {
  const CrmDashboard({super.key});

  @override
  State<CrmDashboard> createState() => _CrmDashboardState();
}

class _CrmDashboardState extends State<CrmDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextButton(
            onPressed: () {
              context.push(
                '/addCustomerScreen',extra: CustomerModel()
              );
            },
            child: Text("Add Customer")),
      ),
      backgroundColor: Color(0xffF0F2F4),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomerActivityChart(),
                CustomerAgeChart(),
                CustomerWalkInProgress(),
                InactiveCustomers(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Customer Requests"),
                              Text("View"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(flex: 7, child: CustomerDataGrid()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
