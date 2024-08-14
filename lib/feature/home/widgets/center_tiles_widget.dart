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
    _buildTile('Financial Accounting', Icons.monetization_on, Colors.green),
    _buildTile('App Management', Icons.apps, Colors.red),
    _buildTile('Configuration & Rules', Icons.settings,
        const Color.fromARGB(255, 163, 175, 76)),
    _buildTile('Formula Procedures', Icons.functions,
        Color.fromARGB(255, 222, 192, 74)),
    _buildTile('FG Inventory Management', Icons.inventory,
        Color.fromARGB(255, 59, 120, 104)),
    _buildTile('RM Inventory Management', Icons.store, Colors.green),
    _buildTile(
        'Migrations', Icons.cloud_upload, Color.fromARGB(255, 7, 159, 229)),
    _buildTile(
        'Generic Masters', Icons.layers, Color.fromARGB(255, 117, 55, 30)),
    _buildTile('Production', Icons.build, Colors.purple),
    _buildTile('Order Management', Icons.list_alt, Colors.blueAccent),
    _buildTile('Invoicing', Icons.receipt, Colors.orange.shade200),
    _buildTile('Procurement', Icons.shopping_cart, Colors.purple.shade200),
    _buildTile('CRM', Icons.person, Colors.brown),
    _buildTile('Sub Contracting', Icons.people, Colors.amberAccent),
    _buildTile('Scheme', Icons.lightbulb, Colors.blueAccent),
    _buildTile('Loyalty', Icons.emoji_events, Colors.cyan),
    _buildTile('Point Of Sale', Icons.point_of_sale, Colors.deepOrangeAccent),
    _buildTile('Item Masters', Icons.inventory_2, Colors.green),
  ];

  static Widget _buildTile(String title, IconData icon, Color color) {
    return Card(
      key: ValueKey(title),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          log('$title tile pressed');
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
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
          childAspectRatio: 2.5,
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

void main() => runApp(MaterialApp(home: ReorderableTilesScreen()));
