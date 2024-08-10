import 'package:flutter/material.dart';

class ExpandedCustomListTile extends StatelessWidget {
  final bool isCollapsed;
  final IconData icon;
  final String title;

  const ExpandedCustomListTile({
    super.key,
    required this.isCollapsed,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: !isCollapsed ? 300 : 80,
        height: 40,
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            if (!isCollapsed) const SizedBox(width: 10),
            if (!isCollapsed)
              Expanded(
                flex: 3,
                child: ExpansionTile(
                  leading: Icon(icon, color: Colors.white),
                  title: Text(title),
                  // title: Text(
                  //   !_isCollapsed ? title : '',
                  //   style: const TextStyle(color: Colors.white),
                  // ),
                  children: [],
                ),
              ),
            if (!isCollapsed) const Spacer(),
          ],
        ),
      ),
    );
  }
}
