import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ImageProcessModel extends Equatable {
  final String paramName;
  final String imgBase64;

  const ImageProcessModel({
    required this.paramName,
    required this.imgBase64,
  });

  @mustCallSuper
  Map<String, dynamic> toMap() {
    return {
      'paramName': paramName,
      'imgBase64': imgBase64,
    };
  }

  String toJson();

  @override
  List<Object?> get props => [paramName];
}

class KernelSize extends Equatable {
  final int rows;
  final int columns;

  const KernelSize(this.rows, this.columns);

  Map<String, dynamic> toMap() {
    return <String, int>{
      'rows': rows,
      'columns': columns,
    };
  }

  @override
  List<Object?> get props => [rows, columns];
}
