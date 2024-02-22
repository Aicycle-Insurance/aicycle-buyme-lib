import 'dart:async';
import 'dart:io';

import 'package:exif/exif.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geoc;

import 'logger.dart';

class LocationServices {
  static geolocator.Position? get location => _location;
  static geolocator.Position? _location;

  static Future<bool> _checkPermission() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.always ||
        permission == geolocator.LocationPermission.whileInUse) {
      return true;
    }
    return false;
  }

  static Future _requestPermission() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      logger.e('Location service is disabled.');
      return;
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        logger.e('Location permissions are denied');
        return;
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      logger.e(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
      return;
    }
  }

  static Future<geolocator.Position?> getLocation() async {
    if (await _checkPermission()) {
      final res = await geolocator.Geolocator.getCurrentPosition();
      return res;
    }

    await _requestPermission();
    if (await _checkPermission()) {
      final res = await geolocator.Geolocator.getCurrentPosition();
      return res;
    }

    return null;
  }

  static Future<String?> getLocationInfo(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      return null;
    }
    try {
      var rs = await geoc.placemarkFromCoordinates(lat, lng);
      String name = '';
      if (rs.isNotEmpty) {
        final address = rs.first;
        final list = [];
        if (address.name?.isNotEmpty ?? false) {
          list.add(address.name);
        }
        if (address.street?.isNotEmpty ?? false) {
          list.add(address.street);
        }
        if (address.administrativeArea?.isNotEmpty ?? false) {
          list.add(address.administrativeArea);
        }
        if (address.country?.isNotEmpty ?? false) {
          list.add(address.country);
        }
        name = list.join(", ").trim();
      } else {
        name =
            '${decimalToSexagesimal(lat, true)}, ${decimalToSexagesimal(lng, false)}';
      }
      return name;
    } catch (e) {
      return '${decimalToSexagesimal(lat, true)}, ${decimalToSexagesimal(lng, false)}';
    }
  }

  static String decimalToSexagesimal(double decimal, bool isLatitude) {
    int degrees = decimal.toInt();
    double decimalMinutes = (decimal - degrees) * 60;
    int minutes = decimalMinutes.toInt();
    double decimalSeconds = (decimalMinutes - minutes) * 60;
    int seconds = decimalSeconds.toInt();

    // Round seconds to two decimal places
    decimalSeconds = (decimalSeconds - seconds) * 60;
    decimalSeconds = (decimalSeconds * 100).round() / 100;
    String direction;
    if (isLatitude) {
      direction = decimal >= 0
          ? 'N'
          : 'S'; // 'N' for positive, 'S' for negative (latitude)
      if (direction == 'N' || direction == 'S') {
        degrees = degrees.abs();
      }
    } else {
      direction = decimal >= 0
          ? 'E'
          : 'W'; // 'E' for positive, 'W' for negative (longitude)
      if (direction == 'E' || direction == 'W') {
        degrees = degrees.abs();
      }
    }

    return '$degrees° $minutes\' $decimalSeconds" $direction';
  }

  static Future<String?> getLocationOfImage(File file,
      {Function(DateTime date)? getDateTimeCallBack}) async {
    final data = await readExifFromFile(file);
    if (data.containsKey('Image DateTime')) {
      String dateTimeString = data['Image DateTime']!.toString();
      dateTimeString = dateTimeString.replaceFirst(':', '-');
      dateTimeString = dateTimeString.replaceFirst(':', '-');
      getDateTimeCallBack?.call(DateTime.parse(dateTimeString));
    }
    if (data.containsKey('GPS GPSLatitude') &&
        data.containsKey('GPS GPSLongitude')) {
      IfdRatios latitude = data['GPS GPSLatitude']?.values as IfdRatios;
      IfdRatios longitude = data['GPS GPSLongitude']?.values as IfdRatios;

      // Convert latitude and longitude from degrees, minutes, seconds to decimal format
      double latDecimal = latitude.ratios[0].toDouble() +
          latitude.ratios[1].toDouble() / 60 +
          latitude.ratios[2].toDouble() / 3600;
      double lonDecimal = longitude.ratios[0].toDouble() +
          longitude.ratios[1].toDouble() / 60 +
          longitude.ratios[2].toDouble() / 3600;
      return await LocationServices.getLocationInfo(latDecimal, lonDecimal);
    } else {
      return null;
    }
  }
}
