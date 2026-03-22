import '../di/injection.dart';

class InternalCache {
  InternalCache._();

  /// ID của hồ sơ hiện tại (buyMeFolderId)
  static String claimId = '';

  /// Xóa cache khi reset SDK hoặc logout
  static void clear() {
    claimId = '';
  }

  /// Làm mới toàn bộ tài nguyên khi thoát SDK
  static void resetAll() {
    clear();
    sl.vehicleImageVault.reset();
    sl.validationVault.reset();
  }
}
