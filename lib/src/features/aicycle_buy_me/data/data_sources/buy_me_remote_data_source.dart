import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/buy_folder_model.dart';
import '../models/directional_image_model.dart';

abstract class BuyMeRemoteDataSource {
  Future<BuyFolderModel> createBuyFolder(Map<String, dynamic> data);
  Future<BuyFolderModel> getDuplicateFolder(String externalId);
  Future<List<DirectionalImageModel>> getDirectionalImages({
    required String claimId,
    required String angleId,
  });
}

class BuyMeRemoteDataSourceImpl implements BuyMeRemoteDataSource {
  final DioClient _dioClient;

  BuyMeRemoteDataSourceImpl(this._dioClient);

  @override
  Future<BuyFolderModel> createBuyFolder(Map<String, dynamic> data) async {
    final response = await _dioClient.post<dynamic>(
      ApiEndpoints.createClaimDocument,
      data: data,
    );
    return BuyFolderModel.fromDynamic(response);
  }

  @override
  Future<BuyFolderModel> getDuplicateFolder(String externalId) async {
    final response = await _dioClient.get<dynamic>(
      ApiEndpoints.createClaimDocument,
      queryParameters: {'externalClaimId': externalId},
    );
    return BuyFolderModel.fromDynamic(response);
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
}
