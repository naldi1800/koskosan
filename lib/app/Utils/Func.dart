import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class FUNC {
  static String convertToIdr(dynamic number) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(number);
  }

  static String convertToK(dynamic n) {
    if (n > 1000) n /= 1000;
    n = n.toInt();
    return "${n}K";
  }

  static List<LatLng> bresenhamLine(LatLng p1, LatLng p2) {
    int x1 = p1.latitude.toInt();
    int y1 = p1.longitude.toInt();
    int x2 = p2.latitude.toInt();
    int y2 = p2.longitude.toInt();

    List<LatLng> points = [];

    int deltaX = (x2 - x1).abs();
    int deltaY = (y2 - y1).abs();
    int signX = x1 < x2 ? 1 : -1;
    int signY = y1 < y2 ? 1 : -1;
    int error = deltaX - deltaY;

    while (x1 != x2 || y1 != y2) {
      points.add(LatLng(x1.toDouble(), y1.toDouble()));
      int error2 = error * 2;
      if (error2 > -deltaY) {
        error -= deltaY;
        x1 += signX;
      }
      if (error2 < deltaX) {
        error += deltaX;
        y1 += signY;
      }
    }

    return points;
  }

  static double getDistanceOfLine(LatLng a, LatLng b) {
    var min = a.latitude < b.latitude;

    var x1 = min ? a.latitude : b.latitude;
    var y1 = min ? a.longitude : b.longitude;
    var x2 = !min ? a.latitude : b.latitude;
    var y2 = !min ? a.longitude : b.longitude;

    var x3 = x1;
    var y3 = y2;

    var A = x2 - x1;
    var B = y2 - y1;
    var C = 0.0;

    //Rumus
    C = sqrt(A * A + B * B);

    return C;
  }
}
