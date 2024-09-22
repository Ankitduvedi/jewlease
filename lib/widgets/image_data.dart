import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:typed_data';

// specifically for flutter web may we have to change it for desktop application
class ImageModel {
  final Uint8List imageData;
  final String type;
  final String description;
  final bool isDefault;

  ImageModel({
    required this.imageData,
    required this.type,
    required this.description,
    this.isDefault = false,
  });

  ImageModel copyWith({
    Uint8List? imageData,
    String? type,
    String? description,
    bool? isDefault,
  }) {
    return ImageModel(
      imageData: imageData ?? this.imageData,
      type: type ?? this.type,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class ImageNotifier extends StateNotifier<List<ImageModel>> {
  ImageNotifier() : super([]);

  void addImage(ImageModel image) {
    state = [...state, image];
  }

  void removeImage(int index) {
    state = List.from(state)..removeAt(index);
  }

  void setDefault(int index) {
    state = state.map((image) {
      return image == state[index]
          ? image.copyWith(isDefault: true)
          : image.copyWith(isDefault: false);
    }).toList();
  }
}

final imageProvider =
    StateNotifierProvider<ImageNotifier, List<ImageModel>>((ref) {
  return ImageNotifier();
});
