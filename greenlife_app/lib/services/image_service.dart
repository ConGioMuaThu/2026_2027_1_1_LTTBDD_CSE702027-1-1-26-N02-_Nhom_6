import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  ImageService._();

  static final ImageService instance = ImageService._();

  static const double _maxSize = 1080;
  static const int _quality = 85;

  final ImagePicker _picker = ImagePicker();

  bool get canUseCamera {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<XFile?> pickFromGallery() => _pick(ImageSource.gallery);

  Future<XFile?> takePhoto() async {
    if (!canUseCamera) return null;
    return _pick(ImageSource.camera);
  }

  Future<List<XFile>> pickMultipleFromGallery() async {
    try {
      return await _picker.pickMultiImage(
        maxWidth: _maxSize,
        maxHeight: _maxSize,
        imageQuality: _quality,
      );
    } catch (_) {
      return <XFile>[];
    }
  }

  Future<Uint8List?> readBytes(XFile? file) async {
    if (file == null) return null;
    try {
      return await file.readAsBytes();
    } catch (_) {
      return null;
    }
  }

  Future<XFile?> _pick(ImageSource source) async {
    try {
      return await _picker.pickImage(
        source: source,
        maxWidth: _maxSize,
        maxHeight: _maxSize,
        imageQuality: _quality,
      );
    } catch (_) {
      return null;
    }
  }
}