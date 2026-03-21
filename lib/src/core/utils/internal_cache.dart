class InternalCache {
  InternalCache._();

  /// ID của hồ sơ hiện tại (buyMeFolderId)
  static String? claimId;

  /// Xóa cache khi reset SDK hoặc logout
  static void clear() {
    claimId = null;
  }
}
