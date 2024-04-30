import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opencv_app/core/common/process.dart';
import 'package:opencv_app/core/models/morphological_model.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';

class MorphologicalState extends ImageProcess {
  final MorphologicalTransformation transformation;
  final KernelSize kernelSize;
  final int iterations;

  const MorphologicalState(
    super.loadedImage, {
    super.currentChange,
    this.transformation = MorphologicalTransformation.none,
    this.kernelSize = const KernelSize(0, 0),
    this.iterations = 1,
  });

  @override
  List<Object?> get props =>
      [transformation, kernelSize, iterations, ...super.props];

  MorphologicalState copyWith({
    File? currentChange,
    MorphologicalTransformation? transformation,
    KernelSize? kernelSize,
    int? iterations,
  }) {
    return MorphologicalState(
      loadedImage,
      currentChange: currentChange ?? this.currentChange,
      transformation: transformation ?? this.transformation,
      kernelSize: kernelSize ?? this.kernelSize,
      iterations: iterations ?? this.iterations,
    );
  }
}

class MorphologicalController extends Cubit<MorphologicalState> {
  MorphologicalController(File loadedImage)
      : super(MorphologicalState(loadedImage));

  setTransformation(MorphologicalTransformation value) {
    emit(state.copyWith(transformation: value));
  }

  setKernel(KernelSize value) {
    emit(state.copyWith(kernelSize: value));
  }

  setIterations(int value) {
    emit(state.copyWith(iterations: value));
  }
}
