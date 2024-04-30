// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opencv_app/core/models/colorspace_model.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';

class ColorSpaceState extends ImageProcess {
  final ConversionMode mode;
  const ColorSpaceState(super.loadedImage,
      {super.currentChange, this.mode = ConversionMode.none});

  @override
  List<Object?> get props => [mode, ...super.props];

  ColorSpaceState copyWith({
    File? currentChange,
    ConversionMode? mode,
  }) {
    return ColorSpaceState(
      loadedImage,
      mode: mode ?? this.mode,
      currentChange: currentChange ?? this.currentChange,
    );
  }
}

class ColorSpaceController extends Cubit<ColorSpaceState> {
  ColorSpaceController(File loadedImage) : super(ColorSpaceState(loadedImage));

  setState(ConversionMode value) {
    debugPrint(value.toString());
    emit(state.copyWith(mode: value));
  }
}
