import 'package:aicycle_buyme_plus/src/config/aicycle_config.dart';

extension CarAngleExt on AicycleCarAngle {
  String get id {
    switch (this) {
      case AicycleCarAngle.front:
        return 'truoc-sT9qgX';
      case AicycleCarAngle.frontLeft:
        return '45-trai-truoc-C1xM02';
      case AicycleCarAngle.frontRight:
        return '45-phai-truoc-UoYzs6';
      case AicycleCarAngle.rear:
        return 'sau-htBwjB';
      case AicycleCarAngle.rearLeft:
        return '45-trai-sau-1q3G3J';
      case AicycleCarAngle.rearRight:
        return '45-phai-sau-fRzY3r';
      case AicycleCarAngle.left:
        return 'trai-MyuVUE';
      case AicycleCarAngle.right:
        return 'phai-4wif2Z';
      case AicycleCarAngle.regStamp:
        return 'tem-dang-kiem-LC81Ar';
      case AicycleCarAngle.vinNumber:
        return 'so-khung-qmqAsM';
      case AicycleCarAngle.taplo:
        return 'tap-lo-H4SHs1';
      case AicycleCarAngle.regCert:
        return 'dang-kiem-xe-82YjAa';
    }
  }
}
