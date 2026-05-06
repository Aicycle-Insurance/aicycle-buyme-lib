import '../../features/document_result/domain/entities/segment_result.dart';

extension DamageExt on DamageEntity {
  String getDisplayShortName() {
    switch (damageTypeId) {
      case 'mop-bep-jtep4m':
        return 'Móp';
      case 'tray-xuoc-g06jcx':
        return 'Xước';
      case 'vo-nut-E6BNTw':
        return 'Vỡ';
      case 'mat-4iytj1':
        return 'Mất';
      case 'long-rung-i2rm16':
        return 'Rụng';
      case 'thung-rach-EcfqAl':
        return 'Rách';
      default:
        return 'Undefined';
    }
  }
}
