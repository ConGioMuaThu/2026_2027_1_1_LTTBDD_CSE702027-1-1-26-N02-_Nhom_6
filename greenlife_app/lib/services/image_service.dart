import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImageService {
  ImageService._();

  static final ImageService instance = ImageService._();

  static const double _maxSize = 1080;
  static const int _quality = 85;
  static const String localPrefix = 'local:';

  final ImagePicker _picker = ImagePicker();
  String? _imagesDir;

  bool get canUseCamera {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  Future<void> init() async {
    if (kIsWeb || _imagesDir != null) return;

    try {
      final base = await getApplicationDocumentsDirectory();
      final dir = Directory('${base.path}${Platform.pathSeparator}images');
      if (!await dir.exists()) await dir.create(recursive: true);
      _imagesDir = dir.path;
    } catch (_) {
      _imagesDir = null;
    }
  }

  File? resolve(String reference) {
    final dir = _imagesDir;
    if (kIsWeb || dir == null || !reference.startsWith(localPrefix)) {
      return null;
    }
    final name = reference.substring(localPrefix.length);
    return File('$dir${Platform.pathSeparator}$name');
  }

  Future<String?> pickAndStore() async {
    final file = await pickFromGallery();
    return file == null ? null : _store(file);
  }

  Future<String?> takeAndStore() async {
    final file = await takePhoto();
    return file == null ? null : _store(file);
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

  Future<String?> _store(XFile file) async {
    try {
      final bytes = await file.readAsBytes();

      if (kIsWeb) {
        final mime = file.mimeType ?? 'image/jpeg';
        return 'data:$mime;base64,${base64Encode(bytes)}';
      }

      await init();
      final dir = _imagesDir;
      if (dir == null) return null;

      final name =
          'img_${DateTime.now().microsecondsSinceEpoch}${_extensionOf(file.path)}';
      await File('$dir${Platform.pathSeparator}$name')
          .writeAsBytes(bytes, flush: true);
      return '$localPrefix$name';
    } catch (_) {
      return null;
    }
  }

  String _extensionOf(String path) {
    final slash = path.lastIndexOf(RegExp(r'[/\\]'));
    final dot = path.lastIndexOf('.');
    if (dot <= slash || dot == -1) return '.jpg';

    final ext = path.substring(dot).toLowerCase();
    return ext.length <= 5 ? ext : '.jpg';
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
