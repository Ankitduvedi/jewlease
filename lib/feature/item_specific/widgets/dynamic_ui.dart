import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/feature/item_specific/widgets/left_side_pannel_load_data_widget.dart';

class DynamicItemDetailsScreen extends ConsumerWidget {
  const DynamicItemDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedItem = ref.watch(selectedItemDataProvider);

    if (selectedItem == null) {
      return const Center(child: Text('No item selected'));
    }

    final imageDetails = selectedItem['Image Details'];
    List<Map<String, dynamic>> imageList = [];
    if (imageDetails is List) {
      imageList = List<Map<String, dynamic>>.from(imageDetails);
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (imageList.isNotEmpty) _buildImageCarousel(context, imageList),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: _buildDetailsGrid(context, selectedItem),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(
      BuildContext context, List<Map<String, dynamic>> imageList) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 220,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            autoPlayInterval: const Duration(seconds: 4),
          ),
          items: imageList.map((image) {
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () => _showImageDialog(context, image['url']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          Image.network(
                            image['url'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            loadingBuilder: (context, child, progress) =>
                            progress == null
                                ? child
                                : Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey.shade300,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.image_not_supported, size: 40),
                                      SizedBox(height: 8),
                                      Text('Failed to load image'),
                                    ],
                                  ),
                                ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.7),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Text(
                                image['description'] ?? 'No Description',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDetailsGrid(BuildContext context, Map<String, dynamic> item) {
    final entries = item.entries.toList();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: entries.map((entry) {
        final key = entry.key;
        final value = entry.value.toString();

        return _buildDetailCard(context, key, value);
      }).toList(),
    );
  }

  Widget _buildDetailCard(BuildContext context, String key, String value) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      key,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.blueGrey.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tooltip(
                    message: 'Copy to clipboard',
                    child: IconButton(
                      icon: Icon(Icons.copy_all,
                          size: 18, color: Colors.blueGrey.shade400),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: value));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Copied $key to clipboard'),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade800,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 0.5,
          maxScale: 4.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}