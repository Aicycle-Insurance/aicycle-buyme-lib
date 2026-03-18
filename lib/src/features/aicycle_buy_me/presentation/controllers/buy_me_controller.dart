import 'package:flutter/material.dart';
import '../../../../aicycle_buyme_plus_impl.dart';
import '../../../../core/di/injection.dart';
import '../../domain/use_cases/create_buyme_folder_use_case.dart';

enum BuyMeStatus { initial, loading, success, error }

class BuyMeController extends ChangeNotifier {
  final CreateBuyMeFolderUseCase _createBuyMeFolderUseCase;

  BuyMeController({CreateBuyMeFolderUseCase? createBuyMeFolderUseCase})
    : _createBuyMeFolderUseCase =
          createBuyMeFolderUseCase ?? sl.createBuyMeFolderUseCase;

  BuyMeStatus _status = BuyMeStatus.initial;
  BuyMeStatus get status => _status;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  final List<String> _regCertImages = [];
  final List<String> _regStampImages = [];
  final List<String> _vinNumberImages = [];
  final List<String> _taploImages = [];
  final List<String> _exteriorImages = [];

  List<String> get regCertImages => List.unmodifiable(_regCertImages);
  List<String> get regStampImages => List.unmodifiable(_regStampImages);
  List<String> get vinNumberImages => List.unmodifiable(_vinNumberImages);
  List<String> get taploImages => List.unmodifiable(_taploImages);
  List<String> get exteriorImages => List.unmodifiable(_exteriorImages);

  Future<void> refresh() async {
    // Simulate data fetching
    await Future.delayed(const Duration(seconds: 1));
    notifyListeners();
  }

  void submit() {
    // TODO: implement submission logic
  }

  Future<void> createNewAiCycleDocument() async {
    try {
      _status = BuyMeStatus.loading;
      _errorMessage = '';
      notifyListeners();

      final config = AiCycleBuyMe.config;
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
      // You might want to store the new document ID if needed
      notifyListeners();
    } catch (e) {
      _status = BuyMeStatus.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
