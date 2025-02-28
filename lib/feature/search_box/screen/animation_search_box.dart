import 'package:flutter/material.dart';

class AnimatedSearchBox extends StatelessWidget {
  final Widget child;
  final bool showResults;

  const AnimatedSearchBox({
    super.key,
    required this.child,
    required this.showResults,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          if (showResults) const Divider(height: 20, thickness: 1),
          if (showResults) const SizedBox(height: 10),
        ],
      ),
    );
  }
}
