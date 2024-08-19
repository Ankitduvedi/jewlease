import 'package:flutter/material.dart';

class CustomAppBarExample extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  const CustomAppBarExample({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF346B43), // Matching the green color
      flexibleSpace: const Padding(
        padding: EdgeInsets.fromLTRB(13.0, 15, 0, 0),
        child: Row(
          children: [
            SizedBox(width: 8), // Spacing to align with the design
            Icon(
              Icons.add_circle_outline,
              size: 20,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              'Finder',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      centerTitle: true,
      title: Text(title,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70)),
      actions: [
        const Padding(
          padding: EdgeInsets.only(right: 10.0),
          child: Text(
            'Press “Esc” to Close',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the app bar
            },
          ),
        ),
      ],
    );
  }
}
