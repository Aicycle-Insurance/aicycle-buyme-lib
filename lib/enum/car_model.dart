import 'car_part_direction.dart';

enum CarModelEnum {
  kiaMorning,
  toyotaInnova,
  toyotaCross,
  mazdaCX5,
  toyotaVios,
  truck;

  factory CarModelEnum.fromId(num? id) {
    switch (id) {
      case 1:
        return CarModelEnum.kiaMorning;
      case 3:
        return CarModelEnum.toyotaInnova;
      case 4:
        return CarModelEnum.toyotaCross;
      case 5:
        return CarModelEnum.toyotaVios;
      case 6:
      case 7:
        return CarModelEnum.truck;
      default:
        return CarModelEnum.kiaMorning;
    }
  }
}

extension CarModelEnumExt on CarModelEnum {
  String imagePath(CarPartDirectionEnum directionEnum) {
    switch (this) {
      case CarModelEnum.kiaMorning:
        return 'assets/images/hatchback_${directionEnum.name}.png';
      case CarModelEnum.toyotaInnova:
        return 'assets/images/suv_${directionEnum.name}.png';
      case CarModelEnum.toyotaCross:
        return 'assets/images/suv_${directionEnum.name}.png';
      case CarModelEnum.mazdaCX5:
        return 'assets/images/suv_${directionEnum.name}.png';
      case CarModelEnum.toyotaVios:
        return 'assets/images/sedan_${directionEnum.name}.png';
      case CarModelEnum.truck:
        return '';
    }
  }
}
