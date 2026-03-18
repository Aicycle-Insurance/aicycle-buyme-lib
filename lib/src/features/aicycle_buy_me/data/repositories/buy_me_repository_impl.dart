import '../../domain/repositories/buy_me_repository.dart';
import '../../../../core/utils/internal_cache.dart';
import '../data_sources/buy_me_remote_data_source.dart';
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
    required String brand,
    required String model,
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
      'vehicleBrandName': brand,
      'vehicleModel': model,
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

  String _processResponse(BuyFolderModel model) {
    final id = model.claimId ?? model.id ?? model.buyFolderId ?? '';
    InternalCache.folderId = id;
    return id;
  }
}
