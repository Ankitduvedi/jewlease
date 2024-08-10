import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _isCollapsed = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: _isCollapsed ? 70 : 250,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            IconButton(
              icon: Icon(
                _isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isCollapsed = !_isCollapsed;
                });
              },
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildExpansionTile(
                    icon: Icons.currency_rupee_sharp,
                    title: 'Rate Updation',
                    subTiles: [
                      _buildListTile(CupertinoIcons.list_dash,
                          'Metal Rate Updation Filter'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Stone Buying Rate'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Stone Selling Rate'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'GST Percentage'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Labour Rate Updation'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Discount Rate Updation'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Style(SP) Rate Updation'),
                      _buildListTile(CupertinoIcons.list_dash,
                          'Formula Rate Updation(Style Wastage)'),
                      _buildListTile(CupertinoIcons.list_dash, 'OMP Fineness'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Allowable Discount'),
                    ],
                  ),
                  _buildExpansionTile(
                    icon: Icons.pin_drop,
                    title: 'Configuration and Rules',
                    subTiles: [
                      _buildExpansionTile(
                        icon: Icons.pin_drop,
                        title: 'Destinations',
                        subTiles: [
                          _buildListTile(Icons.home, 'Home'),
                          _buildListTile(Icons.calendar_today, 'Calendar'),
                        ],
                      ),
                      _buildListTile(CupertinoIcons.list_dash,
                          'Metal Rate Updation Filter'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Stone Buying Rate'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Stone Selling Rate'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'GST Percentage'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Labour Rate Updation'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Discount Rate Updation'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Style(SP) Rate Updation'),
                      _buildListTile(CupertinoIcons.list_dash,
                          'Formula Rate Updation(Style Wastage)'),
                      _buildListTile(CupertinoIcons.list_dash, 'OMP Fineness'),
                      _buildListTile(
                          CupertinoIcons.list_dash, 'Allowable Discount'),
                    ],
                  ),
                  _buildListTile(Icons.home, 'Home'),
                  _buildListTile(Icons.calendar_today, 'Calendar'),
                  _buildExpansionTile(
                    icon: Icons.pin_drop,
                    title: 'Destinations',
                    subTiles: [
                      _buildListTile(Icons.home, 'Home'),
                      _buildListTile(Icons.calendar_today, 'Calendar'),
                    ],
                  ),
                  _buildListTile(Icons.message_rounded, 'Messages'),
                  _buildListTile(Icons.cloud, 'Weather'),
                  _buildExpansionTile(
                    icon: Icons.airplane_ticket,
                    title: 'Flights',
                    subTiles: [
                      _buildListTile(Icons.home, 'Home'),
                      _buildListTile(Icons.calendar_today, 'Calendar'),
                    ],
                  ),
                  _buildListTile(Icons.notifications, 'Notifications'),
                  _buildListTile(Icons.settings, 'Settings'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Text(
          maxLines: 2,
          title,
          style: const TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis, // Ensures text doesn't overflow
        ),
      ),
      onTap: () {
        // Handle tap
      },
    );
  }

  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required List<Widget> subTiles,
  }) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.grey, // Restore the divider color
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black),
        title: AnimatedOpacity(
          opacity: _isCollapsed ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Text(
            title,
            style: const TextStyle(color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: _isCollapsed
            ? SizedBox.shrink()
            : null, // Remove arrow when collapsed
        children: subTiles,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      ),
    );
  }

  // Widget _buildSubTile(IconData icon, String title) {
  //   return Column(
  //     children: [
  //       ListTile(
  //         leading: Icon(icon, color: Colors.black),
  //         title: Text(
  //           title,
  //           style: const TextStyle(color: Colors.black),
  //         ),
  //         onTap: () {
  //           // Handle sub-tile tap
  //         },
  //       ),
  //       const Divider(color: Colors.grey), // Divider between sub-tiles
  //     ],
  //   );
  // }
}
