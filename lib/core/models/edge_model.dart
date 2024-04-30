import 'dart:convert';

import 'package:opencv_app/core/common/process.dart';

enum EdgeMethod {
  none(''),
  laplacian('LAPLACIAN'),
  solbelx('SOBELX'),
  solbely('SOBELY');

  const EdgeMethod(this.value);

  final String value;
}

class EdgeModel extends ImageProcessModel {
  final EdgeMethod method;
  final int ksize;
  final int dx;
  final int dy;

  const EdgeModel(
      {required this.method,
      required this.dx,
      required this.dy,
      required this.ksize,
      super.paramName = 'edge',
      required super.imgBase64});

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'method': method.value,
      'ksize': ksize,
      'dx': dx,
      'dy': dy,
    };
  }
}
