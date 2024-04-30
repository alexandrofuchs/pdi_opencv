import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/core/common/process.dart';
import 'package:opencv_app/core/models/morphological_model.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/controllers/morphological_controller.dart';
import 'package:opencv_app/image_process/widgets/common_widgets.dart';

class MorphologicalWidget extends StatefulWidget {
  final File editImage;
  const MorphologicalWidget({super.key, required this.editImage});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MorphologicalWidget> {
  late final MorphologicalController controller;

  @override
  void initState() {
    controller = MorphologicalController(widget.editImage);
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
      child: BlocBuilder<MorphologicalController, MorphologicalState>(
          bloc: controller,
          builder: (context, state) {
            return Column(
              children: [
                Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                            MorphologicalTransformation.values.length - 1,
                        itemBuilder: (context, index) {
                          index += 1;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(MorphologicalTransformation
                                  .values[index].value),
                              Radio<MorphologicalTransformation>(
                                  value:
                                      MorphologicalTransformation.values[index],
                                  groupValue: state.transformation,
                                  onChanged: (value) async {
                                    if (value == null) return;
                                    controller.setTransformation(value);
                                  }),
                            ],
                          );
                        }),
                    slider('Nº Linhas Kernel: ',
                        state.kernelSize.rows.toDouble(), 0, 100, (value) {
                      controller.setKernel(KernelSize(
                          value.toInt(), state.kernelSize.columns.toInt()));
                    }),
                    slider('Nº Colunas Kernel: ',
                        state.kernelSize.columns.toDouble(), 0, 100, (value) {
                      controller.setKernel(KernelSize(
                          state.kernelSize.rows.toInt(), value.toInt()));
                    }),
                    slider('Nº Iterações: ', state.iterations.toDouble(), 0, 10,
                        (value) {
                      controller.setIterations(value.toInt());
                    }),
                  ],
                ),
                buttomActionsWidget(
                    '${state.transformation.value}_${DateTime.now().millisecondsSinceEpoch}',
                    MorphologicalModel(
                        iterations: state.iterations,
                        kernelSize: state.kernelSize,
                        transformation: state.transformation,
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
