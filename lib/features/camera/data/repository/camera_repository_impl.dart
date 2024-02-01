import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart';

import '../models/damage_assessment_response.dart';
import '../../domain/repository/camera_repository.dart';
import '../../../../network/api_error.dart';
import 'package:dartz/dartz.dart';

import '../models/get_upload_url_response.dart';
import '../models/image_upload_response.dart';
import '../remote_data/camera_api.dart';

class BuyMeCameraRepositoryImpl implements CameraRepository {
  @override
  Future<Either<APIErrors, DamageAssessmentResponse>>
      callAiEngineAfterTakePhotoV2(
          {required String claimId,
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
          String? utcTimeCreated}) async {
    try {
      final res = await CameraAPI.callEngineV2(
        claimId: claimId,
        imageName: imageName,
        filePath: filePath,
        position: position,
        direction: direction,
        vehiclePartExcelId: vehiclePartExcelId,
        oldImageId: oldImageId,
        isCapDon: isCapDon,
        timeAppUpload: timeAppUpload,
        resizePath: resizePath,
        locationName: locationName,
        utcTimeCreated: utcTimeCreated,
        uploadLocation: uploadLocation,
      ).request();
      if (res is List) {
        return right(DamageAssessmentResponse.fromJson(res[0]));
      }
      return right(DamageAssessmentResponse.fromJson(res ?? res[0]));
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError(e.toString()));
      }
    }
  }

  @override
  Future<Either<APIErrors, ImageUploadResponse>> uploadImageToS3Server(
      {required String localFilePath}) async {
    try {
      // get url
      var serverFilePath =
          'INSURANCE/${DateTime.now().millisecondsSinceEpoch}/${basename(localFilePath)}';
      var uploadUrlResponse =
          await CameraAPI.getImageUploadUrl(serverFilePath: serverFilePath)
              .request();
      final uploadUrlRes = GetUploadUrlResponse.fromJson(uploadUrlResponse);
      String? s3FilePath;

      /// upload
      if (uploadUrlRes.urls != null && uploadUrlRes.urls!.isNotEmpty) {
        var uploadEndpoint = uploadUrlRes.urls!.first.uploadUrl ?? '';
        // var imageData = await File(localFilePath).readAsBytes();

        var s3Response = await Dio().put(
          uploadEndpoint,
          data: File(localFilePath).openRead(),
          options: Options(
            contentType: "multiple/form-data",
            headers: {
              "Content-Length": File(localFilePath).lengthSync(),
            },
          ),
        );
        if (s3Response.statusCode == 200) {
          s3FilePath = uploadUrlRes.urls?.first.filePath ?? serverFilePath;
        }
      }

      /// upload thanh cong thi validate
      if (s3FilePath != null && s3FilePath.isNotEmpty) {
        var result = await CameraAPI.validateAfterUploadToS3(
                serverFilePath: serverFilePath)
            .request();
        return Right(ImageUploadResponse.fromJson(result));
      }
      return Left(FetchDataError('Upload image failed'));
    } catch (e) {
      if (e is APIErrors) {
        return Left(e);
      } else {
        return Left(FetchDataError(e.toString()));
      }
    }
  }
}
