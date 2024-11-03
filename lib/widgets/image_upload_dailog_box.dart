// image_upload_dialog.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jewlease/providers/image_provider.dart';
import 'package:jewlease/widgets/image_data.dart';
import 'package:jewlease/widgets/image_list.dart';
// Ensure you import the image provider

class ImageUploadDialog extends ConsumerStatefulWidget {
  const ImageUploadDialog({super.key});

  @override
  ImageUploadDialogState createState() => ImageUploadDialogState();
}

class ImageUploadDialogState extends ConsumerState<ImageUploadDialog> {
  Uint8List? _selectedImage;
  String _imageType = 'CATALOGUE'; // default value
  String _description = '';
  bool _isDefault = false;

  final List<String> _imageTypes = [
    'CATALOGUE',
    'BACK_IMAGE',
    'EXTERNAL SOURCE',
    'FRONT VIEW',
    'MANUFACTURING',
    'MISCELLANEOUS',
    'OTHER IMAGE',
    'SEARCH RESULT PAGE',
    'SIDE VIEW',
    'STANDARD FOR PRODUCT DETAIL PAGE',
    'TOP VIEW',
    'VIDEO',
    'ZOOMED FOR PRODUCT DETAILED PAGE',
  ];

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _selectedImage = result.files.single.bytes;
      });
    }
  }

  void _saveImage() {
    if (_selectedImage != null) {
      ref.read(imageProvider.notifier).addImage(
            ImageModel(
              imageData: _selectedImage!,
              type: _imageType,
              description: _description,
              isDefault: _isDefault,
            ),
          );
      Navigator.of(context).pop(); // Close the dialog after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imageProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 600,
        height: 650,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.grey.shade100,
                  ),
                  child: Center(
                    child: _selectedImage == null
                        ? const Icon(Icons.upload, size: 50)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                Image.memory(_selectedImage!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _imageType,
                decoration: const InputDecoration(labelText: 'Image Type'),
                items: _imageTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _imageType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Description'),
                onChanged: (value) {
                  _description = value;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isDefault,
                    onChanged: (value) {
                      setState(() {
                        _isDefault = value!;
                      });
                    },
                  ),
                  const Text('Set As Default'),
                ],
              ),
              ElevatedButton(
                onPressed: _saveImage,
                child: const Text('Save'),
              ),
              const Divider(height: 24),
              Expanded(
                child: ImageList(images: images),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
