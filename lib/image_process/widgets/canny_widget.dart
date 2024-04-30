import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/core/models/canny_model.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';
import 'package:opencv_app/image_process/controllers/canny_controller.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/widgets/common_widgets.dart';

class CannyWidget extends StatefulWidget {
  final File editImage;
  const CannyWidget({super.key, required this.editImage});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CannyWidget> {
  late final CannyController controller;

  @override
  void initState() {
    controller = CannyController(widget.editImage);
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<CannyController, CannyState>(
          bloc: controller,
          builder: (context, state) {
            return Column(
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        Text('Thresh1: ${state.thresh1}'),
                        Expanded(
                          child: Slider(
                              max: 255,
                              min: 0,
                              value: state.thresh1.toDouble(),
                              onChanged: (value) {
                                controller.setThresh1(value.roundToDouble());
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Thresh2: ${state.thresh2}'),
                        Expanded(
                          child: Slider(
                              max: 255,
                              min: 0,
                              value: state.thresh2.toDouble(),
                              onChanged: (value) {
                                controller.setThresh2(value.roundToDouble());
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
                buttomActionsWidget(
                    'canny_${DateTime.now().millisecondsSinceEpoch}',
                    CannyModel(
                        thresh1: state.thresh1,
                        thresh2: state.thresh2,
                        imgBase64: ImageConverter.fileToBase64(
                            Modular.get<ImageProcessController>()
                                .state
                                .historic
                                .last)!))
              ],
            );
          }),
    );
  }
}
