// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:opencv_app/core/common/process.dart';

enum MorphologicalTransformation {
  none(''),
  erode("ERODE"),
  dilate('DILATE'),
  opening('OPENING'),
  closing('CLOSING'),
  gradient('GRADIENT');

  const MorphologicalTransformation(this.value);

  final String value;
}

class MorphologicalModel extends ImageProcessModel {
  final MorphologicalTransformation transformation;
  final KernelSize kernelSize;
  final int iterations;

  const MorphologicalModel(
      {required this.transformation,
      required this.kernelSize,
      required this.iterations,
      super.paramName = 'morphological',
      required super.imgBase64});

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'transformation': transformation.value,
      'kernelSize': kernelSize.toMap(),
      'iterations': iterations
    };
  }
}
