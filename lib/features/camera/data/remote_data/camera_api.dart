import '../../../../network/api_request.dart';
import '../../../../network/endpoints.dart';

class CameraAPI extends APIRequest {
  ///
  CameraAPI.callEngineV2({
    required String claimId,
    required String imageName,
    required String filePath,
    required String position,
    required String direction,
    required String vehiclePartExcelId,
    required bool isCapDon,
    String? resizePath,
    int? oldImageId,
    double? timeAppUpload,
    String? locationName,
    String? uploadLocation,
    String? utcTimeCreated,
    bool? isTruck,
  }) : super(
          endpoint: Endpoint.callEngine,
          method: HTTPMethod.post,
          isLogResponse: true,
          isBaseResponse: false,
          body: {
            "claimId": claimId,
            "imageName": imageName,
            "filePath": filePath,
            "position": position,
            "direction": direction,
            "vehiclePartExcelId": vehiclePartExcelId,
            "oldImageId": oldImageId,
            "timeAppUpload": timeAppUpload,
            "resizePath": resizePath,
            "location": locationName,
            "requestedTime": utcTimeCreated,
            "uploadLocation": uploadLocation,
            "isValidate": true,
            if (isTruck == true) "vehicleType": "truck",
          },
        );

  CameraAPI.getImageUploadUrl({required String serverFilePath})
      : super(
          endpoint: Endpoint.getImageUploadUrl,
          method: HTTPMethod.post,
          isLogResponse: true,
          body: {
            'filePaths': [serverFilePath]
          },
        );

  CameraAPI.validateAfterUploadToS3({required String serverFilePath})
      : super(
            endpoint: Endpoint.validateUpload,
            method: HTTPMethod.post,
            isLogResponse: true,
            body: {'filePath': serverFilePath});

  // CameraAPI.uploadImageToS3Server({required String localFilePath})
  //     : super(
  //         endpoint: Endpoint.callEngine,
  //         method: HTTPMethod.post,
  //         isLogResponse: true,
  //         body: {
  //           "claimId": claimId,
  //           "imageName": imageName,
  //           "filePath": filePath,
  //           "position": position,
  //           "direction": direction,
  //           "vehiclePartExcelId": vehiclePartExcelId,
  //           "oldImageId": oldImageId,
  //           "timeAppUpload": timeAppUpload,
  //           "resizePath": resizePath,
  //           "location": locationName,
  //           "requestedTime": utcTimeCreated,
  //           "uploadLocation": uploadLocation,
  //         },
  //       );
}
