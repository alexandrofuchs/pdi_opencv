// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:opencv_app/core/common/process.dart';

enum ConversionMode {
  none(''),
  bgr2hsv('HSV'),
  bgr2Rrgb('RGB'),
  bgr2gray('GRAY');

  const ConversionMode(this.value);

  final String value;
}

class ColorSpace extends ImageProcessModel {
  final ConversionMode mode;

  const ColorSpace(
      {required this.mode,
      super.paramName = 'colorspace',
      required super.imgBase64});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'mode': mode.value,
    };
  }

  @override
  String toJson() => json.encode(toMap());
}
