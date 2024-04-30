import 'dart:convert';

import 'package:opencv_app/core/common/process.dart';

class CannyModel extends ImageProcessModel {
  final double thresh1;
  final double thresh2;

  const CannyModel(
      {required this.thresh1,
      required this.thresh2,
      super.paramName = 'canny',
      required super.imgBase64});

  @override
  String toJson() => json.encode(toMap());

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      ...super.toMap(),
      'thresh1': thresh1,
      'thresh2': thresh2,
    };
  }
}
