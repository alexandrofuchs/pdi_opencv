import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/core/models/edge_model.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';
import 'package:opencv_app/image_process/controllers/edge_controller.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/widgets/common_widgets.dart';

class EdgesWidget extends StatefulWidget {
  final File editImage;
  const EdgesWidget({super.key, required this.editImage});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EdgesWidget> {
  late final EdgeController controller;

  @override
  void initState() {
    controller = EdgeController(widget.editImage);
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
      child: BlocBuilder<EdgeController, EdgeState>(
          bloc: controller,
          builder: (context, state) {
            return Column(
              children: [
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: EdgeMethod.values.length - 1,
                    itemBuilder: (context, index) {
                      index += 1;

                      return Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(EdgeMethod.values[index].value),
                            Radio<EdgeMethod>(
                                value: EdgeMethod.values[index],
                                groupValue: state.method,
                                onChanged: (value) async {
                                  if (value == null) return;
                                  controller.setMethod(value);
                                }),
                          ],
                        ),
                        index == state.method.index
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('dx: ${state.dx}'),
                                      Expanded(
                                        child: Slider(
                                            max: 1,
                                            min: 0,
                                            value: state.dx.toDouble(),
                                            onChanged: (value) {
                                              controller.setDx(value.toInt());
                                            }),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('dy: ${state.dy}'),
                                      Expanded(
                                        child: Slider(
                                            max: 1,
                                            min: 0,
                                            value: state.dy.toDouble(),
                                            onChanged: (value) {
                                              controller.setDy(value.toInt());
                                            }),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('ksize: ${state.ksize}'),
                                      Expanded(
                                        child: Slider(
                                            max: 255,
                                            min: 0,
                                            value: state.ksize.toDouble(),
                                            onChanged: (value) {
                                              controller
                                                  .setksize(value.toInt());
                                            }),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container()
                      ]);
                    }),
                buttomActionsWidget(
                    '${state.method.value}_${DateTime.now().millisecondsSinceEpoch}',
                    EdgeModel(
                        method: state.method,
                        dx: state.dx,
                        dy: state.dy,
                        ksize: state.ksize,
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
