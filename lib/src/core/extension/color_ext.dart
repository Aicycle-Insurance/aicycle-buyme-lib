import 'package:flutter/material.dart';

extension ColorExt on List<int> {
  Color get color {
    if (length < 3 && length > 4) return Colors.transparent;
    if (length == 3) return Color.fromARGB(255, this[0], this[1], this[2]);
    return Color.fromARGB(this[0], this[1], this[2], this[3]);
  }
}

//FFEC05
extension StringExt on String {
  Color get color {
    if (isEmpty) return Colors.transparent;
    if (startsWith('#')) {
      return Color(int.parse('0xff${substring(1)}'));
    }
    return Color(int.parse('0xff$this'));
  }
}
