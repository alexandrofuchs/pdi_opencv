import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opencv_app/core/common/process.dart';
import 'package:opencv_app/core/models/blur_model.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';

class BlurState extends ImageProcess {
  final FilterMethod method;
  final KernelSize kernelSize;
  final int kernelNumber;
  final double sigmaX;
  final double sigmaY;
  final double sigmaColor;
  final double sigmaSpace;
  final int d;

  const BlurState(super.loadedImage,
      {super.currentChange,
      this.method = FilterMethod.none,
      this.kernelSize = const KernelSize(1, 1),
      this.kernelNumber = 1,
      this.sigmaX = 0,
      this.sigmaY = 0,
      this.sigmaColor = 1,
      this.sigmaSpace = 1,
      this.d = 1});

  @override
  List<Object?> get props => [
        method,
        kernelNumber,
        kernelSize,
        sigmaX,
        sigmaY,
        sigmaColor,
        sigmaSpace,
        d,
        ...super.props,
      ];

  BlurState copyWith({
    File? currentChange,
    FilterMethod? method,
    KernelSize? kernelSize,
    int? kernelNumber,
    double? sigmaX,
    double? sigmaY,
    double? sigmaColor,
    double? sigmaSpace,
    int? d,
  }) {
    return BlurState(
      loadedImage,
      currentChange: currentChange ?? this.currentChange,
      method: method ?? this.method,
      kernelSize: kernelSize ?? this.kernelSize,
      kernelNumber: kernelNumber ?? this.kernelNumber,
      sigmaX: sigmaX ?? this.sigmaX,
      sigmaY: sigmaY ?? this.sigmaY,
      sigmaColor: sigmaColor ?? this.sigmaColor,
      sigmaSpace: sigmaSpace ?? this.sigmaSpace,
      d: d ?? this.d,
    );
  }
}

class BlurController extends Cubit<BlurState> {
  BlurController(File loadedImage) : super(BlurState(loadedImage));

  setMethod(FilterMethod value) {
    emit(state.copyWith(
        method: value,
        kernelSize: const KernelSize(1, 1),
        kernelNumber: 1,
        sigmaX: 0,
        sigmaY: 0,
        sigmaColor: 1,
        sigmaSpace: 1,
        d: 1));
  }

  setValue({
    KernelSize? kernelSize,
    int? kernelNumber,
    double? sigmaX,
    double? sigmaY,
    double? sigmaColor,
    double? sigmaSpace,
    int? d,
  }) {
    emit(state.copyWith(
        kernelSize: KernelSize(kernelSize?.rows ?? state.kernelSize.rows,
            kernelSize?.columns ?? state.kernelSize.columns),
        kernelNumber: kernelNumber,
        d: d,
        sigmaX: sigmaX,
        sigmaY: sigmaY,
        sigmaColor: sigmaColor,
        sigmaSpace: sigmaSpace));
  }
}
