import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:jewlease/core/routes/go_router.dart';
import 'package:jewlease/main.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ReorderableTilesScreen extends StatefulWidget {
  const ReorderableTilesScreen({super.key});

  @override
  ReorderableTilesScreenState createState() => ReorderableTilesScreenState();
}

class ReorderableTilesScreenState extends State<ReorderableTilesScreen> {
  final List<Widget> _tiles = [
    const _buildTile(
        title: 'Financial Accounting',
        icon: Icons.monetization_on,
        color: Colors.green,
        key: ValueKey('Financial Accounting')),
    const _buildTile(
        title: 'App Management',
        icon: Icons.apps,
        color: Colors.red,
        key: ValueKey('App Management')),
    const _buildTile(
        title: 'Configuration & Rules',
        icon: Icons.settings,
        color: Color.fromARGB(255, 163, 175, 76),
        key: ValueKey('Configuration & Rules')),
    _buildTile(
        onTap: () {
          goRouter.push('/formulaProcedureScreen');
        },
        title: 'Formula Procedures',
        icon: Icons.functions,
        color: const Color.fromARGB(255, 222, 192, 74),
        key: const ValueKey('Formula Procedures')),
    const _buildTile(
        title: 'FG Inventory Management',
        icon: Icons.inventory,
        color: Color.fromARGB(255, 59, 120, 104),
        key: ValueKey('FG Inventory Management')),
    _buildTile(
      title: 'RM Inventory Management',
      icon: Icons.store,
      color: Colors.green,
      key: const ValueKey('RM Inventory Management'),
      onTap: () {
        goRouter.push("/rmInventoryScreen");
      },
    ),
    _buildTile(
      title: 'Sub Contractiing',
      icon: Icons.cloud_upload,
      color: const Color.fromARGB(255, 7, 159, 229),
      key: const ValueKey('Sub Contracting'),
      onTap: () {
        goRouter.push('/subContracting');
      },
    ),
    _buildTile(
      title: 'RM Procument',
      icon: Icons.layers,
      color: const Color.fromARGB(255, 117, 55, 30),
      key: const ValueKey('RM Procument'),
      onTap: () {
        goRouter.push("/rm_procument");
      },
    ),
    _buildTile(
      title: 'Production',
      icon: Icons.build,
      color: Colors.purple,
      key: const ValueKey('Production'),
      onTap: () {
        goRouter.push('/DataGrid');
      },
    ),
    _buildTile(
      title: 'Transfer Location',
      icon: Icons.list_alt,
      color: Colors.blueAccent,
      key: const ValueKey('Transfer Location'),
      onTap: () {
        goRouter.push('/transferLocation');
      },
    ),
    _buildTile(
      title: 'Transfer',
      icon: Icons.receipt,
      color: Colors.orange.shade200,
      key: const ValueKey('Invoicing'),
      onTap: () {
        log("called her");
        goRouter.push('/transferScreen');
      },
    ),
    _buildTile(
      title: 'Procurement',
      icon: Icons.shopping_cart,
      color: Colors.purple.shade200,
      key: const ValueKey('Procurement'),
      onTap: () {
        log("called her");
        goRouter.push('/procumentScreen');
      },
    ),
    _buildTile(
        title: 'Bar Code Generation',
        icon: Icons.person,
        color: Colors.brown,
        onTap: () {
          goRouter.push('/barcodeGeneration');
        },
        key: const ValueKey('Bar Codr Gneration')),
    _buildTile(
      title: 'BarCode History',
      icon: Icons.history,
      color: Colors.blue,
      onTap: () {
        goRouter.push('/barcodingScreen');
      },
      key: const ValueKey('Sub Contracting'),
    ),
    _buildTile(
      title: 'Inventory Management',
      icon: Icons.lightbulb,
      color: Colors.blueAccent,
      key: const ValueKey('Scheme'),
      onTap: () {
        goRouter.push('/inventoryScreen');
      },
    ),
    _buildTile(
      title: 'CRM',
      icon: Icons.emoji_events,
      color: Colors.cyan,
      key: const ValueKey('Loyalty'),
      onTap: () {
        goRouter.push('/CustomerDashboard');
      },
    ),
    _buildTile(
      title: 'Point Of Sale',
      icon: Icons.point_of_sale,
      color: Colors.deepOrangeAccent,
      key: const ValueKey('Point Of Sale'),
      onTap: () {
        goRouter.push("/point_of_sale");
      },
    ),
    const _buildTile(
        title: 'Item Masters',
        icon: Icons.inventory_2,
        color: Colors.green,
        key: ValueKey('Item Masters')),
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

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

class _buildTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap; // Make onTap nullable

  const _buildTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Card(
      key: ValueKey(title),
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
}
