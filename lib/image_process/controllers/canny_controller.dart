import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';

class CannyState extends ImageProcess {
  final double thresh1;
  final double thresh2;

  const CannyState(
    super.loadedImage, {
    super.currentChange,
    this.thresh1 = 0,
    this.thresh2 = 1,
  });

  @override
  List<Object?> get props => [thresh1, thresh2, ...super.props];

  CannyState copyWith({
    File? currentChange,
    double? thresh1,
    double? thresh2,
  }) {
    return CannyState(
      loadedImage,
      currentChange: currentChange ?? this.currentChange,
      thresh1: thresh1 ?? this.thresh1,
      thresh2: thresh2 ?? this.thresh2,
    );
  }
}

class CannyController extends Cubit<CannyState> {
  CannyController(File loadedImage) : super(CannyState(loadedImage));

  setThresh1(double value) {
    emit(state.copyWith(thresh1: value));
  }

  setThresh2(double value) {
    emit(state.copyWith(thresh2: value));
  }
}
