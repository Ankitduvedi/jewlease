import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ReorderableTilesScreen extends StatefulWidget {
  const ReorderableTilesScreen({super.key});

  @override
  ReorderableTilesScreenState createState() => ReorderableTilesScreenState();
}

class ReorderableTilesScreenState extends State<ReorderableTilesScreen> {
  final List<Widget> _tiles = [
    _buildTile('Financial Accounting', Icons.monetization_on),
    _buildTile('App Management', Icons.apps),
    _buildTile('Configuration & Rules', Icons.settings),
    _buildTile('Formula Procedures', Icons.functions),
    _buildTile('FG Inventory Management', Icons.inventory),
    _buildTile('RM Inventory Management', Icons.store),
    _buildTile('Migrations', Icons.cloud_upload),
    _buildTile('Generic Masters', Icons.layers),
    _buildTile('Production', Icons.build),
    _buildTile('Order Management', Icons.list_alt),
    _buildTile('Invoicing', Icons.receipt),
    _buildTile('Procurement', Icons.shopping_cart),
    _buildTile('CRM', Icons.person),
    _buildTile('Sub Contracting', Icons.people),
    _buildTile('Scheme', Icons.lightbulb),
    _buildTile('Loyalty', Icons.emoji_events),
    _buildTile('Point Of Sale', Icons.point_of_sale),
    _buildTile('Item Masters', Icons.inventory_2),
  ];

  static Widget _buildTile(String title, IconData icon) {
    return Card(
      key: ValueKey(title),
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(title, style: const TextStyle(color: Colors.black)),
        onTap: () {
          log('$title this tile pressed');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Access'),
        //backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReorderableGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              final element = _tiles.removeAt(oldIndex);
              _tiles.insert(newIndex, element);
            });
          },
          children: _tiles,
        ),
      ),
    );
  }
}
