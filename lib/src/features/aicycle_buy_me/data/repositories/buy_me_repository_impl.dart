import '../../domain/entities/directional_image.dart';
import '../../domain/repositories/buy_me_repository.dart';
import '../../../../core/utils/internal_cache.dart';
import '../data_sources/buy_me_remote_data_source.dart';
import '../mapper/directional_image_mapper.dart';
import '../models/buy_folder_model.dart';

class BuyMeRepositoryImpl implements BuyMeRepository {
  final BuyMeRemoteDataSource _remoteDataSource;

  BuyMeRepositoryImpl(this._remoteDataSource);

  @override
  Future<String> createNewAiCycleDocument({
    required String externalClaimId,
    String? claimName,
    String? vehicleBrandId,
    int? priceTypeId,
    bool? isClaim,
    String? brand,
    String? model,
    int? vehicleYear,
    String? vehicleSpec,
    String? licensePlate,
    String? vehicleType,
    bool? hasLicensePlate,
    String? color,
  }) async {
    final Map<String, dynamic> data = {
      'externalClaimId': externalClaimId,
      'claimName': claimName,
      'vehicleBrandId': vehicleBrandId,
      'priceTypeId': priceTypeId,
      'isClaim': isClaim,
      'vehicleBrandName': ?brand,
      'vehicleModel': ?model,
      'vehicleYear': vehicleYear,
      'vehicleSpec': vehicleSpec,
      'vehicleLicensePlates': licensePlate,
      'vehicleType': vehicleType,
      'hasLicensePlate': hasLicensePlate,
      'carColor': color,
    };

    try {
      final model = await _remoteDataSource.createBuyFolder(data);
      return _processResponse(model);
    } catch (e) {
      if (e.toString().toLowerCase().contains('duplicate')) {
        final model = await _remoteDataSource.getDuplicateFolder(
          externalClaimId,
        );
        return _processResponse(model);
      }
      rethrow;
    }
  }

  String _processResponse(BuyMeFolderModel model) {
    final id = model.claimId?.toString() ?? '';
    InternalCache.claimId = id;
    InternalCache.resultsAvailable = model.resultsAvailable ?? false;
    return id;
  }

  @override
  Future<List<DirectionalImage>> getDirectionalImages({
    required String claimId,
    required String angleId,
  }) async {
    final models = await _remoteDataSource.getDirectionalImages(
      claimId: claimId,
      angleId: angleId,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<String> getValidationResult({required String claimId}) {
    return _remoteDataSource.getValidationResult(claimId: claimId);
  }

  @override
  Future<void> getClaimFolderById(String claimId) async {
    final model = await _remoteDataSource.getClaimFolderById(claimId);
    InternalCache.resultsAvailable = model.resultsAvailable ?? false;
  }
}
