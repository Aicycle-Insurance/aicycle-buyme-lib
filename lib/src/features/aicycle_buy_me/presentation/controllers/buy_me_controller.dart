import 'package:aicycle_buyme_plus/aicycle_buyme_plus.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../domain/use_cases/create_buyme_folder_use_case.dart';

/// Enum representing the different sections of the car capture process.
enum CarCaptureSectionType { regCert, regStamp, vinNumber, taplo, exterior }

/// Status of the BuyMe folder creation or initialization process.
enum BuyMeStatus { initial, loading, success, error }

/// Main controller for the BuyMe flow.
/// Orchestrates folder creation, image management for all sections,
/// and synchronization with the backend.
class BuyMeController extends ChangeNotifier {
  final CreateBuyMeFolderUseCase _createBuyMeFolderUseCase;

  BuyMeController({CreateBuyMeFolderUseCase? createBuyMeFolderUseCase})
    : _createBuyMeFolderUseCase =
          createBuyMeFolderUseCase ?? sl.createBuyMeFolderUseCase;

  BuyMeStatus _status = BuyMeStatus.initial;
  BuyMeStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // Internal lists for each document section
  final List<String> _regCertImages = ['', ''];
  final List<String> _regStampImages = [''];
  final List<String> _vinNumberImages = [''];
  final List<String> _taploImages = [''];

  /// Exterior images categorized by vehicle angle for precise tracking.
  final Map<AicycleCarAngle, List<String>> _exteriorImages = {};

  List<String> get regCertImages => List.unmodifiable(_regCertImages);
  List<String> get regStampImages => List.unmodifiable(_regStampImages);
  List<String> get vinNumberImages => List.unmodifiable(_vinNumberImages);
  List<String> get taploImages => List.unmodifiable(_taploImages);

  /// Returns the full map of exterior images keyed by vehicle angle.
  Map<AicycleCarAngle, List<String>> get exteriorImagesMap =>
      Map.unmodifiable(_exteriorImages);

  /// Returns a flat list of all exterior images for general display.
  List<String> get exteriorImages =>
      _exteriorImages.values.expand((element) => element).toList();

  /// Adds an image to a specific section.
  /// For [CarCaptureSectionType.exterior], the [vehicleAngle] is required.
  void addImage(
    CarCaptureSectionType type,
    String path, {
    int index = 0,
    AicycleCarAngle? vehicleAngle,
  }) {
    switch (type) {
      case CarCaptureSectionType.regCert:
        _regCertImages[index] = path;
        break;
      case CarCaptureSectionType.regStamp:
        _regStampImages[index] = path;
        break;
      case CarCaptureSectionType.vinNumber:
        _vinNumberImages[index] = path;
        break;
      case CarCaptureSectionType.taplo:
        _taploImages[index] = path;
        break;
      case CarCaptureSectionType.exterior:
        if (vehicleAngle != null) {
          final list = _exteriorImages[vehicleAngle] ?? [];
          if (!list.contains(path)) {
            list.add(path);
            _exteriorImages[vehicleAngle] = list;
          }
        }
        break;
    }
    notifyListeners();
  }

  /// Removes an image from a specific section.
  /// If [path] is provided, it searches and removes that specific entry (useful for exterior).
  void removeImage(
    CarCaptureSectionType type, {
    int index = 0,
    AicycleCarAngle? vehicleAngle,
    String? path,
  }) {
    switch (type) {
      case CarCaptureSectionType.regCert:
        _regCertImages[index] = '';
        break;
      case CarCaptureSectionType.regStamp:
        _regStampImages[index] = '';
        break;
      case CarCaptureSectionType.vinNumber:
        _vinNumberImages[index] = '';
        break;
      case CarCaptureSectionType.taplo:
        _taploImages[index] = '';
        break;
      case CarCaptureSectionType.exterior:
        if (vehicleAngle != null) {
          if (path != null) {
            _exteriorImages[vehicleAngle]?.remove(path);
          } else {
            final list = _exteriorImages[vehicleAngle];
            if (list != null && list.length > index) {
              list.removeAt(index);
            }
          }
        }
        break;
    }
    notifyListeners();
  }

  Future<void> refresh() async {
    // Simulate data fetching
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  void submit() {
    // TODO: implement submission logic
  }

  /// Create new or get existing AiCycle document
  Future<void> init(AiCycleConfig config) async {
    try {
      _status = BuyMeStatus.loading;
      _errorMessage = '';
      notifyListeners();

      // Set global configuration
      AiCycleBuyMe.configInternal = config;
      final carInfo = config.carInformation;

      await _createBuyMeFolderUseCase(
        CreateBuyMeFolderParams(
          externalClaimId: config.documentId,
          claimName: config.documentName ?? config.documentId,
          vehicleBrandId: '5',
          priceTypeId: 10,
          isClaim: false,
          brand: carInfo.brand,
          model: carInfo.model,
          vehicleYear: carInfo.vehicleYear,
          vehicleSpec: carInfo.vehicleSpec,
          licensePlate: carInfo.licensePlate,
          vehicleType: carInfo.vehicleType ?? 'truck',
          hasLicensePlate: carInfo.licensePlate?.isNotEmpty == true,
        ),
      );

      _status = BuyMeStatus.success;
      notifyListeners();
    } catch (e) {
      _status = BuyMeStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> getDocumentDetails() async {}
}
