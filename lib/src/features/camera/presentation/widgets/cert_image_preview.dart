import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../core/extension/xx_file.dart';
import '../../../../core/utils/screen_utils.dart';

class CertImagePreview extends StatelessWidget {
  const CertImagePreview({super.key, required this.image, required this.onTap});
  final XXFile? image;
  final Function(XXFile) onTap;

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return GestureDetector(
        onTap: () => onTap(image!),
        child: Container(
          width: 48.r,
          height: 48.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: FileImage(File(image!.path)),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.white, width: 1),
          ),
        ),
      );
    }
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: const Icon(Icons.photo, color: Colors.white),
    );
  }
}
