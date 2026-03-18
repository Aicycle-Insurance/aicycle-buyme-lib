import 'package:camera/camera.dart';
import 'package:native_device_orientation/native_device_orientation.dart';

class XXFile extends XFile {
  final NativeDeviceOrientation orientation;

  XXFile(
    super.path, {
    required this.orientation,
    super.name,
    super.mimeType,
    super.bytes,
    super.lastModified,
    super.length,
  });

  factory XXFile.fromXFile(
    XFile file, {
    required NativeDeviceOrientation orientation,
  }) {
    return XXFile(
      file.path,
      orientation: orientation,
      name: file.name,
      mimeType: file.mimeType,
    );
  }
}
