import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opencv_app/core/models/edge_model.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';

class EdgeState extends ImageProcess {
  final int dx;
  final int dy;
  final int ksize;
  final EdgeMethod method;

  const EdgeState(super.loadedImage,
      {super.currentChange,
      this.dx = 0,
      this.dy = 1,
      this.ksize = 1,
      this.method = EdgeMethod.laplacian});

  @override
  List<Object?> get props => [dx, dy, method, ksize, ...super.props];

  EdgeState copyWith({
    File? currentChange,
    int? dx,
    int? dy,
    int? ksize,
    EdgeMethod? method,
  }) {
    return EdgeState(
      loadedImage,
      currentChange: currentChange ?? this.currentChange,
      dx: dx ?? this.dx,
      dy: dy ?? this.dy,
      ksize: ksize ?? this.ksize,
      method: method ?? this.method,
    );
  }
}

class EdgeController extends Cubit<EdgeState> {
  EdgeController(File loadedImage) : super(EdgeState(loadedImage));

  setMethod(EdgeMethod value) {
    emit(state.copyWith(method: value));
  }

  setDx(int value) {
    emit(state.copyWith(dx: value.toInt()));
  }

  setDy(int value) {
    emit(state.copyWith(dy: value.toInt()));
  }

  setksize(int value) {
    emit(state.copyWith(ksize: value.toInt()));
  }
}
