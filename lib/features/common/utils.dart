import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../aicycle_buyme_lib.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:image/image.dart' as img;

import '../../generated/assets.gen.dart';
import '../../network/api_error.dart';
import 'logger.dart';
import 'themes/c_colors.dart';
import 'themes/c_textstyle.dart';

enum SnackBarType { success, error, info, warning }

class Utils {
  Utils._();
  static final Utils instance = Utils._();

  static Future<XFile> compressImage(XFile source, int quality,
      {Function(Size)? imageSizeCallBack, bool fromGallery = false}) async {
    File sourceFile = File(source.path);
    try {
      img.Image? input = await img.decodeJpgFile(source.path);
      // rotate image if android because camera image is landscape
      if (input == null) {
        return source;
      }
      if (Platform.isAndroid && !fromGallery) {
        input = img.copyRotate(input, angle: -90);
      }
      int imageWidth = input.width;
      int imageHeight = input.height;
      input = img.copyResize(
        input,
        width: imageWidth > imageHeight ? 1920 : 1080,
        height: imageWidth > imageHeight ? 1080 : 1920,
        maintainAspect: true,
      );
      final dirPath = (await getTemporaryDirectory()).path;
      final imagePath = '$dirPath/${basename(source.path)}';
      var compressedXFile = XFile.fromData(
        img.encodeJpg(input, quality: quality),
        path: imagePath,
      );
      await compressedXFile.saveTo(imagePath);
      var fileLength = await compressedXFile.length();
      // Nếu vẫn lớn hơn 2MB thì giảm chất lượng ảnh
      if (fileLength > 2000000) {
        return await compressImage(compressedXFile, 90);
      }
      // var compressedSize = await _calculateImageSize(compressedFile);
      logger.i(
        'Resize successfully: ${sourceFile.readAsBytesSync().lengthInBytes / 1000000}MB to ${fileLength / 1000000}MB',
      );
      logger.i(
        'Resize successfully:${imageWidth}x$imageHeight => ${input.width}x${input.height}',
      );
      imageSizeCallBack
          ?.call(Size(input.width.toDouble(), input.height.toDouble()));
      return compressedXFile;
    } catch (e) {
      return source;
    }
  }

  static void dismissKeyboard() => Get.focusScope?.unfocus();

  void showError(
    BuildContext context, {
    String? message,
    APIErrors? error,
    bool? keepCurrentDialogOpen,
    Widget? prefix,
  }) {
    _showSnackBar(
      context,
      message ?? '',
      type: SnackBarType.error,
      prefix: prefix,
    );
  }

  void showSuccess(
    BuildContext context,
    String message, {
    APIErrors? error,
    bool? keepCurrentDialogOpen,
    Widget? prefix,
  }) {
    _showSnackBar(
      context,
      message,
      type: SnackBarType.success,
      prefix: prefix,
    );
  }

  void showWarning(
    BuildContext context,
    String message, {
    APIErrors? error,
    bool? keepCurrentDialogOpen,
    Widget? prefix,
  }) {
    _showSnackBar(
      context,
      message,
      type: SnackBarType.warning,
      prefix: prefix,
    );
  }
}

void _showSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.success,
  int duration = 3,
  Widget? prefix,
}) async {
  Widget icon = const Icon(Icons.check);
  Color color = CColors.greenA500;
  // haptic();
  switch (type) {
    case SnackBarType.success:
      icon = Assets.icons.icCheckFilled.svg(package: packageName);
      color = CColors.greenA500;
      break;
    case SnackBarType.error:
      icon = Assets.icons.icErrorFilled.svg(package: packageName);
      color = CColors.redA500;
      break;
    case SnackBarType.info:
      icon = Assets.icons.icInfoFilled.svg(package: packageName);
      color = CColors.primaryA500;
      break;
    case SnackBarType.warning:
      icon = Assets.icons.icWarningFilled.svg(package: packageName);
      color = CColors.orangeA500;
      break;
    default:
      icon = Assets.icons.icWarningFilled.svg(package: packageName);
      color = CColors.greenA500;
      break;
  }
  if (prefix != null) {
    icon = prefix;
  }
  showTopSnackBar(
    Overlay.of(context),
    GetSnackBar(
      duration: Duration(seconds: duration),
      snackPosition: SnackPosition.TOP,
      backgroundColor: color,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      messageText: Row(
        children: [
          icon,
          const Gap(16),
          Expanded(
            child: Text(
              message,
              style: CTextStyles.baseWhite.s14,
            ),
          )
        ],
      ),
    ),
  );
  // Get.showSnackbar(
  //   GetSnackBar(
  //     duration: Duration(seconds: duration),
  //     snackPosition: SnackPosition.TOP,
  //     backgroundColor: color,
  //     margin: const EdgeInsets.all(16),
  //     borderRadius: 8,
  //     messageText: Row(
  //       children: [
  //         icon,
  //         const Gap(16),
  //         Expanded(
  //           child: Text(
  //             message,
  //             style: CTextStyles.baseWhite.s14,
  //           ),
  //         )
  //       ],
  //     ),
  //   ),
  // );
}
