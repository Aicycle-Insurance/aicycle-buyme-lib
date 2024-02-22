import 'package:dartz/dartz.dart';

import '../../../../network/api_error.dart';
import '../../data/models/damage_assessment_response.dart';
import '../repository/camera_repository.dart';

class BuyMeCallEngineUsecase {
  final CameraRepository repository;
  BuyMeCallEngineUsecase(this.repository);

  Future<Either<APIErrors, DamageAssessmentResponse>> call({
    required String claimId,
    required String imageName,
    required String filePath,
    required String position,
    required String direction,
    required String vehiclePartExcelId,
    required bool isCapDon,
    int? oldImageId,
    double? timeAppUpload,
    String? resizePath,
    String? locationName,
    String? uploadLocation,
    String? utcTimeCreated,
  }) async {
    return repository.callAiEngineAfterTakePhotoV2(
      claimId: claimId,
      imageName: imageName,
      filePath: filePath,
      position: position,
      direction: direction,
      vehiclePartExcelId: vehiclePartExcelId,
      isCapDon: isCapDon,
      locationName: locationName,
      oldImageId: oldImageId,
      resizePath: resizePath,
      timeAppUpload: timeAppUpload,
      uploadLocation: uploadLocation,
      utcTimeCreated: utcTimeCreated,
    );
  }
}
