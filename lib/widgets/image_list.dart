// image_list.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/providers/image_provider.dart';
import 'image_data.dart'; // Ensure you import the image provider

class ImageList extends ConsumerWidget {
  final List<ImageModel> images;

  const ImageList({super.key, required this.images});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 5 / 4, // Adjust for additional text space
      ),
      itemBuilder: (context, index) {
        final image = images[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            Image.memory(image.imageData, fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            image.type,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                          Text(
                            image.description,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      ref.read(imageProvider.notifier).removeImage(index);
                    },
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
                
                
                   Positioned(
                    bottom: 8,
                    right: 8,
                    child:!image.isDefault ? Radio<bool>(
                        value: true,
                        groupValue: image.isDefault,
                        onChanged: (value) {
                          if (value == true) {
                            ref
                                .read(imageProvider.notifier)
                                .setDefault(index);
                          }
                        },
                      ) : Row(
                    children: [
                      
                      Icon(Icons.check_circle, color: Colors.green),
                      const Text(
                        'Default',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
