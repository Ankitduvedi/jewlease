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
          color: Color.fromRGBO(20, 20, 20, 1),
        ),
        child: Column(
          children: [
            IconButton(
              icon: Icon(
                _isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: Colors.white,
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
      leading: Icon(icon, color: Colors.white),
      title: AnimatedOpacity(
        opacity: _isCollapsed ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
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
        leading: Icon(icon, color: Colors.white),
        title: AnimatedOpacity(
          opacity: _isCollapsed ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
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

  Widget _buildSubTile(IconData icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
          onTap: () {
            // Handle sub-tile tap
          },
        ),
        const Divider(color: Colors.grey), // Divider between sub-tiles
      ],
    );
  }
}
