/// Defines all constant strings used across the SDK.
///
/// This approach makes it easier to support internationalization (i18n)
/// in the future, or just to keep string values organized in one place
/// instead of hardcoding them in UI components.
class AppStrings {
  AppStrings._();

  static const String package = 'aicycle_buyme_plus';

  // General Actions
  static const String btnDone = 'Hoàn thành';
  static const String btnRetry = 'Thử lại';
  static const String btnCancel = 'Hủy';
  static const String btnClose = 'Đóng';
  static const String btnDelete = 'Xóa';
  static const String btnCaptureMore = 'Chụp thêm';
  static const String btnOtherAngle = 'Chụp góc khác';
  static const String btnRetake = 'Chụp lại';
  static const String btnSave = 'Lưu';
  static const String btnContinue = 'Tiếp tục';

  // Instructions Header
  static const String instructionTitle = 'Hướng dẫn chụp xe';
  static const String instructionClear =
      'Hình ảnh rõ ràng, không bị mờ, rung lắc';
  static const String instructionLight = 'Không gian đủ ánh sáng';
  static const String instructionClean = 'Xe sạch sẽ, tránh các vết bẩn';

  // Photo Capture Cards
  static const String photoRegCert = 'Ảnh đăng kiểm';
  static const String photoRegStamp = 'Ảnh tem đăng kiểm';
  static const String photoVinNumber = 'Ảnh số khung';
  static const String photoTaplo = 'Ảnh taplo';
  static const String photoExterior = 'Ảnh xe ô tô';

  // Miscellaneous
  static const String guide = 'Hướng dẫn';
  static const String errorGeneric = 'Đã có lỗi xảy ra. Vui lòng thử lại sau.';
  static const String errorNetwork = 'Không có kết nối mạng.';
  static const String captureGuide = 'Hướng dẫn chụp ảnh';
  static const String position = 'Vị trí';
  static const String requirement = 'Yêu cầu';
  static const String samplePhoto = 'Ảnh mẫu';
  static const String capturePhoto = 'Chụp ảnh';
  static const String captureCarPhoto = 'Chụp ảnh xe';
  static const String photo = 'Ảnh';

  // Car Corners
  static const String front = 'Trước';
  static const String frontLeft = 'Trước trái';
  static const String frontRight = 'Trước phải';
  static const String rear = 'Sau';
  static const String rearLeft = 'Sau trái';
  static const String rearRight = 'Sau phải';
  static const String left = 'Sườn trái';
  static const String right = 'Sườn phải';
  static const String regStamp = 'Tem đăng kiểm';
  static const String vinNumber = 'Số khung';
  static const String taplo = 'Taplo';
  static const String regCert = 'Đăng kiểm';
  static const String exterior = 'Ngoại thất';
  static const String noDisplayName = 'Góc chưa đặt tên';

  static const String captureCarGuideTitle = 'Hướng dẫn chụp ảnh xe';
  static const String captureCarGuideClear =
      'Hình ảnh rõ ràng, không bị mờ, rung lắc';
  static const String captureCarGuideLight = 'Không gian đủ ánh sáng';
  static const String captureCarGuideClean = 'Xe sạch sẽ, tránh các vết bẩn';

  static String frontCaptureTitle(String displayName) =>
      'Chụp ảnh góc $displayName';
  static const String frontCaptureDescription =
      'Là ảnh chụp chính diện đầu xe. Yêu cầu chụp đầy đủ các bộ phận như ảnh mẫu';

  static String frontLeftCaptureTitle(String displayName) =>
      'Chụp góc $displayName (Bên ghế lái)';
  static const String frontLeftCaptureDescription =
      'Là các ảnh chụp ở phần góc trước ghế lái. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu';

  static String frontRightCaptureTitle(String displayName) =>
      'Chụp góc $displayName (Bên ghế phụ)';
  static const String frontRightCaptureDescription =
      'Là các ảnh chụp ở phần góc trước ghế phụ. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu';

  static String rearCaptureTitle(String displayName) => 'Chụp góc $displayName';
  static const String rearCaptureDescription =
      'Là ảnh chụp ở phần chính diện đuôi xe. Yêu cầu chụp chính diện và đầy đủ đuôi xe như ảnh mẫu';

  static String rearLeftCaptureTitle(String displayName) =>
      'Chụp góc $displayName (Bên ghế lái)';
  static const String rearLeftCaptureDescription =
      'Là các ảnh chụp ở phần góc sau ghế lái. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu';

  static String rearRightCaptureTitle(String displayName) =>
      'Chụp góc $displayName (Bên ghế phụ)';
  static const String rearRightCaptureDescription =
      'Là các ảnh chụp ở phần góc sau ghế phụ. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu';

  static String leftCaptureTitle(String displayName) =>
      'Chụp góc $displayName (Bên ghế lái)';
  static const String leftCaptureDescription =
      'Là các ảnh chụp ở sườn trái xe, yêu cầu chụp đầy đủ Cánh cửa trước và sau, Kính cánh cửa trước và sau';

  static String rightCaptureTitle(String displayName) =>
      'Chụp góc $displayName (Bên ghế phụ)';
  static const String rightCaptureDescription =
      'Là các ảnh chụp ở sườn phải xe, yêu cầu chụp đầy đủ Cánh cửa trước và sau, Kính cánh cửa trước và sau';

  static String deleteImageTitle(int count) => 'Xóa $count ảnh';
  static const String deleteImageMessage =
      'Bạn có chắc chắn muốn xóa những ảnh này không? Hành động này không thể hoàn tác.';

  static const String noImagesFound = 'Không có ảnh';

  static const String noSupportCarAngles =
      'Bạn đang cài đặt không hỗ trợ chụp góc xe nào. Vui lòng kiểm tra lại cấu hình.';

  static const String documentResultTitle = 'Tổng quan';
  static const String carInfo = 'Thông tin xe';
  static const String licensePlate = 'Biển số xe';
  static const String carBrand = 'Hãng xe';
  static const String carModel = 'Hiệu xe';
  static const String carColor = 'Màu xe';
  static const String traveled = 'Số KM đã đi';
  static const String damageStatistics = 'Thống kê vết hỏng';
  static const String notice = 'Lưu ý: ';
  static const String noticeDescription =
      'Các vết hỏng trên xe (nếu có), Bảo hiểm sẽ loại trừ đi khi bồi thường';
  static const String part = 'Bộ phận:';
  static const String damageType = 'Loại tổn thất:';
  static const String sendAndComplete = 'Gửi và hoàn thành';
  static const String noDamage = 'Xe không có vết hỏng';
  static const String startCapture = 'Bắt đầu chụp ảnh';
  static const String firstGuide1 =
      'Hãy bắt đầu bằng việc chụp một bức ảnh tổng thể thấy';
  static const String firstGuide2 = ' rõ nét biển số xe';
  static const String firstGuide3 = ' (từ phía trước hoặc phía sau).';
  static const String openCamera = 'Mở camera';
  static const String error = 'Lỗi';
  static const String isProcessing =
      'Hệ thống đang xử lý dữ liệu.\nVui lòng đợi trong giây lát.';
}
