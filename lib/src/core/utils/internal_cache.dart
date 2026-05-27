import '../di/injection.dart';

class InternalCache {
  InternalCache._();

  /// ID của hồ sơ hiện tại (buyMeFolderId)
  static String claimId = '';

  /// Kết quả đánh giá đã có hay chưa
  static bool resultsAvailable = false;

  /// Xóa cache khi reset SDK hoặc logout
  static void clear() {
    claimId = '';
    resultsAvailable = false;
  }

  /// Làm mới toàn bộ tài nguyên khi thoát SDK
  static void resetAll() {
    clear();
    sl.vehicleImageVault.reset();
    sl.validationVault.reset();
  }
}
