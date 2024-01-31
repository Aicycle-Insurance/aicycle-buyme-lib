abstract class BaseEndpoint {
  static String get devBaseUrl => 'https://dev-api-insurance.aicycle.ai';
  // static String get adminBaseUrl => 'https://dev-api-admin.aicycle.ai';
  static String get stageBaseUrl => 'https://stage-api-insurance.aicycle.ai';
  // static String get stageAdminBaseUrl => 'https://stage-api-admin.aicycle.ai';
  static String get baseUrl => 'https://api-aws-insurance.aicycle.ai';
  // static String get adminBaseUrl => 'https://api-aws-admin.aicycle.ai';
}

abstract class Endpoint {
  static String get callEngine => '/v2/buy-me/process';
  static String get checkIsOneCar => '/insurance/checkCar/{claimId}';
  static String get getImageUploadUrl => '/images/url';
  static String get validateUpload => '/claimimages/validate';
  static String get claimFolders => '/claimfolders';
  // static String get getImageInformation => '/insurance/claimFolder/{claimId}';
  static String get deleteImageById => '/claimimages/{imageId}';
  static String get getImageInformation =>
      '/v2/claimfolders/{claimId}/insurance-images';
}
