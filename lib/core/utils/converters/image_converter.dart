import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

abstract class ImageConverter {
  static Future<File?> base64ToFile(
      {required String? name, required String? value}) async {
    try {
      if (!([name, value].every((element) => element != null))) {
        return null;
      }

      final directory = await getTemporaryDirectory();
      final decodedBytes = base64Decode(value!);
      name = name ?? 'untitled';
      var file = File("${directory.path}/$name.png");
      await file.writeAsBytes(decodedBytes);
      return file;
    } catch (e) {
      debugPrint('base64ToFile: failed to convert --> $e');
      return null;
    }
  }

  static String? fileToBase64(File? file) {
    try {
      if (file == null) {
        return null;
      }
      return base64Encode(File(file.path).readAsBytesSync());
    } catch (e) {
      debugPrint('fileToBase64: failed to convert --> $e');
      return null;
    }
  }

  static Future<File?> getFileIfExists({required String path}) async {
    try {
      if (path.isEmpty) return null;
      var file = File(path);

      if (!await file.exists()) {
        return null;
      }

      return file;
    } catch (e) {
      debugPrint('bytesToFile: failed getting file --> $e');
      return null;
    }
  }

  static Future<File?> xFileToFile(String name, XFile? xfile) async {
    try {
      final directory = await getTemporaryDirectory();
      var bytes = await xfile?.readAsBytes();
      var file = File("${directory.path}/$name.png");
      await file.writeAsBytes(bytes!);
      return file;
    } catch (e) {
      debugPrint('xFileToFile: failed to convert --> $e');
      return null;
    }
  }
}
