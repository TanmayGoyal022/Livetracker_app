import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUtils {
  static Future<BitmapDescriptor> createCustomMarkerFromIcon(
    IconData iconData, {
    Color color = Colors.red,
    double size = 100.0,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final iconStr = String.fromCharCode(iconData.codePoint);

    textPainter.text = TextSpan(
      text: iconStr,
      style: TextStyle(
        letterSpacing: 0.0,
        fontSize: size,
        fontFamily: iconData.fontFamily,
        color: color,
      ),
    );

    textPainter.layout();
    textPainter.paint(canvas, const Offset(0.0, 0.0));

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(
      textPainter.width.toInt(),
      textPainter.height.toInt(),
    );
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }
}
