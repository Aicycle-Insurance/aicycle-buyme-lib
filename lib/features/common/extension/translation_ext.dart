import '../../../aicycle.dart';
import '../../../generated/locales.g.dart';

extension Trans on String {
  String get trans {
    // Returns the key if locale is null.
    if (locale?.languageCode == null) return Locales.vi_VN[this] ?? this;
    if (locale?.languageCode == 'vi') return Locales.vi_VN[this] ?? this;
    if (locale?.languageCode == 'en') return Locales.en_US[this] ?? this;
    if (locale?.languageCode == 'ja') return Locales.ja_JP[this] ?? this;
    return this;
  }
}
