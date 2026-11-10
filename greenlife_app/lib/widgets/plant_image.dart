import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:greenlife_app/services/image_service.dart';

Widget plantImage(
  String source, {
  double? width,
  double? height,
  BoxFit fit = BoxFit.cover,
  required Widget Function() placeholder,
}) {
  if (source.startsWith('assets/')) {
    return Image.asset(
      source,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }

  if (source.startsWith('data:')) {
    final comma = source.indexOf(',');
    if (comma == -1) return placeholder();

    try {
      return Image.memory(
        base64Decode(source.substring(comma + 1)),
        width: width,
        height: height,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => placeholder(),
      );
    } catch (_) {
      return placeholder();
    }
  }

  if (source.startsWith(ImageService.localPrefix)) {
    final file = ImageService.instance.resolve(source);
    if (file == null) return placeholder();

    return Image.file(
      file,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => placeholder(),
    );
  }

  return Image.network(
    source,
    width: width,
    height: height,
    fit: fit,
    loadingBuilder: (context, child, progress) {
      return progress == null ? child : placeholder();
    },
    errorBuilder: (context, error, stackTrace) => placeholder(),
  );
}
