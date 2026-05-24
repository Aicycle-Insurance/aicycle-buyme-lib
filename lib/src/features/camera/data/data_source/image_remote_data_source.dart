import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../../aicycle_buyme_plus.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/get_upload_url_response.dart';
import '../models/upload_vehicle_inspection_response.dart';

abstract class ImageRemoteDataSource {
  Future<CertUploadResponse> uploadVehicleInspection({
    required List<String> imagePaths,
    required String claimId,
  });

  Future<UploadVehicleInspectionResponse> uploadImage({
    required String imagePath,
    required String claimId,
    String? angleId,
    bool isFramedPhoto = false,
    String? locationName, // địa diểm chụp ảnh hoặc lấy từ metadata ảnh
    String? uploadLocation, // địa điểm upload
    String? utcTimeCreated, // thời gian tạo ảnh (lấy từ metadata ảnh)
  });

  Future<void> deleteImageById(List<int> imageIds, String? vehicleAngleId);
}

class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final DioClient _dioClient;
  ImageRemoteDataSourceImpl(this._dioClient);

  @override
  Future<CertUploadResponse> uploadVehicleInspection({
    required List<String> imagePaths,
    required String claimId,
  }) async {
    final config = AiCycleBuyMe.config;
    final multipartFiles = await Future.wait(
      imagePaths.map((path) => _dioClient.createMultipartFile(path)),
    );

    final formData = await _dioClient.createFormData({
      'img': multipartFiles,
      'claimId': claimId,
      "isValidate": config.validationConfig.sameCarValidation,
      "carCompany": config.carInformation?.carCompanyId,
      "carModel": config.carInformation?.carModelId,
      "licensePlate": config.carInformation?.licensePlate,
    });

    final response = await _dioClient.post<dynamic>(
      ApiEndpoints.uploadVehicleInspection,
      data: formData,
    );
    return CertUploadResponse.fromJson(response);
  }

  @override
  Future<UploadVehicleInspectionResponse> uploadImage({
    required String imagePath,
    required String claimId,
    String? angleId,
    bool isFramedPhoto = false,
    String? locationName,
    String? uploadLocation,
    String? utcTimeCreated,
  }) async {
    final serverFilePath = _generateServerFilePath(imagePath);

    // 1. Get S3 Upload URL
    final uploadStopwatch = Stopwatch()..start();
    final uploadRes = await _getS3UploadUrl(serverFilePath);
    final uploadItem = (uploadRes.urls != null && uploadRes.urls!.isNotEmpty)
        ? uploadRes.urls!.first
        : null;

    if (uploadItem == null || uploadItem.uploadUrl == null) {
      throw EngineException('Failed to get upload URL', 500);
    }

    // 2. Upload file to S3
    final isUploaded = await _putFileToS3(uploadItem.uploadUrl!, imagePath);
    if (!isUploaded) throw EngineException('Upload failed', 500);

    final finalS3Path = uploadItem.filePath ?? serverFilePath;

    // 3. Validate uploaded image
    final validate = await _validateImage(finalS3Path);
    final timeAppUpload = uploadStopwatch.elapsed.inMilliseconds / 1000.0;
    uploadStopwatch.stop();
    if (validate['claimImageIsValid'] != true) {
      throw EngineException(validate['message'] ?? 'Image is not valid', 500);
    }
    print('timeAppUpload: $timeAppUpload');
    print('locationName: $locationName');
    print('uploadLocation: $uploadLocation');
    print('utcTimeCreated: $utcTimeCreated');
    // 4. Process image
    final response = await _processImage(
      claimId,
      finalS3Path,
      angleId,
      isFramedPhoto,
      timeAppUpload,
      locationName,
      uploadLocation,
      utcTimeCreated,
    );

    return UploadVehicleInspectionResponse.fromJson(response);
  }

  /// Helpers for uploadImage flow
  String _generateServerFilePath(String localPath) {
    final fileName = localPath.split('/').last;
    return 'BUYME/${DateTime.now().millisecondsSinceEpoch}/$fileName';
  }

  Future<GetUploadUrlResponse> _getS3UploadUrl(String serverPath) async {
    final response = await _dioClient.post<dynamic>(
      ApiEndpoints.getImageUploadURL,
      data: {
        'filePaths': [serverPath],
      },
    );
    return GetUploadUrlResponse.fromJson(response);
  }

  Future<bool> _putFileToS3(String url, String localPath) async {
    final file = File(localPath);
    final response = await Dio().put(
      url,
      data: file.openRead(),
      options: Options(
        contentType: "multiple/form-data",
        headers: {"Content-Length": file.lengthSync()},
      ),
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>> _validateImage(String serverPath) async {
    final response = await _dioClient.post<dynamic>(
      ApiEndpoints.validateUploadImage,
      data: {'filePath': serverPath},
    );
    return response;
  }

  Future<dynamic> _processImage(
    String claimId,
    String serverPath,
    String? angleId,
    bool isFramedPhoto,
    double? timeAppUpload,
    String? locationName,
    String? uploadLocation,
    String? utcTimeCreated,
  ) async {
    final config = AiCycleBuyMe.config;
    return _dioClient.post<dynamic>(
      ApiEndpoints.processImage,
      data: {
        'claimId': claimId,
        'filePath': serverPath,
        "imageName": serverPath,
        "position": 'toan-canh-afh4l5',
        "direction": angleId ?? '45-phai-truoc-UoYzs6',
        "isValidate": config.validationConfig.sameCarValidation,
        "isFramedPhoto": isFramedPhoto,
        "carCompany": config.carInformation?.carCompanyId,
        "carModel": config.carInformation?.carModelId,
        "licensePlate": config.carInformation?.licensePlate,
        "timeAppUpload": timeAppUpload,
        "location": locationName,
        "requestedTime": utcTimeCreated,
        "uploadLocation": uploadLocation,
      },
    );
  }

  @override
  Future<void> deleteImageById(
    List<int> imageIds,
    String? vehicleAngleId,
  ) async {
    final ids = List<int>.from(imageIds);
    for (final int imageId in ids) {
      await _dioClient.delete<dynamic>(
        ApiEndpoints.deleteImageById(imageId.toString()),
        queryParameters: vehicleAngleId != null
            ? {'direction': vehicleAngleId}
            : null,
      );
    }
  }
}
