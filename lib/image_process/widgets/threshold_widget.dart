import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/core/models/threshold_model.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/controllers/threshold_controller.dart';
import 'package:opencv_app/image_process/widgets/common_widgets.dart';
import 'package:opencv_app/theme.dart';

class ThresholdWidget extends StatefulWidget {
  final File editImage;
  const ThresholdWidget({super.key, required this.editImage});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ThresholdWidget> {
  late final ThresholdController controller;

  @override
  void initState() {
    controller = ThresholdController(widget.editImage);
    super.initState();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThresholdController, ThresholdState>(
        bloc: controller,
        builder: (context, state) {
          return Column(
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: ThresholdType.values.length - 1,
                  itemBuilder: (context, index) {
                    index += 1;

                    return Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ThresholdType.values[index].value,
                            style: AppTheme.defaultItemText,
                          ),
                          Radio<ThresholdType>(
                              value: ThresholdType.values[index],
                              groupValue: state.type,
                              onChanged: (value) async {
                                if (value == null) return;

                                controller.setType(value);
                              }),
                        ],
                      ),
                      index == state.type.index
                          ? Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  slider("valor thresh", state.thresh, 0, 255,
                                      (value) {
                                    controller.setThresh(value.roundToDouble());
                                  }),
                                  slider('maxval:', state.maxval, 0, 255,
                                      (value) {
                                    controller.setMaxVal(value.roundToDouble());
                                  }),
                                ],
                              ),
                            )
                          : Container()
                    ]);
                  }),
              buttomActionsWidget(
                  '${state.type.value}_${DateTime.now().millisecondsSinceEpoch}',
                  ThresholdModel(
                      type: state.type,
                      maxval: state.maxval,
                      thresh: state.thresh,
                      imgBase64: ImageConverter.fileToBase64(
                          Modular.get<ImageProcessController>()
                              .state
                              .historic
                              .last)!))
            ],
          );
        });
  }
}
