import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

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

  static Future<XFile> compressImageV2(
    XFile sourceFile,
    int quality, {
    Function(Size)? imageSizeCallBack,
    // bool fromGallery = false,
    int rotate = 0,
  }) async {
    XFile? compressedXFile;
    try {
      // var sourceSize = await _calculateImageSize(sourceFile);
      var decodeImage =
          await decodeImageFromList(await sourceFile.readAsBytes());
      int imageWidth = decodeImage.width;
      int imageHeight = decodeImage.height;
      final Directory extDir = await getTemporaryDirectory();
      final appImageDir =
          await Directory('${extDir.path}/app_images').create(recursive: true);
      final String targetPath =
          '${appImageDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      compressedXFile = await FlutterImageCompress.compressAndGetFile(
        sourceFile.path,
        targetPath,
        quality: quality,
        minHeight: imageHeight > imageWidth ? 1600 : 1080,
        minWidth: imageHeight > imageWidth ? 1080 : 1600,
        // rotate: !fromGallery ? -90 : 0,
        rotate: rotate,
      );
      // Nếu vẫn lớn hơn 2MB thì giảm chất lượng ảnh
      File? compressedFile;
      if (compressedXFile != null) {
        compressedFile = File(compressedXFile.path);
      }
      if (compressedFile == null) {
        return XFile(sourceFile.path);
      } else {
        if (compressedFile.readAsBytesSync().lengthInBytes > 2000000) {
          return await compressImageV2(XFile(compressedFile.path), 90);
        }
      }
      // var compressedSize = await _calculateImageSize(compressedFile);
      final compressedImg =
          await decodeImageFromList(compressedFile.readAsBytesSync());
      logger.i(
        'Resize successfully: ${(await sourceFile.length()) / 1000000}MB to ${compressedFile.readAsBytesSync().lengthInBytes / 1000000}MB',
      );
      logger.i(
        'Resize successfully:${imageWidth}x$imageHeight => ${compressedImg.width}x${compressedImg.height}',
      );
      imageSizeCallBack?.call(Size(
          compressedImg.width.toDouble(), compressedImg.height.toDouble()));
      return XFile(compressedFile.path);
    } catch (e) {
      return sourceFile;
    }
  }

  static void dismissKeyboard() => Get.focusScope?.unfocus();

  static DeviceOrientation getOrientation(AccelerometerEvent event) {
    final x = event.x.abs();
    final y = event.y.abs();
    final z = event.z.abs();

    if (z > x && z > y) {
      return DeviceOrientation.portraitUp;
    }
    DeviceOrientation result = DeviceOrientation.portraitUp;
    if (x > y) {
      result = event.x > 0
          ? DeviceOrientation.landscapeLeft
          : DeviceOrientation.landscapeRight;
    } else {
      result = DeviceOrientation.portraitUp;
    }
    return result;
  }

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
