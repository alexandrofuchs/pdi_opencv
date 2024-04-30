import 'dart:convert';

import 'package:opencv_app/core/common/process.dart';

enum FilterMethod {
  none(''),
  averaging('AVERAGING'),
  gaussian('GAUSSIAN'),
  median('MEDIAN'),
  bilateral('BILATERAL');

  const FilterMethod(this.value);

  final String value;
}

class Blur extends ImageProcessModel {
  final FilterMethod method;
  final KernelSize? kernelSize;
  final int? kernelNumber;
  final double? sigmaX;
  final double? sigmaY;
  final double? sigmaColor;
  final double? sigmaSpace;
  final int? d;

  const Blur(
      {required this.kernelSize,
      required this.method,
      this.d,
      this.kernelNumber,
      this.sigmaColor,
      this.sigmaSpace,
      this.sigmaX,
      this.sigmaY,
      super.paramName = 'blur',
      required super.imgBase64});

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      "method": method.value,
      "kernelSize": {'rows': kernelSize?.rows, 'columns': kernelSize?.columns},
      "kernelNumber": kernelNumber,
      "sigmaX": sigmaX,
      "sigmaY": sigmaY,
      "sigmaColor": sigmaColor,
      "sigmaSpace": sigmaSpace,
      "d": d,
    };
  }

  @override
  String toJson() => json.encode(toMap());
}
