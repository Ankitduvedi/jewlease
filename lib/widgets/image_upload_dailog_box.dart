import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jewlease/widgets/image_data.dart';

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
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = ref.watch(imageProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SizedBox(
        width: 600,
        height: 600,
        child: Column(
          children: [
            Padding(
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
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: _selectedImage == null
                            ? const Icon(Icons.upload, size: 50)
                            : Image.memory(_selectedImage!, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _imageType,
                    decoration: const InputDecoration(labelText: 'Image Type'),
                    items: const [
                      DropdownMenuItem(
                          value: 'CATALOGUE', child: Text('CATALOGUE')),
                      DropdownMenuItem(
                          value: 'BACK_IMAGE', child: Text('BACK_IMAGE')),
                    ],
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
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _saveImage,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ImageList(images: images),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageList extends ConsumerWidget {
  final List<ImageModel> images;

  const ImageList({super.key, required this.images});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final image = images[index];
        return Stack(
          children: [
            Image.memory(image.imageData),
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
            if (image.isDefault)
              const Positioned(
                bottom: 8,
                right: 8,
                child: Icon(Icons.check_circle, color: Colors.green),
              ),
          ],
        );
      },
    );
  }
}
