import 'dart:io';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:native_device_orientation/native_device_orientation.dart';
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  ImageUtils._();

  static Future<XFile> rotateImageIfNecessary(
    XFile rawImage,
    NativeDeviceOrientation orientation,
  ) async {
    if (orientation == NativeDeviceOrientation.portraitUp) {
      return rawImage;
    }

    // Rotate image physically
    final bytes = await rawImage.readAsBytes();
    img.Image? image = img.decodeImage(bytes);

    if (image != null) {
      int angle = 0;
      switch (orientation) {
        case NativeDeviceOrientation.landscapeLeft:
          angle = -90;
          break;
        case NativeDeviceOrientation.landscapeRight:
          angle = 90;
          break;
        case NativeDeviceOrientation.portraitDown:
          angle = 0;
          break;
        default:
          break;
      }

      if (angle != 0) {
        image = img.copyRotate(image, angle: angle);
        final rotatedBytes = img.encodeJpg(image);
        final tempDir = await getTemporaryDirectory();
        final file = await File(
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
        ).create();
        await file.writeAsBytes(rotatedBytes);
        return XFile(file.path);
      }
    }
    return rawImage;
  }
}
