import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/core/routes/go_router.dart';
import 'package:jewlease/feature/home/drawer/drawer_toogle_button.dart';

class Appbar extends ConsumerWidget implements PreferredSizeWidget {
  const Appbar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('Appbar screen rebuild');

    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0, // Adjust spacing to align the search box
      title: Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  goRouter.go("/");
                },
                icon: const Icon(Icons.home)),
            const DrawerToggleButton(),
          ],
        ),
      ),
      flexibleSpace: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 35, // Decrease the height of the search bar
            width:
                MediaQuery.of(context).size.width * 0.4, // Set a smaller width
            child: const SearchBox(),
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: () {},
          child: const Text(
            'Metal Control React',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.shopping_basket_outlined)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.dashboard_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.person_2_sharp)),
      ],
    );
  }
}

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }
}
