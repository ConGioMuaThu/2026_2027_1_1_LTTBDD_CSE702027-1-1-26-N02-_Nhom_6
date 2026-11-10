import 'package:flutter/material.dart';

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
