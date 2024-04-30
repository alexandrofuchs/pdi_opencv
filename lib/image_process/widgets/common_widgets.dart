import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/core/common/process.dart';
import 'package:opencv_app/flutter_channel/pylib_channel_controller.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';

imageEditor(String title, Widget processWidget) {
  return Scaffold(
      appBar: AppBar(
        title: Text('Editor: $title'),
      ),
      body: Column(
        children: [
          Container(
            constraints: const BoxConstraints(maxHeight: 350),
            child: BlocBuilder<PyLibChannelController, ProcessResult>(
                bloc: Modular.get()
                  ..loadImage(Modular.get<ImageProcessController>()
                          .state
                          .selectedImage ??
                      Modular.get<ImageProcessController>()
                          .state
                          .historic
                          .last),
                builder: (context, state) => Image.file(
                      state.processed ?? state.initial!,
                    )),
          ),
          Expanded(
            child: SingleChildScrollView(
                child: Container(
              child: processWidget,
            )),
          )
        ],
      ));
}

Widget buttomActionsWidget(String imageName, ImageProcessModel processModel) =>
    Container(
      child: BlocBuilder<PyLibChannelController, ProcessResult>(
          bloc: Modular.get(),
          builder: (context, state) => state.processed == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 211, 211, 211))),
                          onPressed: () {
                            Modular.to.pop();
                          },
                          child: const Text("Voltar")),
                    ),
                    Flexible(
                      child: ElevatedButton(
                          onPressed: () {
                            Modular.get<PyLibChannelController>()
                                .processImage(imageName, processModel);
                          },
                          child: const Text("Aplicar")),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStatePropertyAll(
                                  Theme.of(context).primaryColor),
                              backgroundColor: const MaterialStatePropertyAll(
                                  Color.fromARGB(255, 211, 211, 211))),
                          onPressed: () {
                            Modular.get<PyLibChannelController>()
                                .removeProcessed();
                          },
                          child: const Text("Desfazer")),
                    ),
                    Flexible(
                      child: ElevatedButton(
                          onPressed: () {
                            Modular.get<ImageProcessController>()
                                .addProcessedImage(state.processed!);

                            Modular.to.pop();
                          },
                          child: const Text("Confirmar")),
                    ),
                  ],
                )),
    );

slider(String label, double value, double min, double max,
        void Function(double value) action) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: ${value.toInt()}'),
        Slider(
          value: value > max
              ? max
              : value < min
                  ? min
                  : value,
          min: min,
          max: max,
          onChanged: (value) {
            Modular.get<PyLibChannelController>().removeProcessed();
            action(value);
          },
          // (double value) {
          //   // Modular.get<ImageProcessController>().undoChanges();
          //   // Modular.get<BlurController>().setState(value);
          // }
        ),
      ],
    );
