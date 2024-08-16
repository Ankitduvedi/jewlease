import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant.dart';

class AppBarButtons extends ConsumerWidget {
  const AppBarButtons({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      //width: 200,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCustomButton(
              label: 'New',
              icon: Icons.add_circle_outline,
              color: Colors.blue,
              onPressed: () {
                log('new pressed');
                context.push('/addVariantMasterScreen');
              }),
          _buildCustomButton(
              label: 'Save',
              icon: Icons.save_alt,
              color: Colors.green,
              onPressed: () {
                log('save pressed');
              }),
          _buildCustomButton(
              label: 'Refresh',
              icon: Icons.refresh,
              color: Colors.blue,
              onPressed: () {
                // Reset the provider value to null on refresh
                ref.watch(masterTypeProvider.notifier).state = [
                  'Style',
                  null,
                  null
                ];
              }),
          _buildCustomButton(
              label: 'Settings',
              icon: Icons.settings,
              color: Colors.grey,
              onPressed: () {}),
          _buildCustomButton(
              label: 'Back',
              icon: Icons.cancel_outlined,
              color: Colors.red,
              onPressed: () {
                _showCloseDialog(context);
              }),
        ],
      ),
    );
  }

  Widget _buildCustomButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
        size: 20,
      ),
      label: Text(
        label,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        side: const BorderSide(color: Colors.transparent),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
      ),
    );
  }

  void _showCloseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.web_asset_rounded,
                color: Colors.redAccent,
                size: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'Close Current Page?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'You will be redirected to the dashboard. '
                'Any unsaved data will be lost.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDialogButton(
                    context,
                    label: 'No, Stay',
                    textcolor: Colors.black,
                    buttoncolor: Color.fromARGB(255, 241, 244, 245),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                  _buildDialogButton(
                    context,
                    label: 'Yes, Close Page',
                    textcolor: Colors.white,
                    buttoncolor: Color.fromARGB(255, 185, 18, 17),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                      context.pop(); // Navigate back to the previous page
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogButton(BuildContext context,
      {required String label,
      required Color buttoncolor,
      required Color textcolor,
      required VoidCallback onPressed}) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: buttoncolor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          color: textcolor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
