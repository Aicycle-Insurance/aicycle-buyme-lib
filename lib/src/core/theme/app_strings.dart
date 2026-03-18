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
  static const String captureGuide = "Hướng dẫn chụp";
  static const String position = "Vị trí";
  static const String requirement = "Yêu cầu";
  static const String samplePhoto = "Ảnh mẫu";
  static const String capturePhoto = "Chụp ảnh";
  static const String captureCarPhoto = "Chụp ảnh xe";

  // Car Corners
  static const String front = "Góc trước";
  static const String frontLeft = "Góc trước bên trái";
  static const String frontRight = "Góc trước bên phải";
  static const String rear = "Góc sau";
  static const String rearLeft = "Góc sau bên trái";
  static const String rearRight = "Góc sau bên phải";
  static const String regStamp = "Góc tem đăng kiểm";
  static const String vinNumber = "Góc số khung";
  static const String taplo = "Góc taplo";
  static const String regCert = "Góc đăng kiểm";

  static const String captureCarGuideTitle = "Hướng dẫn chụp ảnh xe";
  static const String captureCarGuideClear =
      "Hình ảnh rõ ràng, không bị mờ, rung lắc";
  static const String captureCarGuideLight = "Không gian đủ ánh sáng";
  static const String captureCarGuideClean = "Xe sạch sẽ, tránh các vết bẩn";

  static const String frontCaptureTitle = "Chụp ảnh góc trước xe";
  static const String frontCaptureDescription =
      "Là ảnh chụp chính diện đầu xe. Yêu cầu chụp đầy đủ các bộ phận như ảnh mẫu";

  static const String frontLeftCaptureTitle =
      "Chụp góc trước trái (Bên ghế lái)";
  static const String frontLeftCaptureDescription =
      "Là các ảnh chụp ở phần góc trước ghế lái. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu";

  static const String frontRightCaptureTitle =
      "Chụp góc trước phải (Bên ghế phụ)";
  static const String frontRightCaptureDescription =
      "Là các ảnh chụp ở phần góc trước ghế phụ. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu";

  static const String rearCaptureTitle = "Chụp ảnh góc sau xe";
  static const String rearCaptureDescription =
      "Là ảnh chụp ở phần chính diện đuôi xe. Yêu cầu chụp chính diện và đầy đủ đuôi xe như ảnh mẫu";

  static const String rearLeftCaptureTitle = "Chụp góc sau trái (Bên ghế lái)";
  static const String rearLeftCaptureDescription =
      "Là các ảnh chụp ở phần góc sau ghế lái. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu";

  static const String rearRightCaptureTitle = "Chụp góc sau phải (Bên ghế phụ)";
  static const String rearRightCaptureDescription =
      "Là các ảnh chụp ở phần góc sau ghế phụ. Yêu cầu phải thấy đầy đủ các bộ phận như trong ảnh mẫu";

  static const String leftCaptureTitle = "Chụp ảnh sườn trái xe (bên ghế lái)";
  static const String leftCaptureDescription =
      "Là các ảnh chụp ở sườn trái xe, yêu cầu chụp đầy đủ Cánh cửa trước và sau, Kính cánh cửa trước và sau";

  static const String rightCaptureTitle = "Chụp ảnh sườn phải xe (bên ghế phụ)";
  static const String rightCaptureDescription =
      "Là các ảnh chụp ở sườn phải xe, yêu cầu chụp đầy đủ Cánh cửa trước và sau, Kính cánh cửa trước và sau";

  static String deleteImageTitle(int count) => "Xóa $count ảnh";
  static const String deleteImageMessage =
      "Bạn có chắc chắn muốn xóa những ảnh này không? Hành động này không thể hoàn tác.";
}
