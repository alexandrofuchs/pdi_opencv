import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';
import 'package:opencv_app/flutter_channel/pylib_channel_controller.dart';

abstract class ImageProcess extends Equatable {
  final File loadedImage;
  final File? currentChange;

  const ImageProcess(this.loadedImage, {this.currentChange});

  @mustCallSuper
  @override
  List<Object?> get props => [loadedImage, currentChange];
}

class ImageProcessState extends Equatable {
  final int change;
  final List<File> historic;
  final File? selectedImage;
  final bool applied;

  const ImageProcessState(
      {this.historic = const [],
      this.selectedImage,
      this.applied = false,
      this.change = 0});

  @override
  List<Object?> get props => [change, historic, applied, selectedImage];

  ImageProcessState copyWith(
      {List<File>? historic, bool applied = false, File? selectedImage}) {
    return ImageProcessState(
        selectedImage: selectedImage,
        historic: historic ?? this.historic,
        applied: applied,
        change: change + 1);
  }
}

class ImageProcessController extends Cubit<ImageProcessState> {
  final PyLibChannelController pylib;

  ImageProcessController(this.pylib) : super(const ImageProcessState());

  final ImagePicker picker = ImagePicker();

  @override
  void onChange(Change<ImageProcessState> change) {
    debugPrint(change.currentState.toString());
    debugPrint(change.nextState.toString());
    super.onChange(change);
  }

  void clearHistoric(List<int> indexes) {
    indexes.sort((a, b) => a.compareTo(b));
    List<File?> list = List.of(state.historic);
    for (var element in indexes) {
      list[element] = null;
    }

    emit(state.copyWith(historic: list.whereType<File>().toList()));
  }

  void selectImage(int index) {
    emit(state.copyWith(
      selectedImage: state.historic[index],
    ));
  }

  void takePhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    final img =
        await ImageConverter.xFileToFile("original_${state.change}", photo);
    if (img == null) return;
    emit(state.copyWith(
        historic: List.of(state.historic)..insert(0, img), selectedImage: img));
  }

  void galleryPhoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    final img =
        await ImageConverter.xFileToFile("original_${state.change}", photo);
    if (img == null) return;
    emit(state.copyWith(
        historic: List.of(state.historic)..insert(0, img), selectedImage: img));
  }

  void addProcessedImage(File image) {
    emit(state.copyWith(historic: List.of(state.historic)..add(image)));
  }
}
