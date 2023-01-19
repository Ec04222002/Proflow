// ignore_for_file: non_constant_identifier_names

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:proflow/services/hot_keys.dart';
import 'package:proflow/widgets/tools.dart';
import 'shared.dart';
import 'package:provider/provider.dart';
import 'providers/tools_provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  Tools toolProvider = Tools();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => toolProvider),
  ], child: const App()));

  await HotKeys().setInitKeys(toolProvider);
  //call set init for tools
  doWhenWindowReady(() {
    Size initialSize =
        Size(btnWidth * toolProvider.savedTools.length, defaultHeight);
    resizeUI(initialSize);
    appWindow.alignment = Alignment.topRight;
    appWindow.show();
  });
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: const ToolsUI(),
    );
  }
}
