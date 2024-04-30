import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/image_process/widgets/common_widgets.dart';
import 'package:opencv_app/theme.dart';
import 'package:path/path.dart';

mixin HomeWidgets {
  Widget iconButton(IconData icon, String label, Function() action) => Flexible(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton.filled(
              onPressed: action,
              color: Colors.white,
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 45,
                  ),
                  Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        ),
      );

  void showHistoric(BuildContext context) {
    List<int> selectedIndexes = [];

    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text(
                    "Processamentos",
                  ),
                ),
                body: BlocBuilder<ImageProcessController, ImageProcessState>(
                  bloc: Modular.get(),
                  builder: (context, state) => Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: state.historic.isEmpty
                            ? Center(
                                child: Text(
                                  "Nenhuma Imagem Carregada",
                                  style: AppTheme.defaultTitleText,
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.historic.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 15),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Text(
                                                    '${index + 1}',
                                                    style: AppTheme
                                                        .defaultItemText,
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Image.file(
                                                        state.historic[index])),
                                                Text(
                                                  basename(state
                                                          .historic[index].path)
                                                      .split('_')[0]
                                                      .toLowerCase(),
                                                  style:
                                                      AppTheme.defaultItemText,
                                                ),
                                              ],
                                            ),
                                            Checkbox(
                                                value: selectedIndexes
                                                    .contains(index),
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      value == true
                                                          ? selectedIndexes
                                                              .add(index)
                                                          : selectedIndexes
                                                              .remove(index);
                                                    },
                                                  );
                                                })
                                          ],
                                        ),
                                        const Divider()
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      Container(
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              selectedIndexes.length < state.historic.length &&
                                      state.historic.isNotEmpty
                                  ? iconButton(
                                      Icons.select_all, 'Selecionar tudo', () {
                                      setState(
                                        () {
                                          selectedIndexes = List.generate(
                                              state.historic.length,
                                              (index) => index);
                                        },
                                      );
                                    })
                                  : Container(),
                              selectedIndexes.isNotEmpty
                                  ? iconButton(Icons.delete_forever,
                                      'Excluir selecionado(s)', () {
                                      Modular.get<ImageProcessController>()
                                          .clearHistoric(selectedIndexes);

                                      setState(() {
                                        selectedIndexes = [];
                                      });
                                    })
                                  : Container(),
                              selectedIndexes.length == 1
                                  ? iconButton(
                                      Icons.done, 'Carregar Selecionado', () {
                                      Modular.get<ImageProcessController>()
                                          .selectImage(selectedIndexes.first);
                                      Modular.to.pop();
                                    })
                                  : Container(),
                            ],
                          ))
                    ],
                  ),
                ),
              );
            }));
  }

  Future<File?> showOptions(
      BuildContext context, String title, Widget processWidget) async {
    return await showDialog<File>(
        context: context,
        builder: (context) => imageEditor(title, processWidget));
  }

  optionsList(Map<String, Widget Function(File i)> processesWidgetList) {
    return Container(
      color: const Color.fromARGB(255, 241, 241, 241),
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          Text(
            'Opções de Processamento',
            style: AppTheme.defaultTitleText,
          ),
          const Divider(),
          Container(
            alignment: Alignment.topLeft,
            child: ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: processesWidgetList.length,
              itemBuilder: (context, index) {
                return Column(children: [
                  ListTile(
                    title: Text(
                      processesWidgetList.keys.toList()[index],
                      style: AppTheme.defaultItemText,
                    ),
                    onTap: () {
                      final widget = processesWidgetList.values.toList()[index](
                          Modular.get<ImageProcessController>()
                              .state
                              .historic
                              .last);

                      Modular.get<ImageProcessController>()
                              .state
                              .historic
                              .isNotEmpty
                          ? showOptions(context,
                              processesWidgetList.keys.toList()[index], widget)
                          : null;
                    },
                  ),
                  const Divider()
                ]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
