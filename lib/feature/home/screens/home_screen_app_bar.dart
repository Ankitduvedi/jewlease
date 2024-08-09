import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Appbar extends ConsumerWidget implements PreferredSizeWidget {
  const Appbar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text('hello---'),
      actions: [
        OutlinedButton(
            onPressed: () {},
            child: const Text('Metal Control React',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700))),
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
