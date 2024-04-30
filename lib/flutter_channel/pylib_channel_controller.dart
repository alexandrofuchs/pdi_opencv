// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opencv_app/core/common/process.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';

class ProcessResult extends Equatable {
  final File? initial;
  final File? processed;

  const ProcessResult({this.initial, this.processed});

  @override
  List<Object?> get props => [initial, processed];

  ProcessResult copyWith({
    File? initial,
    File? processed,
  }) {
    return ProcessResult(
      initial: initial ?? this.initial,
      processed: processed,
    );
  }
}

class PyLibChannelController extends Cubit<ProcessResult> {
  PyLibChannelController() : super(const ProcessResult());
  static const platform = MethodChannel('com.alexandrofuchs.pylib_channel');

  loadImage(File initial) {
    emit(state.copyWith(initial: initial));
  }

  removeProcessed() {
    emit(state.copyWith());
  }

  void processImage(String imgName, ImageProcessModel model) async {
    try {
      debugPrint({...model.toMap(), 'imgBase64': null}.toString());
      final res =
          await platform.invokeMethod<String>('processImage', model.toJson());
      final img = await ImageConverter.base64ToFile(
          name: '${imgName}_${DateTime.now().millisecondsSinceEpoch}',
          value: res);
      emit(state.copyWith(processed: img));
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
