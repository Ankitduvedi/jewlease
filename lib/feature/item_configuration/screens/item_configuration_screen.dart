import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';
import 'package:jewlease/feature/item_specific/widgets/app_bar_buttons.dart';

class ItemConfigurationScreen extends ConsumerWidget {
  const ItemConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Configuration'),
        actions: [
          AppBarButtons(
            ontap: [
              () {
                log('new pressed');
                context.go('/addItemConfigurtionScreen');
              },
              () {},
              () {
                // Reset the provider value to null on refresh
                ref.watch(masterTypeProvider.notifier).state = [
                  'Style',
                  null,
                  null
                ];
              },
              () {}
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search Forms',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Text('(Rows Count: 20)'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Item Type')),
                  DataColumn(label: Text('Item Group')),
                  DataColumn(label: Text('Item Nature')),
                  DataColumn(label: Text('Stock UOM')),
                  DataColumn(label: Text('Dependent Criteria')),
                  DataColumn(label: Text('BOM Indicator')),
                  DataColumn(label: Text('Lot Management Indicator')),
                  DataColumn(label: Text('Other Loss Indicator')),
                ],
                rows: _buildTableRows(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<DataRow> _buildTableRows() {
    final data = [
      [
        'STYLE',
        'STYLE',
        'FINISHED GOODS',
        'Pcs',
        'SUM(BOM WEIGHT)X(ITEM PCS)',
        true,
        false,
        false
      ],
      ['METAL', 'GOLD', 'RAW MATERIAL', 'Gms', 'WEIGHT', false, false, false],
      [
        'STONE',
        'DIAMOND',
        'RAW MATERIAL',
        'Cts',
        'PIECES & WEIGHT',
        true,
        true,
        true
      ],
      // Add more rows as needed
    ];

    return data.map((row) {
      return DataRow(
        cells: row.map((cell) {
          if (cell is bool) {
            return DataCell(Checkbox(value: cell, onChanged: (bool? value) {}));
          }
          return DataCell(Text(cell.toString()));
        }).toList(),
      );
    }).toList();
  }

  Widget _buildAppBarButton(String label, IconData icon) {
    return TextButton.icon(
      onPressed: () {
        // Handle button actions
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label, style: const TextStyle(color: Colors.black)),
    );
  }
}
