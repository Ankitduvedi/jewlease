import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jewlease/core/routes/go_router.dart';
import 'package:jewlease/feature/search_box/controller/search_box_controller.dart';

class SearchBox extends ConsumerStatefulWidget {
  const SearchBox({super.key});

  @override
  ConsumerState<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends ConsumerState<SearchBox> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return; // Prevent multiple overlays

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final filteredPages = ref.watch(filteredPagesProvider);
        final query = ref.watch(searchQueryProvider);

        if (query.isEmpty || filteredPages.isEmpty) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: [
            // Close overlay when tapping outside
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  ref.read(searchQueryProvider.notifier).state = "";
                  _removeOverlay();
                },
              ),
            ),

            // Search results dropdown
            Positioned(
              width: MediaQuery.of(context).size.width * 0.5,
              child: CompositedTransformFollower(
                link: _layerLink,
                offset: const Offset(0, 50),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredPages.length,
                      separatorBuilder: (context, index) =>
                          Divider(color: Colors.grey.shade300, height: 1),
                      itemBuilder: (context, index) {
                        final page = filteredPages[index];
                        return ListTile(
                          title: Text(page.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          leading: const Icon(Icons.arrow_forward_ios,
                              size: 18, color: Colors.black54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          onTap: () {
                            goRouter.push(page.route);
                            //context.push(page.route);
                            Future.microtask(() {
                              ref.read(searchQueryProvider.notifier).state = "";
                              _removeOverlay();
                              _focusNode.unfocus();
                            });
                          },
                          hoverColor: Colors.grey.shade200,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: SizedBox(
        width: 260,
        child: TextField(
          focusNode: _focusNode,
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
            if (value.isNotEmpty) {
              _showOverlay(context);
            } else {
              _removeOverlay();
            }
          },
          cursorColor: Colors.black,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.grey.shade100,
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
