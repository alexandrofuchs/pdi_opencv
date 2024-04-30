import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:opencv_app/flutter_channel/pylib_channel_controller.dart';
import 'package:opencv_app/home_page.dart';
import 'package:opencv_app/image_process/controllers/image_process_controller.dart';
import 'package:opencv_app/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  return runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OpenCV App',
      theme: AppTheme.lightTheme(context),
      routerConfig: Modular.routerConfig,
    );
  }
}

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(() => PyLibChannelController());
    i.addLazySingleton(() => ImageProcessController(i()));
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomePage());
  }
}
