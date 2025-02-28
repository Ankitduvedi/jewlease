// image_provider.dart

import 'dart:convert';
import 'dart:developer';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jewlease/core/routes/constant.dart';
import 'package:jewlease/data/model/failure.dart';
import 'package:jewlease/widgets/image_data.dart';

class ImageNotifier extends StateNotifier<List<ImageModel>> {
  ImageNotifier() : super([]);

  void addImage(ImageModel newImage) {
    if (newImage.isDefault) {
      // Unmark any previously default image
      state = state
          .map((image) =>
              image.isDefault ? image.copyWith(isDefault: false) : image)
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

  Future<Either<Failure, String>> uploadImage(ImageModel image) async {
    final uri = Uri.parse('$url2/ItemMasterAndVariants/upload/');

    var request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes('image', image.imageData,
          filename: '${DateTime.timestamp.toString()}.jpeg'));

    try {
      final response = await request.send();
      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        if (data['url'] != null) {
          // Add the uploaded image URL to the model
          log('img url =${data['url']}');
          image.url = data['url'];
          return right(data['url']);
        } else {
          return left(Failure(message: "URL is empty: ${response.statusCode}"));
        }
      } else {
        log("Failed to upload image. Status code: ${response.statusCode}");
        return left(Failure(
            message:
                "Failed to upload image. Status code: ${response.statusCode}"));
      }
    } catch (e) {
      log("Error uploading image: $e");
      return left(Failure(message: e.toString()));
    }
  }
}

final imageProvider = StateNotifierProvider<ImageNotifier, List<ImageModel>>(
  (ref) => ImageNotifier(),
);
