import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/core/models/colorspace_model.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';
import 'package:opencv_app/image_process/controllers/colorspace_controller.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/widgets/common_widgets.dart';
import 'package:opencv_app/theme.dart';

class ColorSpaceWidget extends StatefulWidget {
  final File editImage;
  const ColorSpaceWidget({super.key, required this.editImage});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ColorSpaceWidget> {
  late final ColorSpaceController controller;

  @override
  void initState() {
    controller = ColorSpaceController(widget.editImage);
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ColorSpaceController, ColorSpaceState>(
            bloc: controller,
            builder: (context, state) {
              return Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: ConversionMode.values.length - 1,
                      itemBuilder: (context, index) {
                        index += 1;

                        return Padding(
                          padding: const EdgeInsets.only(right: 15, left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ConversionMode.values[index].value,
                                style: AppTheme.defaultItemText,
                              ),
                              Radio<ConversionMode>(
                                  value: ConversionMode.values[index],
                                  groupValue: state.mode,
                                  onChanged: (value) async {
                                    if (value == null) return;
                                    controller.setState(value);
                                  }),
                            ],
                          ),
                        );
                      }),
                  buttomActionsWidget(
                      '${state.mode.value}_${DateTime.now().millisecondsSinceEpoch}',
                      ColorSpace(
                          mode: state.mode,
                          imgBase64: ImageConverter.fileToBase64(
                              Modular.get<ImageProcessController>()
                                  .state
                                  .historic
                                  .last)!))
                ],
              );
            }),
      ],
    );
  }
}
