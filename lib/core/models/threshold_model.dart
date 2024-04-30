// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:opencv_app/core/common/process.dart';

enum ThresholdType {
  none(''),
  binary('BINARY'),
  binaryInv('BINARY_INV'),
  trunc('TRUNC'),
  toZero('TOZERO'),
  toZeroInv('TOZERO_INV');

  const ThresholdType(this.value);

  final String value;
}

class ThresholdModel extends ImageProcessModel {
  final ThresholdType type;
  final double thresh;
  final double maxval;

  const ThresholdModel(
      {required this.type,
      required this.thresh,
      required this.maxval,
      super.paramName = 'threshold',
      required super.imgBase64});

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'type': type.value,
      'thresh': thresh,
      'maxval': maxval,
    };
  }
}
