import 'package:aicycle_buyme_plus/src/core/theme/app_strings.dart';

enum AiCycleEnvironment { develop, stage, production }

enum AiCycleOrg { aicycle, partner, others }

enum AicycleCarAngle {
  /// Góc trước
  front,

  /// Góc trước bên trái
  frontLeft,

  /// Góc trước bên phải
  frontRight,

  /// Góc sau
  rear,

  /// Góc sau bên trái
  rearLeft,

  /// Góc sau bên phải
  rearRight,

  /// Góc sườn trái
  left,

  /// Góc sườn phải
  right,

  // /// Góc tem đăng kiểm
  regStamp,

  /// Góc số khung
  vinNumber,

  /// Góc taplo
  taplo,

  /// Tổng thể
  regCert,

  /// Góc ngoại thất - dùng cho capture nhiều góc ngoại thất liên tiếp.
  exterior,
}

const Map<AicycleCarAngle, String> _kdefaultCarCornersWithDisplayName = {
  AicycleCarAngle.front: AppStrings.front,
  AicycleCarAngle.frontLeft: AppStrings.frontLeft,
  AicycleCarAngle.frontRight: AppStrings.frontRight,
  AicycleCarAngle.rear: AppStrings.rear,
  AicycleCarAngle.rearLeft: AppStrings.rearLeft,
  AicycleCarAngle.rearRight: AppStrings.rearRight,
  AicycleCarAngle.regStamp: AppStrings.regStamp,
  AicycleCarAngle.vinNumber: AppStrings.vinNumber,
  AicycleCarAngle.taplo: AppStrings.taplo,
  AicycleCarAngle.regCert: AppStrings.regCert,
};

/// Public configuration for the AiCycle BuyMe SDK.
class AiCycleConfig {
  /// Thông tin xe
  final CarInformation carInformation;

  /// Cấu hình validation
  final ValidationConfig? validationConfig;

  final GeneralConfig generalConfig;

  const AiCycleConfig({
    required this.carInformation,
    required this.generalConfig,
    this.validationConfig = const ValidationConfig(
      isPartOfCarValidation: true,
      isTheSameCarValidation: true,
    ),
  });
}

class GeneralConfig {
  /// Token API
  final String apiToken;

  /// ID của hồ sơ
  final String documentId;

  /// Tên của hồ sơ
  final String? documentName;

  /// Môi trường
  final AiCycleEnvironment environment;

  /// Hiển thị màn hình kết quả
  final bool? showResultScreen;

  /// Cho phép log hay không
  final bool loggingEnabled;

  final AiCycleOrg organization;

  GeneralConfig({
    required this.apiToken,
    required this.documentId,
    required this.organization,
    this.environment = AiCycleEnvironment.develop,
    this.documentName,
    this.showResultScreen = true,
    this.loggingEnabled = true,
  });
}

class CarInformation {
  /// Hãng xe (ví dụ: "mazda")
  final String brand;

  /// Dòng xe/Hiệu xe (ví dụ: "mazda.bt_50")
  final String model;

  /// Năm sản xuất (ví dụ: 2022)
  final int? vehicleYear;

  /// Spec xe (ví dụ: "luxury_1_9l_4x2_at")
  final String? vehicleSpec;

  /// Biển số xe (ví dụ: "30A1983")
  /// Nếu không có thì coi như hồ sơ không có biển số xe.
  final String? licensePlate;

  /// Loại xe (ví dụ: "pickup")
  final String? vehicleType;

  /// Màu xe (nếu có)
  /// Dạng hex #RRGGBB
  final String? color;

  /// Tên hiển thị của các góc xe
  final Map<AicycleCarAngle, String>? carCornersWithDisplayName;

  CarInformation({
    required this.brand,
    required this.model,
    this.vehicleYear,
    this.vehicleSpec,
    required this.licensePlate,
    this.vehicleType,
    this.color,
    this.carCornersWithDisplayName = _kdefaultCarCornersWithDisplayName,
  });
}

class ValidationConfig {
  final bool isTheSameCarValidation;
  final bool isPartOfCarValidation;

  const ValidationConfig({
    this.isTheSameCarValidation = true,
    this.isPartOfCarValidation = true,
  });
}
