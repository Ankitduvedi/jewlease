// image_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/widgets/image_data.dart';


class ImageNotifier extends StateNotifier<List<ImageModel>> {
  ImageNotifier() : super([]);

  void addImage(ImageModel newImage) {
    if (newImage.isDefault) {
      // Unmark any previously default image
      state = state
          .map((image) => image.isDefault
              ? image.copyWith(isDefault: false)
              : image)
          .toList();
    }
    state = [...state, newImage];
  }

  void removeImage(int index) {
    final imageToRemove = state[index];
    state = [...state]..removeAt(index);

    // If the removed image was default, optionally set another image as default
    if (imageToRemove.isDefault && state.isNotEmpty) {
      state = [
        ...state.sublist(0, 0),
        state.first.copyWith(isDefault: true),
        ...state.sublist(1),
      ];
    }
  }

  void setDefault(int index) {
    state = state.asMap().entries.map((entry) {
      final i = entry.key;
      final img = entry.value;
      if (i == index) {
        return img.copyWith(isDefault: true);
      } else if (img.isDefault) {
        return img.copyWith(isDefault: false);
      } else {
        return img;
      }
    }).toList();
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, List<ImageModel>>(
  (ref) => ImageNotifier(),
);
