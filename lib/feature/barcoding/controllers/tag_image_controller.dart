import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Notifier to manage the list of Files
class tagImgListNotifier extends Notifier<File?> {
  @override
  File? build() {
    // Initialize the list as empty
    return null;
  }

  // Function to add a file to the list
  void addFile(File file) {
    state = file; // Create a new list with the new file appended
  }
}

// Provider for the Notifier
final tagImgListProvider =
    NotifierProvider<tagImgListNotifier, File?>(tagImgListNotifier.new);
