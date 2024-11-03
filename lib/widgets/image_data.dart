// image_data.dart

import 'dart:typed_data';

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
