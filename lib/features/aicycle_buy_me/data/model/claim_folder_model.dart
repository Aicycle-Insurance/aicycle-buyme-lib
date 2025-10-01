import 'package:equatable/equatable.dart';

class ClaimFolderModel extends Equatable {
  final String? folderId;
  final String? folderName;
  final String? claimName;
  final String? claimId;
  final String? folderIdByOrg;
  final String? assessorName;
  final num? parentClaimId;
  final String? licensePlatesEngine;
  final String? vehicleLicensePlates;
  final num? vehicleBrandId;
  final String? vehicleBrandName;
  final String? extraPrice;
  final String? vehicleName;
  final String? vehicleBrand;
  final String? sceneStreet;
  final String? sceneDistrict;
  final String? sceneCity;
  final bool? deletedFlag;
  final bool? resultsAvailable;
  final bool? hasLicensePlate;
  final String? createdDate;
  final String? createdBy;
  final String? updatedDate;
  final String? updatedBy;
  final String? totalItem;
  final String? externalClaimId;

  const ClaimFolderModel({
    this.folderId,
    this.folderName,
    this.claimName,
    this.claimId,
    this.folderIdByOrg,
    this.assessorName,
    this.parentClaimId,
    this.licensePlatesEngine,
    this.vehicleLicensePlates,
    this.vehicleBrandId,
    this.vehicleBrandName,
    this.extraPrice,
    this.vehicleName,
    this.vehicleBrand,
    this.sceneStreet,
    this.sceneDistrict,
    this.sceneCity,
    this.deletedFlag,
    this.resultsAvailable,
    this.hasLicensePlate,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.totalItem,
    this.externalClaimId,
  });

  factory ClaimFolderModel.fromJson(Map<String, dynamic> json) {
    return ClaimFolderModel(
      folderId: json['folderId']?.toString(),
      folderName: json['folderName']?.toString(),
      claimName: json['claimName']?.toString(),
      claimId: json['claimId']?.toString(),
      folderIdByOrg: json['folderIdByOrg']?.toString(),
      assessorName: json['assessorName']?.toString(),
      parentClaimId: num.tryParse(json['parentClaimId'].toString()),
      licensePlatesEngine: json['licensePlatesEngine']?.toString(),
      vehicleLicensePlates: json['vehicleLicensePlates']?.toString(),
      vehicleBrandId: num.tryParse(json['vehicleBrandId'].toString()),
      vehicleBrandName: json['vehicleBrandName']?.toString(),
      extraPrice: json['extraPrice']?.toString(),
      vehicleName: json['vehicleName']?.toString(),
      vehicleBrand: json['vehicleBrand']?.toString(),
      sceneStreet: json['sceneStreet']?.toString(),
      sceneDistrict: json['sceneDistrict']?.toString(),
      sceneCity: json['sceneCity']?.toString(),
      deletedFlag: json['deletedFlag'].toString().contains('true'),
      resultsAvailable: json['resultsAvailable'].toString().contains('true'),
      hasLicensePlate: json['hasLicensePlate'].toString().contains('true'),
      createdDate: json['createdDate']?.toString(),
      createdBy: json['createdBy']?.toString(),
      updatedDate: json['updatedDate']?.toString(),
      updatedBy: json['updatedBy']?.toString(),
      totalItem: json['totalItem']?.toString(),
      externalClaimId: json['externalClaimId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (folderId != null) 'folderId': folderId,
    if (folderName != null) 'folderName': folderName,
    if (claimName != null) 'claimName': claimName,
    if (claimId != null) 'claimId': claimId,
    if (folderIdByOrg != null) 'folderIdByOrg': folderIdByOrg,
    if (assessorName != null) 'assessorName': assessorName,
    if (parentClaimId != null) 'parentClaimId': parentClaimId,
    if (licensePlatesEngine != null) 'licensePlatesEngine': licensePlatesEngine,
    if (vehicleLicensePlates != null)
      'vehicleLicensePlates': vehicleLicensePlates,
    if (vehicleBrandId != null) 'vehicleBrandId': vehicleBrandId,
    if (vehicleBrandName != null) 'vehicleBrandName': vehicleBrandName,
    if (extraPrice != null) 'extraPrice': extraPrice,
    if (vehicleName != null) 'vehicleName': vehicleName,
    if (vehicleBrand != null) 'vehicleBrand': vehicleBrand,
    if (sceneStreet != null) 'sceneStreet': sceneStreet,
    if (sceneDistrict != null) 'sceneDistrict': sceneDistrict,
    if (sceneCity != null) 'sceneCity': sceneCity,
    if (deletedFlag != null) 'deletedFlag': deletedFlag,
    if (resultsAvailable != null) 'resultsAvailable': resultsAvailable,
    if (hasLicensePlate != null) 'hasLicensePlate': hasLicensePlate,
    if (createdDate != null) 'createdDate': createdDate,
    if (createdBy != null) 'createdBy': createdBy,
    if (updatedDate != null) 'updatedDate': updatedDate,
    if (updatedBy != null) 'updatedBy': updatedBy,
    if (totalItem != null) 'totalItem': totalItem,
    if (externalClaimId != null) 'externalClaimId': externalClaimId,
  };

  ClaimFolderModel copyWith({
    String? folderId,
    String? folderName,
    String? claimName,
    String? claimId,
    String? folderIdByOrg,
    String? assessorName,
    num? parentClaimId,
    String? licensePlatesEngine,
    String? vehicleLicensePlates,
    num? vehicleBrandId,
    String? vehicleBrandName,
    String? extraPrice,
    String? vehicleName,
    String? vehicleBrand,
    String? sceneStreet,
    String? sceneDistrict,
    String? sceneCity,
    bool? deletedFlag,
    bool? resultsAvailable,
    bool? hasLicensePlate,
    String? createdDate,
    String? createdBy,
    String? updatedDate,
    String? updatedBy,
    String? totalItem,
    String? externalClaimId,
  }) {
    return ClaimFolderModel(
      folderId: folderId ?? this.folderId,
      folderName: folderName ?? this.folderName,
      claimName: claimName ?? this.claimName,
      claimId: claimId ?? this.claimId,
      folderIdByOrg: folderIdByOrg ?? this.folderIdByOrg,
      assessorName: assessorName ?? this.assessorName,
      parentClaimId: parentClaimId ?? this.parentClaimId,
      licensePlatesEngine: licensePlatesEngine ?? this.licensePlatesEngine,
      vehicleLicensePlates: vehicleLicensePlates ?? this.vehicleLicensePlates,
      vehicleBrandId: vehicleBrandId ?? this.vehicleBrandId,
      vehicleBrandName: vehicleBrandName ?? this.vehicleBrandName,
      extraPrice: extraPrice ?? this.extraPrice,
      vehicleName: vehicleName ?? this.vehicleName,
      vehicleBrand: vehicleBrand ?? this.vehicleBrand,
      sceneStreet: sceneStreet ?? this.sceneStreet,
      sceneDistrict: sceneDistrict ?? this.sceneDistrict,
      sceneCity: sceneCity ?? this.sceneCity,
      deletedFlag: deletedFlag ?? this.deletedFlag,
      resultsAvailable: resultsAvailable ?? this.resultsAvailable,
      hasLicensePlate: hasLicensePlate ?? this.hasLicensePlate,
      createdDate: createdDate ?? this.createdDate,
      createdBy: createdBy ?? this.createdBy,
      updatedDate: updatedDate ?? this.updatedDate,
      updatedBy: updatedBy ?? this.updatedBy,
      totalItem: totalItem ?? this.totalItem,
      externalClaimId: externalClaimId ?? this.externalClaimId,
    );
  }

  @override
  List<Object?> get props {
    return [
      folderId,
      folderName,
      claimName,
      claimId,
      folderIdByOrg,
      assessorName,
      parentClaimId,
      licensePlatesEngine,
      vehicleLicensePlates,
      vehicleBrandId,
      vehicleBrandName,
      extraPrice,
      vehicleName,
      vehicleBrand,
      sceneStreet,
      sceneDistrict,
      sceneCity,
      deletedFlag,
      resultsAvailable,
      hasLicensePlate,
      createdDate,
      createdBy,
      updatedDate,
      updatedBy,
      totalItem,
      externalClaimId,
    ];
  }
}
