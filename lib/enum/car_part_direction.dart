import 'package:aicycle_buyme_lib/features/common/extension/translation_ext.dart';

import '../generated/locales.g.dart';

enum CarPartDirectionEnum {
  up(1, 'tren-BrogFf'),
  front(2, 'truoc-sT9qgX'),
  d45RightFront(3, '45-phai-truoc-UoYzs6'),
  d45LeftFront(4, '45-trai-truoc-C1xM02'),
  back(5, 'sau-htBwjB'),
  d45RightBack(6, '45-phai-sau-fRzY3r'),
  d45LeftBack(7, '45-trai-sau-1q3G3J'),
  rightFront(8, 'phai-truoc-eYWg1d'),
  leftFront(9, 'trai-truoc-r6BEZd'),
  rightBack(10, 'phai-sau-v1hAm6'),
  leftBack(11, 'trai-sau-t8QgFO'),

  /// Góc trái trên môi trường dev có id là 31
  leftDev(31, 'trai-MyuVUE'),

  /// Góc trái trên môi trường production có id là 22
  leftProd(22, 'trai-MyuVUE');

  final int id;
  final String excelId;
  const CarPartDirectionEnum(
    this.id,
    this.excelId,
  );

  factory CarPartDirectionEnum.fromId(int id) {
    switch (id) {
      case 1:
        return CarPartDirectionEnum.up;
      case 2:
        return CarPartDirectionEnum.front;
      case 3:
        return CarPartDirectionEnum.d45RightFront;
      case 4:
        return CarPartDirectionEnum.d45LeftFront;
      case 5:
        return CarPartDirectionEnum.back;
      case 6:
        return CarPartDirectionEnum.d45RightBack;
      case 7:
        return CarPartDirectionEnum.d45LeftBack;
      case 8:
        return CarPartDirectionEnum.rightFront;
      case 9:
        return CarPartDirectionEnum.leftFront;
      case 10:
        return CarPartDirectionEnum.rightBack;
      case 11:
        return CarPartDirectionEnum.leftBack;
      case 22:
        return CarPartDirectionEnum.leftProd;
      case 31:
        return CarPartDirectionEnum.leftDev;
      default:
        return CarPartDirectionEnum.leftFront;
    }
  }
}

extension CarPartDirectionEnumExt on CarPartDirectionEnum {
  int get id => index + 1;

  String get title {
    switch (this) {
      case CarPartDirectionEnum.up:
        return "up";
      case CarPartDirectionEnum.front:
        return "front";
      case CarPartDirectionEnum.d45RightFront:
        return "rightFront45";
      case CarPartDirectionEnum.d45LeftFront:
        return "leftFront45";
      case CarPartDirectionEnum.back:
        return "back";
      case CarPartDirectionEnum.d45RightBack:
        return "rightBack45";
      case CarPartDirectionEnum.d45LeftBack:
        return "leftBack45";
      case CarPartDirectionEnum.rightFront:
        return "rightFront";
      case CarPartDirectionEnum.leftFront:
        return "leftFront";
      case CarPartDirectionEnum.rightBack:
        return "rightBack";
      case CarPartDirectionEnum.leftBack:
        return "leftBack";
      // case CarPartDirectionEnum.left:
      //   return "left";
      case CarPartDirectionEnum.leftDev:
        return "left";
      case CarPartDirectionEnum.leftProd:
        return "left";
    }
  }

  String get buyMeTitle {
    if (this == CarPartDirectionEnum.d45RightFront) {
      return LocaleKeys.rightFront45Buyme.trans;
    }
    if (this == CarPartDirectionEnum.d45LeftFront) {
      return LocaleKeys.leftFront45Buyme.trans;
    }
    if (this == CarPartDirectionEnum.d45RightBack) {
      return LocaleKeys.rightBack45Buyme.trans;
    }
    if (this == CarPartDirectionEnum.leftDev ||
        this == CarPartDirectionEnum.leftProd) {
      return LocaleKeys.registrationSticker.trans;
    }
    return LocaleKeys.leftBack45Buyme.trans;
  }

  String get cathayTitle {
    if (this == CarPartDirectionEnum.d45RightFront) {
      return LocaleKeys.cathayFrontRight.trans;
    }
    if (this == CarPartDirectionEnum.d45LeftFront) {
      return LocaleKeys.cathayFrontLeft.trans;
    }
    if (this == CarPartDirectionEnum.d45RightBack) {
      return LocaleKeys.cathayRearRight.trans;
    }
    if (this == CarPartDirectionEnum.leftDev ||
        this == CarPartDirectionEnum.leftProd) {
      return LocaleKeys.registrationSticker.trans;
    }
    return LocaleKeys.cathayRearLeft.trans;
  }

  String get intoContent {
    switch (this) {
      case CarPartDirectionEnum.up:
      case CarPartDirectionEnum.front:
      case CarPartDirectionEnum.rightFront:
      case CarPartDirectionEnum.leftFront:
      case CarPartDirectionEnum.rightBack:
      case CarPartDirectionEnum.leftBack:
      case CarPartDirectionEnum.leftDev:
      case CarPartDirectionEnum.leftProd:
        return "introLeft";
      case CarPartDirectionEnum.d45RightFront:
        return "introRightFront";
      case CarPartDirectionEnum.d45LeftFront:
        return "introLeftFront";
      case CarPartDirectionEnum.back:
      case CarPartDirectionEnum.d45RightBack:
        return "introRightBack";
      case CarPartDirectionEnum.d45LeftBack:
        return "introLeftBack";
    }
  }

  String guideImagePath(String langCode) {
    String langCode0 = langCode;
    if (langCode == 'ja' || langCode == 'jp') {
      langCode0 = 'en';
    }
    switch (this) {
      case CarPartDirectionEnum.up:
      case CarPartDirectionEnum.front:
      case CarPartDirectionEnum.rightFront:
      case CarPartDirectionEnum.leftFront:
      case CarPartDirectionEnum.rightBack:
      case CarPartDirectionEnum.leftBack:
      case CarPartDirectionEnum.leftDev:
      case CarPartDirectionEnum.leftProd:
        return "assets/images/vi_left_guide.png";
      case CarPartDirectionEnum.d45RightFront:
        return "assets/images/${langCode0}_rightFront_guide.png";
      case CarPartDirectionEnum.d45LeftFront:
        return "assets/images/${langCode0}_leftFront_guide.png";
      case CarPartDirectionEnum.back:
      case CarPartDirectionEnum.d45RightBack:
        return "assets/images/${langCode0}_rightBack_guide.png";
      case CarPartDirectionEnum.d45LeftBack:
        return "assets/images/${langCode0}_leftBack_guide.png";
    }
  }

  String get intoTitle {
    switch (this) {
      case CarPartDirectionEnum.up:
      case CarPartDirectionEnum.front:
      case CarPartDirectionEnum.rightFront:
      case CarPartDirectionEnum.leftFront:
      case CarPartDirectionEnum.rightBack:
      case CarPartDirectionEnum.leftBack:
      case CarPartDirectionEnum.leftDev:
      case CarPartDirectionEnum.leftProd:
        return "guideLeft";
      case CarPartDirectionEnum.d45RightFront:
        return "guideRightFront";
      case CarPartDirectionEnum.d45LeftFront:
        return "guideLeftFront";
      case CarPartDirectionEnum.back:
      case CarPartDirectionEnum.d45RightBack:
        return "guideRightBack";
      case CarPartDirectionEnum.d45LeftBack:
        return "guideLeftBack";
    }
  }
}
