import '../../../../network/api_request.dart';
import '../../../../network/endpoints.dart';

class AicycleBuyMeApi extends APIRequest {
  AicycleBuyMeApi.createFolder({
    required String externalClaimId,
    required String folderName,
    String? vehicleBrandId,
    String? parentId,
    String? vehicleLicensePlates,
    String? carColor,
    String? appUser,
    bool isClaim = true,
    bool? hasLicensePlate = true,
  }) : super(
            endpoint: Endpoint.claimFolders,
            method: HTTPMethod.post,
            isLogResponse: true,
            body: {
              "claimName": folderName,
              "vehicleBrandId": vehicleBrandId,
              if (vehicleLicensePlates != null)
                "vehicleLicensePlates": vehicleLicensePlates,
              "externalClaimId": externalClaimId,
              if (carColor != null) "carColor": carColor,
              if (appUser != null) "appUser": appUser,
              "isClaim": false,
              if (hasLicensePlate != null) "hasLicensePlate": hasLicensePlate,
              if (parentId != null) "parentClaimId": parentId,
            });

  ///
  AicycleBuyMeApi.getDuplicateFolder({
    required String externalClaimId,
  }) : super(
            endpoint: Endpoint.claimFolders,
            method: HTTPMethod.get,
            isLogResponse: true,
            query: {
              "externalClaimId": externalClaimId,
            });
}
