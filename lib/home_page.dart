import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/home_widgets.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/widgets/blur_widget.dart';
import 'package:opencv_app/image_process/widgets/canny_widget.dart';
import 'package:opencv_app/image_process/widgets/colorspace_widget.dart';
import 'package:opencv_app/image_process/widgets/edges_widget.dart';
import 'package:opencv_app/image_process/widgets/morphological_widget.dart';
import 'package:opencv_app/image_process/widgets/threshold_widget.dart';
import 'package:opencv_app/theme.dart';
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with HomeWidgets {
  final ImageProcessController _imageProcessController = Modular.get();

  late final Map<String, Widget Function(File i)> processesWidgetList;

  @override
  void initState() {
    processesWidgetList = <String, Widget Function(File i)>{
      'Suavização': (File i) => BlurWidget(
            editImage: i,
          ),
      'Conversão de cor': (File i) => ColorSpaceWidget(
            editImage: i,
          ),
      'Threshold': (File i) => ThresholdWidget(
            editImage: i,
          ),
      'Bordas': (File i) => EdgesWidget(
            editImage: i,
          ),
      'Canny': (File i) => CannyWidget(
            editImage: i,
          ),
      'Morfologia': (File i) => MorphologicalWidget(
            editImage: i,
          ),
    };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      drawer: Drawer(
        child: optionsList(processesWidgetList),
      ),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'OpenCV App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<ImageProcessController, ImageProcessState>(
          bloc: _imageProcessController,
          builder: (context, state) => Column(children: [
                Expanded(
                  child: state.historic.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          child: const Text(
                            "Tire uma foto ou acesse a galeria",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 23),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Imagem: ${basename(state.selectedImage?.path ?? state.historic.first.path).split('_')[0]}",
                                      style: AppTheme.defaultTitleText,
                                      textAlign: TextAlign.center,
                                    ),
                                    Container(
                                        height: 100,
                                        margin: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: Colors.black, width: 2)),
                                        child: Image.file(
                                          fit: BoxFit.fitHeight,
                                          state.historic.first,
                                        )),
                                  ],
                                ),
                              ),
                              Flexible(
                                child: Center(
                                  child: Container(
                                      margin: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black, width: 2)),
                                      child: Image.file(state.selectedImage ??
                                          state.historic.last)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: ElevatedButton(
                                    onPressed: () {
                                      Scaffold.of(context).openDrawer();
                                    },
                                    child: const Text("Aplicar Processamento")),
                              )
                            ]),
                ),
                Container(
                  color: AppColors.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      iconButton(Icons.list_alt, 'Processos',
                          () => showHistoric(context)),
                      iconButton(Icons.photo_library_rounded, 'Abrir Galeria',
                          _imageProcessController.galleryPhoto),
                      iconButton(Icons.camera_alt_rounded, "Abrir camera",
                          _imageProcessController.takePhoto),
                    ],
                  ),
                )
              ])),
    );
  }
}
