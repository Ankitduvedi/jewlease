import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/controller/item_master_and_variant_controller.dart';

class VariantMasterDetail extends ConsumerWidget {
  const VariantMasterDetail({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(selectedMetalDataProvider);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade900, // Background color matching the image
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Metal Code
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Metal Code',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                data.metalCode,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Variant Type
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Variant Type',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                data.exclusiveIndicator ? '1' : '-',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Base Metal Variant
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Base Metal Variant',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                data.description,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Row Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Row Status',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                data.rowStatus,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Created Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Created Date',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                data.createdDate.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Last Modified Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Last Modified Date',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                data.updateDate.toString(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
