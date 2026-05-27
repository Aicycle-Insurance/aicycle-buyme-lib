import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/extension/car_angle_ext.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/buy_folder_model.dart';
import '../models/directional_image_model.dart';

abstract class BuyMeRemoteDataSource {
  Future<BuyMeFolderModel> createBuyFolder(Map<String, dynamic> data);
  Future<BuyMeFolderModel> getDuplicateFolder(String externalId);
  Future<List<DirectionalImageModel>> getDirectionalImages({
    required String claimId,
    required String angleId,
  });

  Future<BuyMeFolderModel> getClaimFolderById(String claimId);

  Future<String> getValidationResult({required String claimId});
}

class BuyMeRemoteDataSourceImpl implements BuyMeRemoteDataSource {
  final DioClient _dioClient;

  BuyMeRemoteDataSourceImpl(this._dioClient);

  @override
  Future<BuyMeFolderModel> createBuyFolder(Map<String, dynamic> data) async {
    final response = await _dioClient.post<dynamic>(
      ApiEndpoints.createClaimDocument,
      data: data,
    );
    return BuyMeFolderModel.fromDynamic(response);
  }

  @override
  Future<BuyMeFolderModel> getDuplicateFolder(String externalId) async {
    final response = await _dioClient.get<dynamic>(
      ApiEndpoints.createClaimDocument,
      queryParameters: {'externalClaimId': externalId},
    );
    return BuyMeFolderModel.fromDynamic(response);
  }

  @override
  Future<List<DirectionalImageModel>> getDirectionalImages({
    required String claimId,
    required String angleId,
  }) async {
    final response = await _dioClient.get<dynamic>(
      ApiEndpoints.directionalImages,
      queryParameters: {'direction': angleId, 'claimId': claimId},
    );
    return DirectionalImagesResponse.fromJson(
      response as Map<String, dynamic>,
    ).images;
  }

  @override
  Future<String> getValidationResult({required String claimId}) async {
    final response = await _dioClient.post<dynamic>(
      ApiEndpoints.getValidationResult,
      data: {'claimId': claimId, 'direction': AicycleCarAngle.exterior.id},
    );
    if (response['message'] != null) {
      return response['message'] as String;
    }
    return '';
  }

  @override
  Future<BuyMeFolderModel> getClaimFolderById(String claimId) async {
    final response = await _dioClient.get<dynamic>(
      ApiEndpoints.getClaimDocumentById(claimId),
    );
    return BuyMeFolderModel.fromDynamic(response);
  }
}
