class InternalCache {
  InternalCache._();

  /// ID của hồ sơ hiện tại (buyMeFolderId)
  static String? folderId;

  /// Xóa cache khi reset SDK hoặc logout
  static void clear() {
    folderId = null;
  }
}
