import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/core/routes/go_router.dart';
import 'package:jewlease/data/variables/variable.dart';
import 'package:jewlease/feature/home/drawer/drawer_toogle_button.dart';
import 'package:jewlease/feature/home/right_side_drawer/controller/drawer_controller.dart';
import 'package:jewlease/feature/search_box/screen/search_box_screen.dart';

class Appbar extends ConsumerWidget implements PreferredSizeWidget {
  const Appbar({super.key, required GlobalKey<ScaffoldState> scaffoldKey})
      : _scaffoldKey = scaffoldKey;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log('AppbarWithDrawer screen rebuild');
    final selectedDepartment = ref.watch(selectedDepartmentProvider);

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
          child: selectedDepartment != null
              ? Text(
                  selectedDepartment.departmentName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : const CircularProgressIndicator(),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.shopping_basket_outlined)),
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.dashboard_outlined)),
        IconButton(
            onPressed: () {
              const amount = -1000.0;
              Price(
                amount,
                ref,
              );
              // final price = ref.read(validationServiceProvider).createPrice(
              //       amount,
              //     );

              // if (price != null) {
              //   // Handle valid price
              // }
            },
            icon: const Icon(Icons.settings)),
        IconButton(
            onPressed: () {
              log('button pressed');
              // Open the drawer programmatically
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(Icons.person_2_sharp)),
      ],
    );
  }
}
