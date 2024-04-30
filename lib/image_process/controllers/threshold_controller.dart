import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opencv_app/core/models/threshold_model.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';

class ThresholdState extends ImageProcess {
  final double thresh;
  final double maxval;
  final ThresholdType type;

  const ThresholdState(super.loadedImage,
      {super.currentChange,
      this.thresh = 0.0,
      this.maxval = 0.0,
      this.type = ThresholdType.none});

  @override
  List<Object?> get props => [thresh, type, maxval, ...super.props];

  ThresholdState copyWith({
    File? currentChange,
    double? thresh,
    double? maxval,
    ThresholdType? type,
  }) {
    return ThresholdState(
      loadedImage,
      currentChange: currentChange ?? this.currentChange,
      thresh: thresh ?? this.thresh,
      maxval: maxval ?? this.maxval,
      type: type ?? this.type,
    );
  }
}

class ThresholdController extends Cubit<ThresholdState> {
  ThresholdController(File loadedImage) : super(ThresholdState(loadedImage));

  setType(ThresholdType value) {
    emit(state.copyWith(type: value));
  }

  setThresh(double value) {
    emit(state.copyWith(thresh: value));
  }

  setMaxVal(double value) {
    emit(state.copyWith(maxval: value));
  }
}
