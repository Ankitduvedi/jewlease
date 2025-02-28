import 'dart:io';

import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/tag_image_controller.dart';

class TagImageDialog extends ConsumerStatefulWidget {
  @override
  _TagImageDialogState createState() => _TagImageDialogState();
}

class _TagImageDialogState extends ConsumerState<TagImageDialog> {
  String? _selectedOption;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String _cameraInfo = 'Unknown';
  List<CameraDescription> _cameras = <CameraDescription>[];
  int _cameraIndex = 0;
  int _cameraId = -1;
  bool _initialized = false;
  Size? _previewSize;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _fetchCameras();
  }

  @override
  void dispose() {
    _disposeCurrentCamera();
    super.dispose();
  }

  /// Fetches list of available cameras from camera plugin.
  Future<void> _fetchCameras() async {
    String cameraInfo;
    List<CameraDescription> cameras = <CameraDescription>[];

    int cameraIndex = 0;
    try {
      cameras = await CameraPlatform.instance.availableCameras();
      if (cameras.isEmpty) {
        cameraInfo = 'No available cameras';
      } else {
        cameraIndex = _cameraIndex % cameras.length;
        cameraInfo = 'Found camera: ${cameras[cameraIndex].name}';
      }
    } catch (e) {
      cameraInfo = 'Failed to get cameras:';
    }

    if (mounted) {
      setState(() {
        _cameraIndex = cameraIndex;
        _cameras = cameras;
        _cameraInfo = cameraInfo;
      });
    }
  }

  /// Initializes the camera on the device.
  Future<void> _initializeCamera() async {
    if (_cameras.isEmpty) return;

    int cameraId = -1;
    try {
      final CameraDescription camera = _cameras[_cameraIndex % _cameras.length];
      cameraId = await CameraPlatform.instance.createCameraWithSettings(
        camera,
        MediaSettings(
          resolutionPreset: ResolutionPreset.low,
          fps: 15,
          videoBitrate: 200000,
          audioBitrate: 32000,
          enableAudio: true,
        ),
      );

      await CameraPlatform.instance.initializeCamera(cameraId);

      if (mounted) {
        setState(() {
          _initialized = true;
          _cameraId = cameraId;
        });
      }
    } on CameraException catch (e) {
      if (mounted) {
        setState(() {
          _initialized = false;
          _cameraId = -1;
          _cameraInfo =
              'Failed to initialize camera: ${e.code}: ${e.description}';
        });
      }
    }
  }

  /// Takes a picture and passes the image path back to the parent widget.
  Future<void> _takePicture() async {
    if (_initialized && _cameraId >= 0) {
      final XFile file = await CameraPlatform.instance.takePicture(_cameraId);
      setState(() {
        _image = File(file.path);
      });
      Navigator.of(context).pop();
    }
  }

  /// Disposes the current camera.
  Future<void> _disposeCurrentCamera() async {
    if (_cameraId >= 0 && _initialized) {
      await CameraPlatform.instance.dispose(_cameraId);
      setState(() {
        _initialized = false;
        _cameraId = -1;
      });
    }
  }

  void _pickImageFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _image = File(result.files.single.path!);
      });
    }
    print("calling fun");
    // try {
    //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    //   print("picked file $pickedFile");
    //   if (pickedFile != null) {
    //     setState(() {
    //       _image = File(pickedFile.path);
    //     });
    //   }
    // } catch (e) {
    //   print("error is  $e");
    // }
  }

  void _pickImageFromCamera() async {
    // Fetch cameras and initialize the camera preview when the option is selected
    await _fetchCameras();
    if (_cameras.isNotEmpty) {
      await _initializeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: 600,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Green strip with text and close button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update Image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Radio buttons in a Row
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Upload Image'),
                      value: 'upload',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                          _pickImageFromGallery();
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: Text('Use Camera'),
                      value: 'camera',
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value;
                          _pickImageFromCamera();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Camera preview
            if (_selectedOption == 'camera' && _initialized)
              Expanded(
                child: CameraPlatform.instance.buildPreview(_cameraId),
              ),

            // Image preview
            if (_selectedOption != 'camera')
              Expanded(
                child: Center(
                  child: _image != null
                      ? Image.file(_image!)
                      : Text('No image selected'),
                ),
              ),

            // Capture Image button (if camera is selected)
            if (_selectedOption == 'camera' && _initialized)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _takePicture,
                  child: Text('Capture Image'),
                ),
              ),

            // Update button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(tagImgListProvider.notifier).addFile(_image!);
                    Navigator.of(context).pop();
                    // Handle update logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
