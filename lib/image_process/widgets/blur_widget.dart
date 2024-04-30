import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/core/common/process.dart';
import 'package:opencv_app/core/models/blur_model.dart';
import 'package:opencv_app/core/utils/converters/image_converter.dart';
import 'package:opencv_app/image_process/controllers/blur_controller.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/widgets/common_widgets.dart';
import 'package:opencv_app/theme.dart';

class BlurWidget extends StatefulWidget {
  final File editImage;
  const BlurWidget({super.key, required this.editImage});

  @override
  State<StatefulWidget> createState() => _BlurWidgetState();
}

class _BlurWidgetState extends State<BlurWidget> {
  late final BlurController controller;

  @override
  void initState() {
    controller = BlurController(widget.editImage);
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
      child: BlocBuilder<BlurController, BlurState>(
          bloc: controller,
          builder: (context, state) => Column(
                children: [
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: FilterMethod.values.length - 1,
                      itemBuilder: (context, index) {
                        index += 1;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  FilterMethod.values[index].value,
                                  style: AppTheme.defaultItemText,
                                ),
                                Radio<FilterMethod>(
                                    value: FilterMethod.values[index],
                                    groupValue: state.method,
                                    onChanged: (value) async {
                                      if (value == null) return;
                                      controller.setMethod(value);
                                    }),
                              ],
                            ),
                            index == state.method.index
                                ? switch (state.method) {
                                    FilterMethod.none => Container(),
                                    FilterMethod.averaging => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          slider(
                                              "Nº linhas kernel",
                                              state.kernelSize.rows.toDouble(),
                                              1,
                                              255, (value) {
                                            controller.setValue(
                                                kernelSize: KernelSize(
                                                    value.toInt(),
                                                    state.kernelSize.columns));
                                          }),
                                          slider(
                                              "Nº colunas kernel",
                                              state.kernelSize.columns
                                                  .toDouble(),
                                              1,
                                              255, (value) {
                                            controller.setValue(
                                                kernelSize: KernelSize(
                                                    state.kernelSize.rows,
                                                    value.toInt()));
                                          }),
                                        ],
                                      ),
                                    FilterMethod.gaussian => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          slider(
                                              "Nº linhas kernel",
                                              state.kernelSize.rows.toDouble(),
                                              1,
                                              17, (value) {
                                            controller.setValue(
                                                kernelSize: KernelSize(
                                                    value.toInt(),
                                                    state.kernelSize.columns));
                                          }),
                                          slider(
                                              "Nº colunas kernel",
                                              state.kernelSize.columns
                                                  .toDouble(),
                                              1,
                                              17, (value) {
                                            controller.setValue(
                                                kernelSize: KernelSize(
                                                    state.kernelSize.rows,
                                                    value.toInt()));
                                          }),
                                          slider("SigmaX", state.sigmaX, 0, 1,
                                              (value) {
                                            controller.setValue(sigmaX: value);
                                          }),
                                          slider("SigmaY", state.sigmaY, 0, 1,
                                              (value) {
                                            controller.setValue(sigmaY: value);
                                          }),
                                        ],
                                      ),
                                    FilterMethod.median => slider(
                                          "Tamanho Kernel",
                                          state.kernelNumber.toDouble(),
                                          1,
                                          20, (value) {
                                        controller.setValue(
                                            kernelNumber: value.toInt());
                                      }),
                                    FilterMethod.bilateral => Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          slider("d", state.d.toDouble(), 1, 20,
                                              (value) {
                                            controller.setValue(
                                                d: value.toInt());
                                          }),
                                          slider("cor sigma", state.sigmaColor,
                                              1, 255, (value) {
                                            controller.setValue(
                                                sigmaColor: value);
                                          }),
                                          slider(
                                              "espaço sigma",
                                              state.sigmaSpace.toDouble(),
                                              1,
                                              255, (value) {
                                            controller.setValue(
                                                sigmaSpace: value);
                                          }),
                                        ],
                                      ),
                                  }
                                : Container()
                          ],
                        );
                      }),
                  buttomActionsWidget(
                      '${state.method.value}${Modular.get<ImageProcessController>().state.historic.length}',
                      Blur(
                          method: state.method,
                          d: state.d,
                          kernelNumber: state.kernelNumber,
                          kernelSize: state.kernelSize,
                          sigmaColor: state.sigmaColor,
                          sigmaSpace: state.sigmaSpace,
                          sigmaX: state.sigmaX,
                          sigmaY: state.sigmaY,
                          imgBase64: ImageConverter.fileToBase64(
                              Modular.get<ImageProcessController>()
                                  .state
                                  .historic
                                  .last)!))
                ],
              )),
    );
  }
}
